--
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local logout_widget = wibox.widget {
    {
        {
            image = RC.icons_dir .. 'power.svg',
            resize = true,
            widget = wibox.widget.imagebox,
        },
        -- top = 4,
        -- bottom = 4,
        -- right = 4,
        -- left = 4,
        layout = wibox.container.margin
    },
    shape = gears.shape.circle,
    widget = wibox.container.background,
}

local rows = wibox.widget {
    layout = wibox.layout.fixed.vertical
}

local popup = awful.popup {
    ontop = true,
    visible = false,
    maximum_width = 200,
    offset = { y = 5 },
    widget = rows
}

local function new(args)
    args = arg or {}

    -- TODO import from config.menu
    local exit_menu = {
        { text = 'Lock',      icon = 'lock.svg',       cmd = function() awful.spawn("loginctl lock-session") end },
        { text = 'Log out',   icon = 'log-out.svg',    cmd = awesome.quit },
        { text = 'Suspend',   icon = 'moon.svg',       cmd = function() awful.spawn("systemctl suspend") end },
        { text = 'Reboot',    icon = 'refresh-cw.svg', cmd = function() awful.spawn("systemctl reboot") end },
        { text = 'Power off', icon = 'power.svg',      cmd = function() awful.spawn("systemctl poweroff") end },
    }

    for _, item in ipairs(exit_menu) do
        local row = wibox.widget {
            {
                {
                    {
                        image = RC.icons_dir .. item.icon,
                        resize = false,
                        widget = wibox.widget.imagebox
                    },
                    {
                        text = item.text,
                        widget = wibox.widget.textbox
                    },
                    spacing = 12,
                    layout = wibox.layout.fixed.horizontal
                },
                margins = 8,
                layout = wibox.container.margin
            },
            bg = beautiful.bg_normal,
            widget = wibox.container.background
        }

        local old_cursor, old_wibox
        row:connect_signal("mouse::enter", function(c)
            c:set_bg(beautiful.bg_focus)

            local wb = mouse.current_wibox
            old_cursor, old_wibox = wb.cursor, wb
            wb.cursor = "hand2"
        end)
        row:connect_signal("mouse::leave", function(c)
            c:set_bg(beautiful.bg_normal)

            if old_wibox then
                old_wibox.cursor = old_cursor
                old_wibox = nil
            end
        end)

        row:buttons(awful.util.table.join(awful.button({}, 1, function()
            popup.visible = false
            item.cmd()
        end)))

        rows:add(row)
    end

    logout_widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                if popup.visible then
                    popup.visible = false
                    -- logout_widget:set_bg('#00000000')
                else
                    popup:move_next_to(mouse.current_widget_geometry)
                    -- logout_widget:set_bg(beautiful.bg_focus)
                end
            end)
        )
    )

    return logout_widget
end

return setmetatable(logout_widget, { __call = function(_, ...) return new(...) end })
