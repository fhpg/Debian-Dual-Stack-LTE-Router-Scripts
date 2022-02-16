#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/ltehayes.sh"

#systemctl stop ModemManager


sysctl -w net.ipv4.conf.all.forwarding=1
sysctl -w net.ipv6.conf.all.forwarding=1

qmicli -p -d $WDM --wds-reset

for i in {17..22} ; do
  qmicli -p -d $WDM --wds-noop --client-cid=$i
done

if [ ! -e $TTY ] ; then
  echo "$TTY does not exist";
  exit 1;
fi

hayes 'AT'
hayes 'AT+CRESET'
while [ -e $TTY ] ; do
  echo -n "."
  sleep 2
done
while [ ! -e "/sys/class/net/$WWAN/qmi/raw_ip" ] ; do
  echo -n "*"
  sleep 2
done

while [ "$(cat /sys/class/net/$WWAN/qmi/raw_ip)" != "Y" ] ; do
  echo -n "°"
  ip link set $WWAN down
  echo Y > /sys/class/net/$WWAN/qmi/raw_ip
  ip link set $WWAN up
  sleep 1
done

while [ "$(qmicli -p -d $WDM --dms-get-operating-mode | grep online | wc -l)" != "1" ] ; do
  echo -n "o"
  sleep 1
done

echo "modem resetted"

hayes 'AT'

echo -n "waiting for empty profile list "
while [ "$(qmicli -p -d $WDM --wds-get-profile-list=3gpp | grep "Profile list empty" )" != "Profile list empty" ] ; do
  echo -n "."
  for cmd in 'AT+CGATT=0' 'at+cgdcont=1' 'at+cgdcont=2' 'at+cgdcont=3' ; do
    hayes "$cmd"
  done
done
echo " done"

qmicli -p -d $WDM --wds-create-profile='3gpp,name=telekom,apn=internet.telekom,pdp-type=IPV4V6'
qmicli -p -d $WDM --wds-create-profile='3gpp,name=telekom,apn=internet.v6.telekom,pdp-type=IPV4V6'

hayes 'AT+CPIN?'
# in case you have to unlock via pin
# hayes 'AT+CPIN=<place your pin here>'
# optional: remove sim lock
# hayes 'AT+CLCK="SC",0,"<place your pin here>"'
# SIM7600 AT command manual can be downloaded at simcom website

qmicli -p -d $WDM --wds-get-profile-list=3gpp
