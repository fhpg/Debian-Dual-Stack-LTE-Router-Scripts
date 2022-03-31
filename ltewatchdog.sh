#!/bin/bash

/opt/lte/lteinit.sh

while [ "1" == "1" ] ; do
  . /etc/lte.config
  IP4CONNECTED=$(ping -4 -c 1 $PING4HOST | grep " 0% packet loss")
  IP6CONNECTED=$(ping -6 -c 1 $PING6HOST | grep " 0% packet loss")
  if [[ "$IP4CONNECTED" == "" || "$IP6CONNECTED" == "" ]] ; then
    date
    /opt/lte/ltedisconn.sh
    sleep 20
    /opt/lte/lteconn.sh
  fi

  sleep 70
done
