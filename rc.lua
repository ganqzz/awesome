-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")

require "config.error_handling"

-- {{{ Variable definitions
-- *** Global data ***
RC = {}

-- directory variables must have a trailing slash
RC.env = require("_env")
RC.home_dir = os.getenv("HOME") .. "/"
RC.conf_dir = gears.filesystem.get_configuration_dir()
RC.icons_dir = RC.conf_dir .. "assets/icons/"
RC.terminal = "ala" -- alacritty wrapper
RC.editor = "nvim"
RC.modkey = "Mod4"

-- Themes define colours, icons, font and wallpapers.
beautiful.init(RC.conf_dir .. "config/theme.lua")

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}
-- }}}

local services = require("services")
services.sys_stats.net.interface = RC.env.interface

require "config.mainbar"
require "config.keybindings"
require "config.rules"
require "config.signals"
require "config.autostart"

-- GC settings (Lua < 5.4)
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
-- collectgarbage("incremental", 110, 1000) -- Lua 5.4
