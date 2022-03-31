#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/ltehayes.sh"

. "$DIR/lteattend.sh"

. "$DIR/ltesignal.sh"

. "$DIR/lte6conn.sh"
sleep 5
. "$DIR/lte4conn.sh"

. "$DIR/ltefwup.sh"
