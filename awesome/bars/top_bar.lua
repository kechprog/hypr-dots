pcall(require, "luarocks.loader")
require("awful.autofocus")
require("awful.hotkeys_popup.keys")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local func_keys = require("func_keys")


local TERMINAL = "kitty"
local MODKEY = "Mod1"


-- launcher widget
local mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = awful.menu({ items = {
    { "open terminal", TERMINAL },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
  } })
})


local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({ MODKEY }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ MODKEY }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.screen.connect_for_each_screen(function(s)
  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[0])

  -- widget with all tags
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- clock widget
  local mytextclock = wibox.widget.textclock()
  local cal_wid = require("widgets.calendar.calendar")
  local cw = cal_wid {
    theme = 'catppuccin',
    placement = 'top',
    start_sunday = false,
    radius = 8,
    previous_month_button = 1,
    next_month_button = 3,
  }
  mytextclock:connect_signal("button::press",
    function(_, _, _, button)
      if button == 1 then cw.toggle() end
    end)




  -- battery widget
  local bat = require "widgets.awesome-wm-widgets.batteryarc-widget.batteryarc" {
    font = 'Caskaydia Cove Nerd Font',
    arc_thickness = 2,
    show_current_level = false,
    size = 20,
    timeout = 60,
    main_color = '#a6da95',
    medium_level_color = '#eed49f',
    low_level_color = '#ed8796',
    charging_color = '##91d7e3',
  }
  



  -- layout widget
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function() awful.layout.inc(1) end),
    awful.button({}, 3, function() awful.layout.inc(-1) end),
    awful.button({}, 4, function() awful.layout.inc(1) end),
    awful.button({}, 5, function() awful.layout.inc(-1) end)
  ))

  -- Create an actual bar
  s.mywibox = awful.wibar({ position = "top", screen = s }):setup {
    layout = wibox.layout.align.horizontal,

    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,

      mylauncher,
      s.mytaglist,
    },

    { -- Middle widget,
      layout = wibox.layout.align.horizontal,
      expand = "none",
      nil,
      mytextclock,
      nil,
    },

    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,

      wibox.widget.systray(), -- god knows what is it.
      bat,
      s.mylayoutbox,
    },
  }
end)
