#!/bin/bash
#
# Copyright © Abner Ballardo Urco
# http://www.modlost.net

#
# This will check for the presence of a script that will be run.
#
if [ "$1" != "" ]; then
        script_location=$1
else
        echo "You must pass a script to run."
        exit 1
fi

#
# Cool Progress Indicator
#
function cool_progress_ind {
  chars=( "-" "\\" "|" "/" )
  interval=1
  count=0

  while true
  do
    pos=$(($count % 4))

    echo -en "\b${chars[$pos]}"

    count=$(($count + 1))
    sleep $interval
  done
}

#
# Stop progress indicator
#
function stop_progress_ind {
  exec 2>/dev/null
  kill $1
  echo -en "\n"
}

echo "Cool Progress Indicator"
echo -n "Processing "

cool_progress_ind &
pid=$!

# Thanks Stephen Concannon for sending this fix.
# If the main script is interrupted, this line takes care
# of stopping the progress indicator
trap "stop_progress_ind $pid; exit" INT TERM EXIT

$script_location

stop_progress_ind $pid