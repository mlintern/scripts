#!/bin/sh

cd ~

while read line
	do
		echo $line | perl -pe 's/\s+//g' | awk -F","  '{print "tmux neww -n",$1$3,"\"ssh -i ~/.ssh/eng-testing.rsa ec2-user@",$2,"\""}'| perl -pe 's/\@.e/\@e/gi'  | perl -pe 's/us-east//g' | grep 1a
		done < "FullTestServerList.csv"
while read line
	do
		echo $line | perl -pe 's/\s+//g' | awk -F","  '{print "tmux neww -n",$1$3,"\"ssh -i ~/.ssh/eng-testing.rsa ec2-user@",$2,"\""}'| perl -pe 's/\@.e/\@e/gi'  | perl -pe 's/us-east//g' | grep 1c
		done < "FullTestServerList.csv"
