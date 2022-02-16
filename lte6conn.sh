#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/ltehayes.sh"

CID6=$(qmicli -p -d $WDM --wds-noop --client-no-release-cid | grep CID | cut -d "'" -f 2)
qmicli -p -d $WDM --wds-set-ip-family=6 --client-no-release-cid --client-cid=$CID6
HANDLE6=$(qmicli -p -d $WDM --device-open-net='net-raw-ip|net-no-qos-header' --wds-start-network='3gpp-profile=$PROFILE,ip-type=6' --client-no-release-cid  --client-cid=$CID6 | grep -i 'Packet data handle' | cut -d "'" -f 2)
if [ "$HANDLE6" != "" ] ; then
  qmicli -p -d $WDM --client-no-release-cid --wds-get-current-settings --client-cid=$CID6
  IP6=$(qmicli -p -d $WDM --client-no-release-cid --wds-get-current-settings --client-cid=$CID6 | grep 'IPv6 address' | cut -d ':' -f 2- | sed 's/ //g')
  GW6NET=$(qmicli -p -d $WDM --client-no-release-cid --wds-get-current-settings --client-cid=$CID6 | grep 'IPv6 gateway address' | cut -d ':' -f 2- | sed 's/ //g')
  GW6IP=$(echo $GW6NET | cut -d '/' -f 1)
  IP6PFX=$(echo $GW6NET | cut -d ':' -f -4)
  MTU=$(qmicli -p -d $WDM --client-no-release-cid --wds-get-current-settings --client-cid=$CID6 | grep 'MTU' | cut -d ':' -f 2- | sed 's/ //g')
  ip link set $WWAN mtu $MTU
  ip -6 addr add dev $WWAN $IP6 noprefixroute
  ip -6 route add $GW6IP dev $WWAN
  ip -6 route add default via $GW6IP dev $WWAN
  ip -6 addr add dev $LOCIF "$IP6PFX::1/64"
  ip -6 route show
  echo "HANDLE6=$HANDLE6" >> $CONNINFO
  echo "CID6=$CID6" >> $CONNINFO
  echo "IP6=$IP6" >> $CONNINFO
  echo "GW6NET=$GW6NET" >> $CONNINFO
  echo "GW6IP=$GW6IP" >> $CONNINFO
  echo "IP6PFX=$IP6PFX" >> $CONNINFO
  echo "MTU=$MTU" >> $CONNINFO
fi
