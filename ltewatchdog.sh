#!/bin/bash
. /etc/lte.config

while [ "1" == "1" ] ; do
  ping -4 -c 1 $PING4HOST || (/opt/lte/ltedisconn.sh ; /opt/lte/lteconn.sh)
  ping -6 -c 1 $PING6HOST || (/opt/lte/ltedisconn.sh ; /opt/lte/lteconn.sh)
  sleep 300
done
