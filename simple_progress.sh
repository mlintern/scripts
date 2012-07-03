#!/bin/bash
#
# Copyright © Abner Ballardo Urco
# http://www.modlost.net
#

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
# Simple Progress Indicator
#
function simple_progress_ind {
  # Sleep at least 1 second otherwise this algoritm will consume
  # a lot system resources.
  interval=1

  while true
  do
    echo -ne "."
    sleep $interval
  done
}

#
# Stop distraction
#
function stop_progress_ind {
  exec 2>/dev/null
  kill $1
  echo -en "\n"
}

echo "Simple Progress Indicator"
echo -n "Processing "

simple_progress_ind &
pid=$!

# Thanks Stephen Concannon for sending this fix.
# If the main script is interrupted, this line takes care
# of stopping the progress indicator
trap "stop_progress_ind $pid; exit" INT TERM EXIT

$script_location

stop_progress_ind $pid
