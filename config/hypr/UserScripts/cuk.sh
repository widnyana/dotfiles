#!/usr/bin/bash



raw="monitoraddedv2>>1,DP-1,Xiaomi Corporation Mi monitor 5505610073182"
raw="monitoradded>>DP-1"
echo $raw | cut -d'>' -f3