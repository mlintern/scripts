#!/bin/sh

testsqlsrv=1;
testsolrsrv=1;
testsesssrv=1;
testproxysrv=2;
testpressrv=2;
testblogsrv=2;
testcallsrv=1;
servers=(testsesssrv testsqlsrv testsolrsrv testproxysrv testpressrv testblogsrv testcallsrv);

for i in ${servers[@]}; do
	count=`eval echo \\$${i}`;
	for ((a=0; a < $count; a++)); do
		if [[ $i == "testsesssrv" ]]; then
			echo "You are about to start a test session server. Be sure to grab its IP address to modify puppet with."
			sleep 10;
		fi
		./start-ec2.sh -a ami-38c33651 -t t1.micro -e test -h ${i} -z us-east-1c >>logfile 2>&1
	done
done


