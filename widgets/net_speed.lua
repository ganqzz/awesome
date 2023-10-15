--
local wibox = require("wibox")
local awesome = awesome

local function format_bytes(bytes)
    if bytes >= 1000000 then
        return string.format("<b>%.1f</b><small><i>M</i></small>", bytes / 1000000)
    elseif bytes >= 1000 then
        return string.format("<b>%.1f</b><small><i>K</i></small>", bytes / 1000)
    else
        return string.format("<b>%.0f</b>", bytes)
    end
end

local function new(args)
    args = args or {}
    local interface = args.interface or '*'

    local net_widget = wibox.widget {
        {
            {
                markup = '<big><b>↓</b></big>',
                widget = wibox.widget.textbox
            },
            {
                id = 'rx_speed',
                align = 'right',
                widget = wibox.widget.textbox
            },
            layout = wibox.layout.align.horizontal,
        },
        {
            {
                markup = '<big><b>↑</b></big>',
                widget = wibox.widget.textbox
            },
            {
                id = 'tx_speed',
                align = 'right',
                widget = wibox.widget.textbox
            },
            layout = wibox.layout.align.horizontal,
        },
        forced_width = 120,
        spacing = 4,
        layout = wibox.layout.flex.horizontal,
        set_speed = function(self, rx, tx)
            self:get_children_by_id('rx_speed')[1].markup = format_bytes(rx)
            self:get_children_by_id('tx_speed')[1].markup = format_bytes(tx)
        end,
    }

    local update = function(rx_speed, tx_speed)
        net_widget:set_speed(rx_speed, tx_speed)
    end

    awesome.connect_signal("net_stats::update", update)
    awesome.emit_signal("net_stats::start")

    return net_widget
end

return new
