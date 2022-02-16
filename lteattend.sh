#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/ltehayes.sh"

#ip link set $WWAN down ; ip link set $WWAN up

hayes 'AT+CGATT=1'

while [ "$(qmicli -p -d $WDM --nas-get-home-network | grep Description | cut -d "'" -f 2)" != "TDG" ] ; do
  echo "waiting for home network"
  sleep 1;
done
