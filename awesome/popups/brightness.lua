local wibox = require 'wibox'
local gears = require 'gears'
local awful = require 'awful'

local M = {}

M.brightness_popup = nil
M.brightness_progressbar = nil
M.brightness_timer = nil
M.timeout = 2
M.BRIGHTNESS_DELTA = 6

local exec    = function(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return result
end

function M.display_brightness(brightness)

    if M.brightness_timer ~= nil then
        M.brightness_timer:stop()
    end
    M.brightness_timer = gears.timer{
        timeout = 2, 
        callback = function ()
        M.brightness_popup.visible = false
        M.brightness_popup = nil
        M.brightness_progressbar = nil
    end}
    M.brightness_timer:start()

    if M.brightness_popup == nil then
        M.brightness_progressbar =          wibox.widget {
            max_value     = 100,
            value         = brightness,
            forced_height = 20,
            forced_width  = 50,
            widget        = wibox.widget.progressbar,
        }
        M.brightness_popup = awful.popup {
            widget = {
                M.brightness_progressbar,
                margins = 10,
                widget  = wibox.container.margin
            },
            border_color = "#777777",
            border_width = 1,
            placement    = awful.placement.centered,
            ontop        = true,
            visible      = true,
            shape        = gears.shape.rounded_rect,
        }
        else
            M.brightness_progressbar:set_value(brightness)
        end
end

function M.get_current_brightness()
    local brightness = exec("cat /sys/class/backlight/amdgpu_bl0/brightness")
    brightness = math.floor(tonumber(brightness) / 255 * 100)
    return brightness
end

function M.brightness_up()
    exec("light -As sysfs/backlight/amdgpu_bl0 " .. M.BRIGHTNESS_DELTA)
    local brightness = exec("cat /sys/class/backlight/amdgpu_bl0/brightness")
    brightness = math.floor(tonumber(brightness) / 255 * 100)
    M.display_brightness(brightness)
end

function M.brightness_down()
    exec("light -Us sysfs/backlight/amdgpu_bl0 " .. M.BRIGHTNESS_DELTA)
    local brightness = exec("cat /sys/class/backlight/amdgpu_bl0/brightness")
    brightness = math.floor(tonumber(brightness) / 255 * 100)
    M.display_brightness(brightness)
end

return M