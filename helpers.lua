local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local capi = { mouse = mouse }

local helpers = {}

-- Split string
-- empty elements are ignored => use `gears.string.split`
-- this may work with "\n" separator
function helpers.split(text, separator)
    local separator = separator or "%s"
    local t = {}
    for str in string.gmatch(text, "([^" .. separator .. "]+)") do
        table.insert(t, str)
    end
    return t
end

-- Ellipsize string (UTF-8)
function helpers.ellipsize(text, length)
    text = text or ""
    length = (length and length > 0) and length or 10
    return utf8.len(text) > length
        and string.sub(text, 1, utf8.offset(text, length) - 1) .. "…"
        or text
end

-- * These strip functions return nil if inputs consist of spaces only
-- Remove spaces( \t\n\r) from the beginning
function helpers.lstrip(s)
    return string.match(s, '^%s*(%S.*)$')
end

-- Remove spaces( \t\n\r) from the ending
function helpers.rstrip(s)
    return string.match(s, '^(.*%S)%s*$')
end

-- Remove spaces( \t\n\r) from the both edges
function helpers.strip(s)
    return string.match(s, '^%s*(.-)%s*$')  -- `-` means "shortest match"
end

-- Checks if a string starts with a another string
function helpers.starts_with(str, start)
    return str:sub(1, #start) == start
end

-- Wrap spawn command
function helpers.spawn_func(cmd)
    return function() awful.spawn(cmd) end
end

-- Create and start a timer task for Lua routine
function helpers.start_timer_task(timeout, task)
    local t = gears.timer {
        timeout = timeout,
        call_now = true,
        callback = task
    }
    t:start()
    return t
end

-- Create and start a timer of command task
function helpers.watch(cmd, timeout, callback)
    local t = gears.timer { timeout = timeout, call_now = true }
    t:connect_signal("timeout", function()
        t:stop()
        awful.spawn.easy_async(cmd, function(stdout, stderr, exitreason, exitcode)
            callback(stdout, stderr, exitreason, exitcode)
            t:again()
        end)
    end)
    t:start()
    t:emit_signal("timeout")
    return t
end

-- Run program

function helpers.pgrep_apply(cmd, yes, no)
    awful.spawn.easy_async_with_shell(string.format("pgrep -c -u $USER -x %s", cmd), function(stdout)
        if tonumber(stdout) > 0 then
            if yes then yes() end
        else
            if no then no() end
        end
    end)
end

function helpers.run_single_instance(cmd, props, findme)
    helpers.pgrep_apply(findme or cmd, nil, function() awful.spawn(cmd, props) end)
end

function helpers.run_single_instance_cmdline(cmdline)
    local cmd = cmdline
    local firstspace = cmdline:find(" ")
    if firstspace then
        cmd = cmdline:sub(0, firstspace - 1)
    end
    awful.spawn.easy_async_with_shell(string.format("pgrep -u $USER -x %s > /dev/null 2>&1 || %s", cmd, cmdline))
end

-- UI helpers

function helpers.wrap_margins(w, margins)
    margins = margins or {}
    return wibox.widget {
        w,
        top = margins.top or nil,
        bottom = margins.bottom or nil,
        left = margins.left or nil,
        right = margins.right or nil,
        widget = wibox.container.margin
    }
end

function helpers.wrap_margin_bg(w, margins, bg, shape)
    return wibox.widget {
        helpers.wrap_margins(w, margins),
        bg = bg or beautiful.bg_normal,
        shape = shape or nil,
        widget = wibox.container.background
    }
end

function helpers.colorize_text(text, color)
    color = color or beautiful.fg_normal
    return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

function helpers.add_hover_cursor(w, hover_cursor)
    local original_cursor = "left_ptr"

    w:connect_signal("mouse::enter", function()
        local widget = capi.mouse.current_wibox
        if widget then
            widget.cursor = hover_cursor
        end
    end)

    w:connect_signal("mouse::leave", function()
        local widget = capi.mouse.current_wibox
        if widget then
            widget.cursor = original_cursor
        end
    end)
end

function helpers.screen_mask(s, bg)
    local mask = wibox {
        visible = false,
        ontop = true,
        type = "splash",
        screen = s,
        bg = bg,
    }
    awful.placement.maximize(mask)
    return mask
end

-- shape functions

function helpers.rrect(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

function helpers.pie(width, height, start_angle, end_angle, radius)
    return function(cr)
        gears.shape.pie(cr, width, height, start_angle, end_angle, radius)
    end
end

function helpers.prgram(height, base)
    return function(cr, width)
        gears.shape.parallelogram(cr, width, height, base)
    end
end

function helpers.prrect(radius, tl, tr, br, bl)
    return function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
    end
end

return helpers
