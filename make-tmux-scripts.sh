#!/bin/bash

function progress_ind {
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
function stop_progress {
  exec 2>/dev/null
  kill $1
  echo -en "\n"
}

echo -n "Processing "

progress_ind &
pid=$!

# Thanks Stephen Concannon for sending this fix.
# If the main script is interrupted, this line takes care
# of stopping the progress indicator
trap "stop_progress $pid; exit" INT TERM EXIT

cd ./tmux-script-management 
./makeserverscripts.sh

echo -ne ".done"

stop_progress $pid
