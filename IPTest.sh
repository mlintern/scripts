#!/bin/sh

FILE=~/outsideIP.txt

if [ ! -e $FILE ]
	then
	touch $FILE
	echo "0.0.0.0" > $FILE
fi

IPA=$(cat $FILE)
IPB=$(curl icanhazip.com)
EMAIL='mark.lintern@oracle.com'
FROM='sender@oracle.com'
FROMNAME="Sender <sender@oracle.com>"

if [ $IPA != $IPB ]
	then
	echo "The Outside IP address has changed from $IPA to $IPB" | mail -s "IP Address Change" $EMAIL
	echo $IPB > $FILE
fi