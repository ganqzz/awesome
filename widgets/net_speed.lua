--
local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local awesome = awesome

local function format_bytes(bytes)
    local speed, dim
    if bytes >= 1000 then
        speed = bytes / 1000
        dim = 'K'
    else
        speed = bytes
        dim = 'B'
    end
    return string.format('<b>%.f</b><small><i>%s</i></small>', speed, dim)
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
