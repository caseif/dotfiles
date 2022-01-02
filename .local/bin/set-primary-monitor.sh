#!/usr/bin/env bash

if [ -z "${WAYLAND_DISPLAY}" ]; then
    sleep 3
    xrandr --output DP-3 --primary
fi
