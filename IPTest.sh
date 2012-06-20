#!/bin/sh

file=~/outsideIP.txt

if [ ! -e $file ]
  then
	touch $file
	echo "0.0.0.0" > $file
fi

ipa=$(cat $file)
ipb=$(curl icanhazip.com)

if [ $ipa != $ipb ]
  then
	echo "The Outside IP address has changed from $ipa to $ipb" | mail -s "IP Address Change" mlintern@compendium.com
	echo $ipb > $file
fi
