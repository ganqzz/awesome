local gears = require("gears")
local awful = require("awful")
local menubar = require("menubar")
menubar.utils.terminal = RC.terminal -- Set the terminal for applications that require it
local hotkeys_popup = require("awful.hotkeys_popup")

local mymainmenu = require("config.menu")
local spawn_func = require("helpers").spawn_func
local scratchpad = require("services.scratchpad")
local ctl = require("services").ctl
local mpris = require("services").mpris

local modkey = RC.modkey

-- Scratchpads
scratchpad.add {
    name = "spad_ala",
    command = "ala --class spad_ala",
    --sticky = true,
    --ontop = true,
}
scratchpad.add {
    name = "audacious",
    command = "audacious",
    autohide = true,
}
scratchpad.add {
    name = "spad_htop",
    command = "ala --class spad_htop -e htop",
}

-- Mouse bindings
--root.buttons(gears.table.join(
--    awful.button({ }, 3, function () mymainmenu:toggle() end)
--    awful.button({ }, 4, awful.tag.viewnext),
--    awful.button({ }, 5, awful.tag.viewprev)
--))

-- Key bindings
local globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    --awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    --          {description = "view previous", group = "tag"}),
    --awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
    --          {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --           {description = "show main menu", group = "awesome"}),
    awful.key({ modkey,           }, "w", spawn_func("rofi -show window -modi window"),
              {description = "show window selector", group = "launcher"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Compositor
    awful.key({ modkey, }, "^", ctl.compo_toggle, {description = "toggle compositor", group = "control"}),

    -- Brightness
    awful.key({}, "XF86MonBrightnessUp", ctl.bl_up),
    awful.key({}, "XF86MonBrightnessDown", ctl.bl_down),

    -- Volume
    awful.key({ modkey, }, "[", ctl.vol_up, {description = "volume up", group = "control"}),
    awful.key({ modkey, }, "]", ctl.vol_down, {description = "volume down", group = "control"}),
    awful.key({ modkey, }, "\\", ctl.vol_toggle, {description = "toggle mute", group = "control"}),
    awful.key({}, "XF86AudioRaiseVolume", ctl.vol_up),
    awful.key({}, "XF86AudioLowerVolume", ctl.vol_down),
    awful.key({}, "XF86AudioMute", ctl.vol_toggle),
    awful.key({}, "XF86AudioMicMute", ctl.mic_toggle),

    -- Media player
    awful.key({ modkey, }, "/", mpris.play_pause, {description = "play/pause", group = "control"}),
    awful.key({ modkey, }, ",", mpris.prev, {description = "play previous", group = "control"}),
    awful.key({ modkey, }, ".", mpris.next, {description = "play next", group = "control"}),
    awful.key({}, "XF86AudioPlay", mpris.play_pause),
    awful.key({}, "XF86AudioPrev", mpris.prev),
    awful.key({}, "XF86AudioNext", mpris.next),

    -- Standard program
    awful.key({ modkey,           }, "Return", spawn_func(RC.terminal),
              {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Control" }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Scratchpad
    awful.key({ modkey }, "t", function () scratchpad.get("spad_ala"):toggle() end,
              {description = "toggle terminal", group = "scratchpad"}),
    awful.key({ modkey }, "a", function () scratchpad.get("audacious"):toggle() end,
              {description = "toggle audacious", group = "scratchpad"}),
    awful.key({ modkey }, "b", function () scratchpad.get("spad_htop"):toggle() end,
              {description = "toggle htop", group = "scratchpad"}),
    awful.key({ modkey }, "-", scratchpad.hide_all,
              {description = "hide all scratchpads", group = "scratchpad"}),

    -- Prompt
    awful.key({ modkey }, "d", spawn_func("rofi -show drun -modi drun,run"),
        {description = "run prompt", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "d", spawn_func("rofi -show run -modi drun,run"),
        {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x", spawn_func(RC.home_dir .. ".config/rofi/powermenu.sh"),
              {description = "show exit menu", group = "awesome"}),

    -- Lua prompt
    -- awful.key({ modkey }, "x",
    --           function ()
    --               awful.prompt.run {
    --                 prompt       = "Run Lua code: ",
    --                 textbox      = awful.screen.focused().mypromptbox.widget,
    --                 exe_callback = awful.util.eval,
    --                 history_path = awful.util.get_cache_dir() .. "/history_eval"
    --               }
    --           end,
    --           {description = "lua execute prompt", group = "awesome"}),

    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- Client keybindings

RC.clientkeys = gears.table.join(
    -- move floating client
    awful.key({ modkey,           }, "Up",
        function (c) c.y = c.y - 10 end,
        {description = "move up", group = "client"}),
    awful.key({ modkey,           }, "Down",
        function (c) c.y = c.y + 10 end,
        {description = "move down", group = "client"}),
    awful.key({ modkey,           }, "Right",
        function (c) c.x = c.x + 10 end,
        {description = "move right", group = "client"}),
    awful.key({ modkey,           }, "Left",
        function (c) c.x = c.x - 10 end,
        {description = "move left", group = "client"}),
    awful.key({ modkey,           }, "Home",
        function (c)
            c.x = c.screen.workarea.x + (c.screen.workarea.width - c.width) / 2
            c.y = c.screen.workarea.y + (c.screen.workarea.height - c.height) / 2
        end,
        {description = "move to the center of the workarea", group = "client"}),

    -- move floating client to edge
    awful.key({ modkey, "Shift"   }, "Up",
        function (c) c.y = c.screen.workarea.y end,
        {description = "move to the top edge of the workarea", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Down",
        function (c) c.y = c.screen.workarea.y + c.screen.workarea.height - c.height end,
        {description = "move to the bottom edge of the workarea", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Right",
        function (c) c.x = c.screen.workarea.x + c.screen.workarea.width - c.width end,
        {description = "move to the right edge of the workarea", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Left",
        function (c) c.x = c.screen.workarea.x end,
        {description = "move to the left edge of the workarea", group = "client"}),

    -- resize floating client
    awful.key({ modkey, "Control"   }, "Up",
        function (c) c.height = c.height - 10 end,
        {description = "shrink height", group = "client"}),
    awful.key({ modkey, "Control"   }, "Down",
        function (c) c.height = c.height + 10 end,
        {description = "grow height", group = "client"}),
    awful.key({ modkey, "Control"   }, "Right",
        function (c) c.width = c.width + 10 end,
        {description = "grow width", group = "client"}),
    awful.key({ modkey, "Control"   }, "Left",
        function (c) c.width = c.width - 10 end,
        {description = "shrink width", group = "client"}),

    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    -- awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
    --           {description = "close", group = "client"}),
    awful.key({ "Mod1", }, "F4", function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey, }, "q", function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Shift" }, "f",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}) -- COMMA
    -- awful.key({ modkey, "Control" }, "m",
    --     function (c)
    --         c.maximized_vertical = not c.maximized_vertical
    --         c:raise()
    --     end ,
    --     {description = "(un)maximize vertically", group = "client"}),
    -- awful.key({ modkey, "Shift"   }, "m",
    --     function (c)
    --         c.maximized_horizontal = not c.maximized_horizontal
    --         c:raise()
    --     end ,
    --     {description = "(un)maximize horizontally", group = "client"})
)

-- Client mouse bindings

RC.clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
