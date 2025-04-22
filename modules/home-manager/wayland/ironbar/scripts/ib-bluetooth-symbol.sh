#!/usr/bin/env bash

BLU_CNT_CONTROLLER=$(ls /sys/class/bluetooth | wc -l)

if [[ $BLU_CNT_CONTROLLER -gt 0 ]]
then
    BLU_POWER=$(bluetoothctl show | grep -q 'Powered: yes$'; echo "$?")
    if [[ $BLU_POWER -eq 0 ]]
    then
        BLU_CONNECTED=$(bluetoothctl devices Connected | cut -d ' ' -f3-)
        BLU_CONNECTED_MAC=$(bluetoothctl devices Connected | cut -d ' ' -f2)
        DEV_BATTERY=$(echo "info $BLU_CONNECTED_MAC" | bluetoothctl | sed -n '/Battery Percentage:/ s/.*(\([0-9]*\).*/\1/p')
        if [[ $BLU_CONNECTED != "" ]]
        then
            echo " $BLU_CONNECTED $DEV_BATTERY%"
        else
            echo " None"
        fi
    else 
        echo "󰂲 Off"
    fi
else
    echo "󰂲 No controller"
fi
