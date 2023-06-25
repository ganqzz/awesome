--
-- Using `free` command instead of reading from `/proc/meminfo`
--
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local awesome = awesome

local function new(args)
    args = args or {}

    -- main widget
    local mem_widget = wibox.widget {
        --font = 'sans 9',
        widget = wibox.widget.textbox
    }

    local function update(data)
        mem_widget.markup = string.format("<b>%5.2f</b><small><i>GB</i></small>", data.used / 1048576)
    end

    awesome.connect_signal("mem_stats::update", update)
    awesome.emit_signal("mem_stats::start")

    return mem_widget
end

return new
