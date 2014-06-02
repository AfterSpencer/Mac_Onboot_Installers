#!/bin/sh

# Find version of OSX
HOST_SW_VERS=`/usr/bin/defaults read "$3/System/Library/CoreServices/SystemVersion" ProductVersion | awk -F '.' '{ print $1"."$2 }' `
# Find which ethernet adaptor is associated with Wireless for 
WIFIEN=`networksetup -listallhardwareports | grep -A 2 Wi-Fi | grep Device | awk '{ print $NF }'`
SSID="ssid"
PSK="psk"

echo $HOST_SW_VERS
case $HOST_SW_VERS in

10.9 | 10.8 | 10.7)
/usr/sbin/networksetup -setairportnetwork $WIFIEN $SSID $PSK
;;

10.6)
/usr/sbin/networksetup -addpreferredwirelessnetworkatindex Airport $SSID 0 WPA $PSK
;;
*)
echo "OS Not supported"
;;
esac

