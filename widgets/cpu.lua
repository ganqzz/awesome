--
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local tooltip = require("widgets.tooltip")
local awesome = awesome

local cpu_rows = wibox.widget {
    spacing = 4,
    layout = wibox.layout.fixed.vertical
}

local function create_textbox(args)
    args = args or {}
    return wibox.widget {
        id = args.id,
        text = args.text,
        markup = args.markup,
        align = args.align,
        forced_width = args.forced_width,
        widget = wibox.widget.textbox
    }
end

local function new(args)
    args = args or {}

    local color = args.color or beautiful.fg_normal
    local background_color = args.background_color or beautiful.bg_normal
    local threshold = 0.9

    local freq_tb = create_textbox { align = 'right' }
    local cpu_graph = wibox.widget {
        max_value = 100,
        min_value = 0,
        background_color = background_color,
        forced_width = 150,
        forced_height = 30,
        border_width = 1,
        border_color = beautiful.bg_minimize,
        step_width = 2,
        step_spacing = 1,
        color = "linear:0,0:0,20:0,#ff0000:0.3,#ffff00:0.6," .. color,
        widget = wibox.widget.graph
    }

    local cpu_widget = wibox.widget {
        freq_tb,
        -- forced_width = 95,
        bg = background_color,
        widget = wibox.container.background
    }

    -- CPU stats tooltip
    local tt_widget = {
        {
          -- By default graph widget goes from left to right
            cpu_graph,
            reflection = { horizontal = true },
            layout = wibox.container.mirror
        },
        -- {
        --     orientation = 'horizontal',
        --     forced_height = 10,
        --     color = beautiful.bg_focus,
        --     widget = wibox.widget.separator
        -- },
        -- cpu_rows,
        spacing = 4,
        layout = wibox.layout.fixed.vertical
    }
    local tt = tooltip(cpu_widget, {
        widget = tt_widget,
        maximum_width = 300,
        margins = 8,
        pinnable = true,
    })

    awesome.connect_signal("cpu_stats::update", function(data)
        cpu_graph:add_value(data.cores[1].usage)
        freq_tb.markup = string.format("<b>%5.1f</b><small><i>%%</i></small>", data.cores[1].usage)
        -- freq_tb.markup = string.format("<b>%.1f</b><small><i>%%</i></small> <b>%.2f</b><small><i>GHz</i></small>", data.cores[1].usage, data.freq)
        -- if data.freq / data.max_freq > threshold then
        --     cpu_widget.bg = beautiful.bg_urgent
        -- else
        --     cpu_widget.bg = background_color
        -- end
    end)

    awesome.emit_signal("cpu_stats::start")

    return cpu_widget
end

return new
