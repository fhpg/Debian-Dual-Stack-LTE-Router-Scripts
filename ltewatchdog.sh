#!/bin/bash

/opt/lte/lteinit.sh

while [ "1" == "1" ] ; do
  . /etc/lte.config
  IP4CONNECTED=$(ping -4 -c 1 $PING4HOST1 | grep " 0% packet loss")
  IP6CONNECTED=$(ping -6 -c 1 $PING6HOST1 | grep " 0% packet loss")
  if [[ "$IP4CONNECTED" == "" || "$IP6CONNECTED" == "" ]] ; then
    IP4CONNECTED=$(ping -4 -c 1 $PING4HOST2 | grep " 0% packet loss")
    IP6CONNECTED=$(ping -6 -c 1 $PING6HOST2 | grep " 0% packet loss")
    if [[ "$IP4CONNECTED" == "" || "$IP6CONNECTED" == "" ]] ; then
      date
      /opt/lte/ltedisconn.sh
      sleep 20
      /opt/lte/lteconn.sh
    fi
  fi

  sleep 70
done
