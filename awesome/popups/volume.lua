local gears = require 'gears'
local wibox = require 'wibox'
local awful = require 'awful'


local exec           = function(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return result
end

M                    = {}

M.volume_popup       = nil
M.volume_progressbar = nil
M.volume_timer       = nil
M.timeout            = 2
M.VOL_DELTA          = 10
M.WIDTH              = 300
M.HEIGHT             = 200
M.PROGRESS_BAR_HEIGHT = 20

function M.display_volume(volume)
    if M.volume_timer ~= nil then
        M.volume_timer:stop()
    end
    M.volume_timer = gears.timer {
            timeout = 2,
            callback = function()
                M.volume_popup.visible = false
                M.volume_popup = nil
                M.volume_progressbar = nil
            end }
    M.volume_timer:start()

    if M.volume_popup == nil then

        -- progress bar
        M.volume_progressbar = wibox.widget {
                max_value     = 100,
                value         = volume,
                widget        = wibox.widget.progressbar,
                forced_width  = M.WIDTH,
                forced_height = M.PROGRESS_BAR_HEIGHT,
            }
        
        ----                rest of the widget                       ----
        local image = '/home/ed/.config/awesome/assets/volume_unmute.png'
        local image_widget = wibox.widget {
            { -- image
                image = image,
                resize = true,
                widget = wibox.widget.imagebox,
                forced_width = M.WIDTH,
                forced_height = M.HEIGHT,
            },
            align = 'center',
            valign = 'center',
            widget = wibox.container.place,
        }

        -- the one combining widgets
        local wid = wibox.widget {
                {
                    {
                    image_widget,
                    M.volume_progressbar,
                    layout = wibox.layout.fixed.vertical,
                    },
                    margins = 10,
                    widget = wibox.container.margin,
                },
                widget = wibox.container.background,
        }

        ----                popup                   ----
        M.volume_popup = awful.popup {
                widget = wid,
                border_color = "#777777",
                border_width = 1,
                placement    = awful.placement.centered,
                ontop        = true,
                visible      = true,
                shape        = gears.shape.rounded_rect,
            }
    
    else
        M.volume_progressbar:set_value(volume)
    end
end

function M.vol_up()
    local vol = tonumber(exec("pamixer --get-volume"))
    if vol == 100 then
        M.display_volume(vol);
        return
    end
    vol = vol + M.VOL_DELTA
    exec("pamixer --set-volume " .. vol)
    M.display_volume(vol)
end

function M.vol_down()
    local vol = tonumber(exec("pamixer --get-volume"))
    if vol == 0 then
        M.display_volume(vol);
        return
    end
    vol = vol - M.VOL_DELTA
    exec("pamixer --set-volume " .. vol)
    M.display_volume(vol)
end

function M.vol_toggle_mute()
    local result = exec("pamixer --toggle-mute")
    local mute = exec("pactl get-sink-mute @DEFAULT_SINK@ | grep -oP '(?<=Mute: ).*'")

    if mute == "yes\n" then
        M.display_volume("mute")
    else
        M.display_volume("NOT mute")
    end
end

return M