#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/ltehayes.sh"

CID4=$(qmicli -p -d $WDM --wds-noop --client-no-release-cid | grep CID | cut -d "'" -f 2)
qmicli -p -d $WDM --wds-set-ip-family=4 --client-no-release-cid --client-cid=$CID4
HANDLE4=$(qmicli -p -d $WDM --device-open-net='net-raw-ip|net-no-qos-header' --wds-start-network='3gpp-profile=$PROFILE,ip-type=4' --client-no-release-cid  --client-cid=$CID4 | grep -i 'Packet data handle' | cut -d "'" -f 2)
IP4INFO=$(qmicli -p -d $WDM --client-no-release-cid --wds-get-current-settings --client-cid=$CID4)
echo $IP4INFO
IP4=$(qmicli -p -d $WDM --client-no-release-cid --wds-get-current-settings --client-cid=$CID4 | grep 'IPv4 address' | cut -d ':' -f 2- | sed 's/ //g')
IP4MASK=$(qmicli -p -d $WDM --client-no-release-cid --wds-get-current-settings --client-cid=$CID4 | grep 'IPv4 subnet mask' | cut -d ':' -f 2- | sed 's/ //g')
IP4GW=$(qmicli -p -d $WDM --client-no-release-cid --wds-get-current-settings --client-cid=$CID4 | grep 'IPv4 gateway address' | cut -d ':' -f 2- | sed 's/ //g')
MTU=$(qmicli -p -d $WDM --client-no-release-cid --wds-get-current-settings --client-cid=$CID4 | grep 'MTU' | cut -d ':' -f 2- | sed 's/ //g')

#ip link set $LOCIF mtu $MTU
ip link set $WWAN mtu $MTU
ip addr add dev $WWAN $IP4/$IP4MASK noprefixroute
ip -4 addr show wwan0
ip route add $IP4GW dev $WWAN
ip route add default via $IP4GW dev $WWAN
ip route show
echo "HANDLE4=$HANDLE4" >> $CONNINFO
echo "CID4=$CID4" >> $CONNINFO
echo "IP4=$IP4" >> $CONNINFO
echo "IP4MASK=$IP4MASK" >> $CONNINFO
echo "IP4GW=$IP4GW" >> $CONNINFO
echo "MTU=$MTU" >> $CONNINFO
