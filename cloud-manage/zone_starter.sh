#!/bin/sh

prodsolrsrv=1;
prodsqlsrv=1;
prodsesssrv=1;
prodproxysrv=1;
prodpressrv=4;
prodblogsrv=8;
prodcallsrv=2;
zone="us-east-1a";
servers=(prodsolrsrv prodsqlsrv prodsesssrv prodproxysrv prodpressrv prodblogsrv prodcallsrv);

echo "You probably don't want to run this, if you do remove this line and the next."
exit;

for i in ${servers[@]}; do
	count=`eval echo \\$${i}`;
	for ((a=0; a < $count; a++)); do
		echo "Starting instance ${a} of ${i} in zone ${zone}";
		./start-ec2.sh -e prod -h ${i} -z ${zone} >>logfile 2>&1
		sleep 2
	done
done
