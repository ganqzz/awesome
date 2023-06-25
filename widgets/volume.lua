--
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("helpers")
local ctl = require("services").ctl

local function new(args)
    args = args or {}

    local w = wibox.widget {
        {
            {
                id = "icon",
                resize = true,
                widget = wibox.widget.imagebox,
            },
            top = 2,
            bottom = 2,
            layout = wibox.container.margin
        },
        {
            id = 'txt',
            widget = wibox.widget.textbox
        },
        layout = wibox.layout.fixed.horizontal,
    }

    -- initial values
    w.is_muted = true
    w.volume = 0

    function w:update(data)
        if data[1] == 'yes' then
            self.is_muted = true
        elseif data[1] == 'no' then
            self.is_muted = false
        end -- else no change

        if data[2] then
            self.volume = data[2]
            self:get_children_by_id('txt')[1].markup = string.format("<small>%3d</small>", self.volume)
        end

        if self.volume >= 0 and self.volume < 20 then
            self.volume_icon_name = "volume"
        elseif self.volume < 70 then
            self.volume_icon_name = "volume-1"
        else
            self.volume_icon_name = "volume-2"
        end

        if self.is_muted then
            self.volume_icon_name = "volume-x"
        end
        self:get_children_by_id('icon')[1].image = RC.icons_dir .. self.volume_icon_name .. '.svg'
    end

    w:buttons(
        awful.util.table.join(
            awful.button({}, 1, ctl.vol_toggle),
            awful.button({}, 2, ctl.mixer),
            awful.button({}, 3, ctl.vol_get),
            awful.button({}, 4, ctl.vol_up),
            awful.button({}, 5, ctl.vol_down)
        )
    )

    awesome.connect_signal("volume::update", function(data) w:update(data) end)

    ctl.vol_get()

    return w
end

return new
