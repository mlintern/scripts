#!/usr/bin/env php

<?php
// ask for input
fwrite(STDOUT, "Enter your email for hash: ");

// get input
$inemail = trim(fgets(STDIN));

$email = trim( "mlintern@eng.compendiumblogware.com " ); // "MyEmailAddress@example.com"
$email = strtolower( $email ); // "myemailaddress@example.com"
echo "The Hash tag for mlintern@eng.compendiumblogware.com is ";
echo md5( $email );
echo "\n\n";


echo "The Hash tag for mlintern@compendium.com is ";
echo  md5( strtolower( trim( " mlintern@compendium.com " ) ) );
echo "\n\n";


echo "The Hash tag for ";
echo "$inemail";
echo  " is ";
echo  md5( strtolower( trim( " $inemail " ) ) );
echo "\n";
?>