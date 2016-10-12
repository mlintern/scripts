#!/bin/bash

LIST="1 2 3 4 5"

MAXPROG=$(echo ${LIST} | wc -w)

for NUMBER in ${LIST};
do
 echo -n "$((${NUMBER}*100/${MAXPROG})) %     "
 echo -n R | tr 'R' '\r'
 sleep 2
done

echo