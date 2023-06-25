local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")

-- Volume/Backlight controller service
local ctl = {
    mixer_cmd = "pavucontrol",
    vol_step = 5,
    bl_step = 5,
}

local function notify_vol(stdout)
    local sts = gears.string.split(stdout, ":") -- mute: yes/no or blank, volume: intteger
    awesome.emit_signal("volume::update", { sts[1], tonumber(sts[2]) })
end

function ctl.vol_up()
    awful.spawn.easy_async("ctl vol up " .. ctl.vol_step, notify_vol)
end

function ctl.vol_down()
    awful.spawn.easy_async("ctl vol down " .. ctl.vol_step, notify_vol)
end

function ctl.vol_get()
    awful.spawn.easy_async("ctl vol get", notify_vol)
end

function ctl.vol_toggle()
    awful.spawn.easy_async("ctl vol toggle", notify_vol)
end

function ctl.mixer()
    awful.spawn(ctl.mixer_cmd)
end

function ctl.mic_toggle()
    awful.spawn("ctl mic toggle")
end

function ctl.bl_up()
    awful.spawn("ctl bl up " .. ctl.bl_step)
end

function ctl.bl_down()
    awful.spawn("ctl bl down " .. ctl.bl_step)
end

function ctl.compo_toggle()
    awful.spawn("ctl compo")
end

return ctl
