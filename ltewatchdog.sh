#!/bin/bash
. /etc/lte.config

while [ "1" == "1" ] ; do
  PROFILE_PRESENT=$(qmicli -p -d $WDM --wds-get-profile-list=3gpp | grep internet.v6.telekom)
  if [ "$PROFILE_PRESENT" == "" ] ; then
    /opt/lte/lteinit.sh
  fi

  IP4CONNECTED=$(ping -4 -c 1 $PING4HOST | grep " 0% packet loss")
  IP6CONNECTED=$(ping -6 -c 1 $PING6HOST | grep " 0% packet loss")
  if [[ "$IP4CONNECTED" == "" || "$IP6CONNECTED" == "" ]] ; then
    /opt/lte/ltedisconn.sh
    /opt/lte/lteconn.sh
  fi
  sleep 70
done
