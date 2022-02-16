#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/ltehayes.sh"

#qmicli -p -d $WDM --nas-get-home-network
#qmicli -p -d $WDM --nas-get-signal-strength
qmicli -p -d $WDM --nas-get-serving-system
qmicli -p -d $WDM --nas-get-signal-info
