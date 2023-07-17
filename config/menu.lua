local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")

local helpers = require("helpers")
local spawn_func = helpers.spawn_func

-- Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
    { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    --{ "manual",      RC.terminal .. " -e man awesome" },
    --{ "edit config", RC.terminal .. " -e " .. RC.editor .. " " .. awesome.conffile },
    { "restart",     awesome.restart },
    { "quit",        function() awesome.quit() end },
}

local exit_sub = {
    { text = 'Lock',      icon = RC.icons_dir .. 'lock.svg',       cmd = spawn_func("loginctl lock-session") },
    { text = 'Log out',   icon = RC.icons_dir .. 'log-out.svg',    cmd = function() awesome.quit() end },
    { text = 'Suspend',   icon = RC.icons_dir .. 'moon.svg',       cmd = spawn_func("systemctl suspend") },
    { text = 'Reboot',    icon = RC.icons_dir .. 'refresh-cw.svg', cmd = spawn_func("systemctl reboot") },
    { text = 'Power off', icon = RC.icons_dir .. 'power.svg',      cmd = spawn_func("systemctl poweroff") },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", RC.terminal }
local menu_exit = { "Exit", exit_sub, RC.icons_dir .. 'power.svg' }

local mymainmenu = nil

-- Load freedesktop menu entries
local has_fdo, freedesktop = pcall(require, "freedesktop")
if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after = { menu_terminal, menu_exit }
    })
else
    mymainmenu = awful.menu({
        items = {
            menu_awesome,
            menu_terminal,
            menu_exit
        }
    })
end

return mymainmenu
