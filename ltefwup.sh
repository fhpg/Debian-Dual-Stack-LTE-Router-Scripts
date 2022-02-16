#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/ltehayes.sh"

. $CONNINFO

nft add table ip t1; nft 'add chain ip t1 c1 { type nat hook postrouting priority srcnat ; }'; nft add rule ip t1 c1 masquerade
MAXSEG=$(expr $MTU - 40)
nft add table inet t2; nft add chain inet t2 c1 { type filter hook forward priority mangle \; }; nft add rule inet t2 c1 tcp flags syn tcp option maxseg size set $MAXSEG
nft add table inet t3; nft add chain inet t3 c1 { type filter hook prerouting priority filter \; }
# let us count each state separately for interest
for state in new invalid untracked ; do 
  nft add rule inet t3 c1 meta iif $WWAN ct state $state counter drop
done
