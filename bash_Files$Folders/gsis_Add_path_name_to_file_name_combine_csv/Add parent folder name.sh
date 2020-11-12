#!/bin/bash

file="2.txt"

while IFS= read -r line
do
    # echo $(dirname $line)
    DIRNAME=$(dirname $line)
    DIRNAME_Parent=$(basename $DIRNAME)
    echo $DIRNAME_Parent
    FILENAME=$(basename $line)
    echo $FILENAME
done < $file


