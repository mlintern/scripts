#!/bin/sh

input=$1
output=$2

$(tr '\r' '\n' < $input > $output)