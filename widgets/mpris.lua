--
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local tooltip = require("widgets.tooltip")
local mpris_svc = require("services.mpris")

local status_table = {
    ["Playing"] = "🎵",
    ["Paused"] = "⏸",
    ["Stopped"] = "■",
    ["Unknown"] = "🗙",
}

local current_player = ""

local row_list = wibox.widget {
    spacing = 8,
    layout = wibox.layout.fixed.vertical
}

local player_popup = awful.popup {
    bg = beautiful.bg_normal,
    ontop = true,
    visible = false,
    maximum_width = 500,
    offset = { y = 5 },
    hide_on_right_click = true,
    widget = {
        row_list,
        margins = 6,
        layout = wibox.container.margin
    }
}

local create_row = function(player)
    local row = wibox.widget {
        {
            checked       = player == current_player,
            color         = beautiful.bg_normal,
            paddings      = 3,
            shape         = gears.shape.circle,
            forced_width  = 20,
            forced_height = 20,
            check_color   = beautiful.fg_urgent,
            widget        = wibox.widget.checkbox
        },
        {
            text = player,
            align = 'left',
            widget = wibox.widget.textbox
        },
        spacing = 10,
        fill_space = true,
        layout = wibox.layout.fixed.horizontal
    }
    return row
end

local function refresh_player_list()
    awful.spawn.easy_async("playerctl -l", function(stdout)
        row_list:reset() -- remove all children
        for player in stdout:gmatch("[^\n]+") do
            if player ~= nil and player ~= "" then
                -- set first player as default if not set
                if current_player == "" then current_player = player end
                local row = create_row(player)
                row:connect_signal("button::press", function()
                    current_player = player
                    -- TODO change player (mpris_svc)
                    refresh_player_list()
                end)
                row_list:add(row)
            end
        end
    end)
end

local function convert_time_to_dec(sec)
    local h, m, s
    h = math.floor(sec / 3600)
    local rem = sec - h * 3600
    m = math.floor(rem / 60)
    s = math.floor(rem - m * 60 + 0.5) -- round
    return h, m, s
end

local function new(args)
    args = args or {}

    -- main widget
    local mpris_widget = wibox.widget {
        --font = "sans 9",
        widget = wibox.widget.textbox
    }

    -- Music info tooltip
    local music_info_widget = wibox.widget {
        --font = "sans 9",
        widget = wibox.widget.textbox
    }

    local music_info_popup = tooltip(mpris_widget, { widget = music_info_widget, margins = 10 })

    local function update(player_info)
        -- TODO art_url
        local status_text = status_table[player_info.status] or "✗"
        local len_h, len_m, len_s = convert_time_to_dec(player_info.length / 1000000)
        mpris_widget.text = string.format("%s %s", status_text, helpers.ellipsize(player_info.title, 15))
        music_info_widget.markup = string.format(
            "[Title]: <b>%s</b>\n[Artist]: <b>%s</b>\n[Album]: <b>%s</b>\n[Length]: <b>%d</b>:<b>%02d</b>:<b>%02d</b>",
            player_info.title, player_info.artist, player_info.album, len_h, len_m, len_s)
    end

    mpris_widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, mpris_svc.play_pause),
            awful.button({}, 3, function()
                if player_popup.visible then
                    player_popup.visible = false
                else
                    refresh_player_list()
                    player_popup:move_next_to(mouse.current_widget_geometry)
                end
                music_info_popup.visible = false
            end),
            awful.button({}, 4, mpris_svc.prev), -- Up
            awful.button({}, 5, mpris_svc.next) -- Down
        )
    )

    awesome.connect_signal("mpris::update", update)

    mpris_svc.start()

    return mpris_widget
end

return new
