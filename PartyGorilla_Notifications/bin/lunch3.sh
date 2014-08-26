#!/bin/bash

# lunchd: Send out some options for lunch...

# Seed $RANDOM
RANDOM=$$;

export PATH=/bin:/usr/bin:

LUNCH_FILE='/root/not_lunch_destinations.txt';
SUBJECT='Daily Lunch Suggestions 3';
TO='dmcfadden@eng.compendiumblogware.com aparker@eng.compendiumblogware.com mlintern@compendium.com phinton@eng.compendiumblogware.com sgregory@compendium.com ijohnson@compendium.com';
SCRATCH_FILE='/tmp/lunch-scratch.txt';

touch $SCRATCH_FILE;
cat <<EOF > $SCRATCH_FILE;
Here are a few lunch options for today:

EOF

LC=$(wc -l $LUNCH_FILE | perl -pe 's/^\s+//' | cut -d ' ' -f1);
for i in {0..2};
do
        LINE=$((($RANDOM + 1) % $LC));
        DEST=$(head -n $LINE $LUNCH_FILE | tail -1);
        echo $DEST >> $SCRATCH_FILE;
done

#cat $SCRATCH_FILE | mail -s "$SUBJECT" mlintern@compendium.com
cat $SCRATCH_FILE | mail -r PartyGorilla -s "$SUBJECT" mlintern@compendium.com
#cat $SCRATCH_FILE | mail -r PartyGorilla -s "$SUBJECT" $TO
