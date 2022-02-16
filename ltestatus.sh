#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/ltehayes.sh"

. $CONNINFO

qmicli -d $WDM -p --wds-get-current-settings --client-cid=$CID4 --client-no-release-cid
qmicli -d $WDM -p --wds-get-current-settings --client-cid=$CID6 --client-no-release-cid
ping -4 -c 1 $PING4HOST
ping -6 -c 1 $PING6HOST
