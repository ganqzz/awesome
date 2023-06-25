-- User theme
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")

local dpi = xresources.apply_dpi
local gfs = gears.filesystem

local themes_path = gfs.get_themes_dir()
local HOME = os.getenv("HOME")

local r_rect_func = function(cr, width, height)
    return gears.shape.rounded_rect(cr, width, height, 6)
end

local theme = {}

-- theme.font          = "sans 9"
-- theme.bold_font     = "sans bold 9"
theme.font          = "Play 10"
theme.bold_font     = "Play bold 10"
--theme.font          = "JetBrains Mono 9"
--theme.bold_font     = "JetBrains Mono bold 9"

theme.transparent = "#00000000"
theme.black = "#3B3B47"
theme.red = "#E46876"
theme.yellow = "#F2D98C"
theme.orange = "#FFA066"
theme.green = "#A8C98F"
theme.gray = "#888888"
theme.darkgray = "#555555"
theme.white = "#D3D3D3"

theme.bg_normal     = "#222222"
-- theme.bg_focus      = "#239e48"
theme.bg_focus      = "#666666"
theme.bg_urgent     = "#f02c2c"
theme.bg_minimize   = "#333333"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#eeeeee"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = theme.bg_normal

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(2)
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.bg_urgent

theme.hotkeys_fg = "#ffffff"
theme.hotkeys_modifiers_fg = "#ffffff"
theme.hotkeys_bg = "#222222"
theme.hotkeys_border_width = 0
theme.hotkeys_font = "Monospace 10"
theme.hotkeys_description_font = "Monospace 8"

theme.wibar_height = dpi(25)
theme.wibar_opacity = 0.9
-- theme.wibar_border_width = dpi(3)
-- theme.wibar_border_color = theme.transparent
-- theme.wibar_bg = theme.transparent

theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(25)
theme.menu_width  = dpi(250)
theme.menu_border_width = 0

theme.taglist_font = theme.bold_font
-- theme.taglist_shape = gears.shape.circle
-- theme.taglist_spacing = dpi(2)
theme.taglist_bg = theme.bg_normal
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_fg_focus = theme.fg_focus
theme.taglist_bg_urgent = theme.bg_urgent
-- theme.taglist_fg_occupied = theme.fg_focus
theme.taglist_fg_empty = theme.gray

theme.tasklist_disable_task_name = false
theme.tasklist_font_focus = theme.bold_font
-- theme.tasklist_shape = gears.shape.rounded_bar
-- theme.tasklist_spacing = dpi(4)
theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_bg_focus = theme.bg_focus

theme.tooltip_bg = theme.bg_normal
theme.tooltip_shape = r_rect_func

theme.notification_shape = r_rect_func
theme.notification_opacity = 0.8

-- titlebar icons
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

-- Layout icons
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Wallpaper
theme.wallpaper = HOME .. "/Pictures/bg.png"

-- Main menu icon
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.white, theme.bg_normal
)

-- Bling
theme.flash_focus_start_opacity = 0.9 -- the starting opacity
theme.flash_focus_step = 0.05         -- the step of animation

theme.tag_preview_widget_border_radius = 0        -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = 0        -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 0.5            -- Opacity of each client
theme.tag_preview_client_bg = "#000000"           -- The bg color of each client
theme.tag_preview_client_border_color = "#ffffff" -- The border color of each client
theme.tag_preview_client_border_width = 3         -- The border width of each client
theme.tag_preview_widget_bg = "#000000"           -- The bg color of the widget
theme.tag_preview_widget_border_color = "#ffffff" -- The border color of the widget
theme.tag_preview_widget_border_width = 3         -- The border width of the widget
theme.tag_preview_widget_margin = 0               -- The margin of the widget

theme.task_preview_widget_border_radius = 0        -- Border radius of the widget (With AA)
theme.task_preview_widget_bg = "#000000"           -- The bg color of the widget
theme.task_preview_widget_border_color = "#ffffff" -- The border color of the widget
theme.task_preview_widget_border_width = 3         -- The border width of the widget
theme.task_preview_widget_margin = 0               -- The margin of the widget

return theme
