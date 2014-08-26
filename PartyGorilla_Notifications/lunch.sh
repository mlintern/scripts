#!/bin/bash

# lunchd: Send out some options for lunch...

# Seed $RANDOM
RANDOM=$$;

export PATH=/bin:/usr/bin:

LUNCH_FILE='/root/not_lunch_destinations.txt';
SUBJECT='Daily Lunch Suggestions';
TO='dmcfadden@eng.compendiumblogware.com aparker@eng.compendiumblogware.com mlintern@compendium.com phinton@eng.compendiumblogware.com sgregory@compendium.com ijohnson@compendium.com';
SCRATCH_FILE='/tmp/lunch-scratch.txt';

touch $SCRATCH_FILE;
cat <<EOF > $SCRATCH_FILE;
Here are a few lunch options for today:

EOF

LC=$(wc -l $LUNCH_FILE | /usr/bin/perl -pe 's/^\s+//' | cut -d ' ' -f1);
for i in {0..2};
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
done

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

#cat $SCRATCH_FILE | mail -s "$SUBJECT" mlintern@compendium.com
#cat $SCRATCH_FILE | mail -r PartyGorilla -s "$SUBJECT" mlintern@compendium.com
cat $SCRATCH_FILE | mail -r PartyGorilla -s "$SUBJECT" $TO
