#!/bin/bash
# Usage: ./script.sh <file.html> <tag_name>

DIR=$1

#TAG=$2

files=$(find $DIR/*.html -maxdepth 1 -type f -printf "%f\n")

echo $files

for i in "${files[@]}"; do
   filename=$(echo $i | cut -d '.' -f1)
   echo -e "$filename"
 done
#$(perl -0777 -ne 'while (/<app-cours.*?>.*?<\/app-cours>/sg) { print "$&\n" }' $FILE) > 

