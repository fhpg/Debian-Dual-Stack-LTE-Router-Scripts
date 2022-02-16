#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/ltehayes.sh"

. "$DIR/lteattend.sh"

. "$DIR/ltesignal.sh"

. "$DIR/lte6conn.sh"

. "$DIR/lte4conn.sh"

. "$DIR/ltefwup.sh"
