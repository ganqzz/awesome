local awful = require("awful")
local helpers = require("helpers")

-- Autostart services
-- awful.spawn(RC.home_dir .. "/dotfiles/lib/xautostart")

if RC.env.picom then
    awful.spawn.single_instance("picom -b")
end

awful.spawn.single_instance("nm-applet")

if RC.env.bluetooth then
    awful.spawn.single_instance("blueman-applet")
end

if RC.env.locker then
    awful.spawn.single_instance("xss-lock -l -- lockscreen")
end

-- Autostart apps
helpers.run_single_instance("thunar", { tag = "参" })

if RC.env.audacious then
    helpers.pgrep_apply("audacious", nil, function()
        require("services").scratchpad.get("audacious"):spawn_client(true)
    end)
end

helpers.run_single_instance(RC.terminal, { tag = "壱" }, "alacritty")
-- helpers.run_single_instance("vivaldi", { tag = "弐" }, "vivaldi-bin")
