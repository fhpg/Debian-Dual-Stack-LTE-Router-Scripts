#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/ltehayes.sh"

. $CONNINFO

if [ "$HANDLE4" != "" ] ; then
  qmicli -d $WDM -p --wds-stop-network=$HANDLE4 --client-cid=$CID4
fi
if [ "$HANDLE6" != "" ] ; then
  qmicli -d $WDM -p --wds-stop-network=$HANDLE6 --client-cid=$CID6
fi

hayes 'AT+CGATT=0'

ip -4 addr flush $WWAN scope global
ip -6 addr flush scope global
ip -6 route flush dev $WWAN
if [ "$IP6PFX" != "" ] ; then
  ip -6 route flush match "$IP6PFX::"
fi

nft delete table ip t1
nft delete table inet t2
nft delete table inet t3

echo -n "" > $CONNINFO

for i in {17..22} ; do
  qmicli -p -d $WDM --wds-noop --client-cid=$i
done
