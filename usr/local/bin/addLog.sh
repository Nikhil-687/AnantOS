#!/bin/bash
file=$(date +"%d-%b-%Y").log
echo $file
cd "/home/konsol/AnantOSLab/var/log/" || exit 1
touch $file || exit 1
