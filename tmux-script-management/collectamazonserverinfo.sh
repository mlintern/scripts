#!/bin/sh

ec2-describe-instances | grep "Name\|INSTANCE" | perl -pe 's/\s+/:/g' | perl -pe 's/INSTA/\nINSTA/g' | perl -pe 's/sg-[^:]+://g' | awk -F: '{print $26,",",$4,",",$13}' > ~/FullServerList.csv
export EC2_PRIVATE_KEY=~/.ec2/eng-testing/pk-EL6OCE7KGWXPLWSWQXRAU6V3AQ45HPJ4.pem
export EC2_CERT=~/.ec2/eng-testing/cert-EL6OCE7KGWXPLWSWQXRAU6V3AQ45HPJ4.pem
export EC2_SSH_ID=~/.ssh/eng-testing.rsa
ec2-describe-instances | grep "Name\|INSTANCE" | perl -pe 's/\s+/:/g' | perl -pe 's/INSTA/\nINSTA/g' | perl -pe 's/sg-[^:]+://g' | awk -F: '{print $26,",",$4,",",$13}' > ~/FullTestServerList.csv
export EC2_PRIVATE_KEY=~/.ec2/compendium.x509.pk.pem
export EC2_CERT=~/.ec2/compendium.x509.pem
export EC2_SSH_ID=~/.ssh/rightscale_key
