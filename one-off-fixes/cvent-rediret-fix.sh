date=$(date -u | sed s/' '/-/g)
start=$(date +%s)
echo " "
echo "Process started at $(date)"

num=0
myfile='./cvent-author-redirect-ids.csv'

echo " "
echo "Removing Redirects"

while read redirect_id
do

((num++))

echo "Removing redirect number $num with id = $redirect_id"
#Test Code
#curl --insecure -H "Accept: application/vnd.compendium.blog;version=2,application/json" --user mlintern@compendium.com:nxXQ6VHDL2dCwrFNVa7arRkeOY678bnKzkBTgq7S -XDELETE https://api.test.compendiumblog.com/app/redirects/$redirect_id
#Prod Code
curl --insecure -H "Accept: application/vnd.compendium.blog;version=2,application/json" --user mlintern@compendium.com:nxXQ6VHDL2dCwrFNVa7arRkeOY678bnKzkBTgq7S -XDELETE https://api.compendiumblog.com/app/redirects/$redirect_id

done < "$myfile"

echo " "
echo "Removed $num Redirects."
echo " "

stop=$(date +%s)
total=$((stop-start))
min=$((total/60))
sec=$((total%60))
echo "Process ended at $(date) "
echo " "
echo "The total time spent was: $min min and $sec sec"
echo " "