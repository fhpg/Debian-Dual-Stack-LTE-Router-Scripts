#!/bin/bash
. /etc/lte.config
CONNINFO=/tmp/lteconn.txt

function hayes {
  COMMAND=$1
  # socat works unstable with ATE1
  echo 'ATE0' | socat -u STDIO $TTY,crnl,sync=1
  echo -n "$COMMAND "
  echo "$COMMAND" | socat STDIO $TTY,crnl,sync=1
}
