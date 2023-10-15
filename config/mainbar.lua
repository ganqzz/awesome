local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local mymainmenu = require("config.menu")
local helpers = require("helpers")
local widgets = require("widgets")

local modkey = RC.modkey
local env = RC.env

-- decorate margins
local function wrap_wibar(w)
    return helpers.wrap_margins(w, { top = 3, bottom = 3, left = 6, right = 6 })
end

-- Keyboard map indicator and switcher
--mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
--local mytextclock = wibox.widget.textclock("%a, %b %e, %l:%M %p")
local mytextclock = wibox.widget.textclock("%Y-%m-%d %a %H:%M")
local month_calendar = awful.widget.calendar_popup.month({ spacing = 2, margin = 6 })
month_calendar:attach(mytextclock, "tr")

-- local myclock_t = awful.tooltip {
--     objects = { mytextclock },
--     margins = 6,
--     delay_show = 0.3,
--     timeout = 10,
--     timer_function = function()
--         return os.date('%Y-%m-%d %A %H:%M')
--     end,
-- }

local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
mylauncher = wrap_wibar(mylauncher)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end)--,
    --awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    --awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end)--,
    --awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
    --awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
)

-- Widgets
local spacer = wibox.widget { forced_width = 4 }
local separator = wibox.widget.separator {
    forced_width = 10,
    color = "#888888",
    span_ratio = 0.8,
}

-- systray with margin
local systray = wibox.widget.systray()
-- systray.opacity = 0.5
local mysystray = wrap_wibar(systray)

local music_vol = wrap_wibar({
    widgets.volume(),
    separator,
    widgets.mpris(),
    layout = wibox.layout.fixed.horizontal,
})

local sysinfo = wibox.widget {
    widgets.net_speed({ interface = env.interface }),
    separator,
    widgets.cpu(),
    separator,
    widgets.mem(),
    layout = wibox.layout.fixed.horizontal,
}
if env.battery then
    sysinfo:add(separator)
    sysinfo:add(widgets.battery())
end
local sysinfo = wrap_wibar(sysinfo)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    awful.tag({ "壱", "弐", "参", "四", "五", }, s, awful.layout.suit.tile)
    awful.tag.add("六", { layout = awful.layout.suit.floating, screen = s, })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 4,
                right = 4,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        widget_template = {
            {
                {
                    {
                        {
                            id     = "icon_role",
                            widget = wibox.widget.imagebox,
                        },
                        margins = 3,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                -- margins = 3,
                left = 6,
                right = 6,
                widget = wibox.container.margin
            },
            id     = "background_role",
            widget = wibox.container.background,
        },
   }

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = beautiful.taglist_spacing,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
            spacer,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = beautiful.taglist_spacing,
            spacer,
            --mykeyboardlayout,
            music_vol,
            sysinfo,
            mysystray,
            mytextclock,
            wrap_wibar(s.mylayoutbox),
        },
    }
end)
