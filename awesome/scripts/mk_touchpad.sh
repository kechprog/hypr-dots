#!/bin/sh

# trackpad
xinput set-prop 11 309 1
xinput set-prop 11 288 1
xinput set-prop 11 306 10
xinput set-prop 11 297 0.02

#mouse
# xinput set-prop 15 293 -0.35 &

# init
echo "Init.."
# xautolock -time 20 -locker ~/.config/awesome/scripts/lock.sh
