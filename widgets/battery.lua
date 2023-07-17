--
-- Using `acpi` command instead of reading from `/sys/`
--
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local watch = awful.widget.watch

local bat_sts = {
    ["Full"]        = "↯",
    ["Unknown"]     = "⌁",
    ["Charged"]     = "↯",
    ["Charging"]    = "⚡",
    ["Discharging"] = "-"
}

local function new(args)
    args = args or {}
    local timeout = args.timeout or 10

    -- main widget
    local bat_widget = wibox.widget {
        --font = 'sans 9',
        widget = wibox.widget.textbox
    }

    bat_widget:buttons(awful.util.table.join(awful.button({}, 1, function ()
        -- awful.spawn(terminal .. " -e htop", { floating = true, placement = awful.placement.centered })
    end)))

    -- TODO: read from /sys/class/power_supply/BAT0/{status,capacity}
    local function update(widget, stdout)
        local sts, perc = stdout:match(': (%w+), (%d+)%%')
        widget.markup = string.format("<b>%s</b> <b>%d</b><small><i>%%</i></small>", bat_sts[sts], perc)
    end

    watch([[sh -c "acpi"]], timeout, update, bat_widget)

    return bat_widget
end

return new
