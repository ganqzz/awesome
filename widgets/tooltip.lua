local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local mouse = mouse

local function new(bound_widget, args)
    args = args or {}

    local popup = awful.popup {
        ontop = true,
        visible = false,
        hide_on_right_click = true,
        shape = args.shape or function(cr, width, height)
            return gears.shape.rounded_rect(cr, width, height, 8)
        end,
        border_width = args.border_width or 1,
        border_color = args.border_color or beautiful.bg_normal,
        maximum_width = args.maximum_width or nil,
        offset = { x = 5, y = 5 },
        widget = {
            args.widget,
            margins = args.margins or 0,
            layout = wibox.container.margin
        },
    }

    popup.pinnable = args.pinnable or false
    popup._pinned = false

    function popup:pin()
        self._pinned = true
        self.border_color = beautiful.bg_focus
    end

    function popup:unpin()
        self._pinned = false
        self.border_color = beautiful.bg_normal
    end

    function popup:toggle_pinned()
        if self._pinned then
            self:unpin()
        else
            self:pin()
        end
    end

    local delay_timer = gears.timer {
        timeout = args.delay_show or 0.3,
        single_shot = true,                                   -- one-shot but restartable
        callback = function()
            popup:move_next_to(mouse.current_widget_geometry) -- also visible = true
        end
    }

    bound_widget:connect_signal("mouse::enter", function()
        if not popup.visible and not delay_timer.started then
            delay_timer:start()
        end
    end)

    bound_widget:connect_signal("mouse::leave", function()
        if not popup._pinned then
            popup.visible = false
            if delay_timer.started then delay_timer:stop() end
        end
    end)

    if popup.pinnable then
        bound_widget:buttons(awful.util.table.join(awful.button({}, 1, function()
            popup:toggle_pinned()
        end)))
    end

    popup:connect_signal("property::visible", function()
        if not popup.visible then
            popup:unpin()
        end
    end)

    return popup
end

return setmetatable({}, { __call = function(_, ...) return new(...) end })
