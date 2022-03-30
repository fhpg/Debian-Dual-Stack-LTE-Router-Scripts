#!/bin/bash

while [ "1" == "1" ] ; do
  . /etc/lte.config

  PROFILE_PRESENT=$(qmicli -p -d $WDM --wds-get-profile-list=3gpp | grep internet.v6.telekom)
  if [ "$PROFILE_PRESENT" == "" ] ; then
    /opt/lte/lteinit.sh
    sleep 10
    /opt/lte/lteconn.sh
  fi

  sleep 70

  IP4CONNECTED=$(ping -4 -c 1 $PING4HOST | grep " 0% packet loss")
  IP6CONNECTED=$(ping -6 -c 1 $PING6HOST | grep " 0% packet loss")
  if [[ "$IP4CONNECTED" == "" || "$IP6CONNECTED" == "" ]] ; then
    /opt/lte/ltedisconn.sh
    sleep 20
    /opt/lte/lteconn.sh
  fi
done
