#!/bin/bash
# bard: Send out some options for lunch...
# Seed $RANDOM
RANDOM=$$;

export PATH=/bin:/usr/bin:

#LUNCH_FILE='/root/not_bar_destinations.txt';
LUNCH_FILE='not_bar_destinations_weighted.txt';
SUBJECT='Thursday Bar Suggestions';
#TO='dmcfadden@eng.compendiumblogware.com aparker@eng.compendiumblogware.com mlintern@compendium.com sgregory@compendium.com ijohnson@compendium.com jpaden@compendium.com phinton@eng.compendiumblogware.com ps@compendium.com';
TO='engineering@compendium.com ps@compendium.com jpaden@compendium.com';
SCRATCH_FILE='/tmp/bar-scratch.txt';

touch $SCRATCH_FILE;
cat <<EOF > $SCRATCH_FILE;
Here are a few bar options for today:

But first make sure that it is indeed Beer O'Clock?

http://www.isitbeeroclock.com

Please ignore http://www.isitbeeroclockyet.com !!!

Coaches is the obvious choice, but if you decide that you are interested in a change, try:

EOF

LC=$(wc -l $LUNCH_FILE | perl -pe 's/^\s+//' | cut -d ' ' -f1);
for i in {0..1};
do
        LINE=$((($RANDOM + 1) % $LC));

	if [ $LINE == 0 ]; then
        while [ $LINE == 0 ] 
        do
                LINE=$((($RANDOM + 1) % $LC));
        done
        fi

        DEST=$(head -n $LINE $LUNCH_FILE | tail -1);
        echo $DEST >> $SCRATCH_FILE;

	if [ $i == 0 ]; then
		echo " " >> $SCRATCH_FILE;
		echo "  OR  " >> $SCRATCH_FILE;
		echo " " >> $SCRATCH_FILE;
	fi
done

echo "  " >> $SCRATCH_FILE;
echo "  " >> $SCRATCH_FILE;
echo "Tell Amber I said Hi!" >> $SCRATCH_FILE;
echo "  " >> $SCRATCH_FILE;
echo "  " >> $SCRATCH_FILE;
echo "Sincerely, " >> $SCRATCH_FILE;
echo "  " >> $SCRATCH_FILE;
echo "Party G " >> $SCRATCH_FILE;
echo "  " >> $SCRATCH_FILE;
echo "  " >> $SCRATCH_FILE;
echo "  " >> $SCRATCH_FILE;
echo "Party Gorilla " >> $SCRATCH_FILE;
echo "CPO, Cheif Party Officer " >> $SCRATCH_FILE;
echo "Compendium " >> $SCRATCH_FILE;
echo "partygorilla@compendium.com " >> $SCRATCH_FILE;
echo "@PartyGorillaCPO " >> $SCRATCH_FILE;

#cat $SCRATCH_FILE | mail -r PartyGorilla -s "$SUBJECT" mlintern@compendium.com
cat $SCRATCH_FILE | mail -r PartyGorilla -s "$SUBJECT" $TO
