#!/bin/sh

filename="/Users/mlintern/Documents/post_id-blog_id-unix.csv"

echo "Starting work on $filename"
current_post='0'
while read line;
do
post_id=$(echo $line | cut -d ',' -f1)
blog_id=$(echo $line | cut -d ',' -f2)
if [ "$post_id" == "$current_post" ]; then
	printf "%s" ",$blog_id"
else
	current_post=$post_id
	printf "%s\n" ""
	printf "%s" "$post_id,$blog_id"
fi
#echo "post_id is $post_id and blog_id is $blog_id"

done < "$filename"