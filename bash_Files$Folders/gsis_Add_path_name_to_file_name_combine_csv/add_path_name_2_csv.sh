#!/bin/bash
# by Hanzhou Wang 4/22/2019


# file=`find . -name *.csv ! -path '*/SUM/*'`
find .   -name *.csv | grep -v SUM |
while IFS= read -r line       # -r do not let backslash to escape any charaters, the default of IFS is \t\n
do
    # echo $(dirname $line)
    DIRNAME=$(dirname $line)
    DIRNAME_Parent=$(basename $DIRNAME)
    echo $DIRNAME_Parent
    FILENAME=$(basename $line)
    echo $FILENAME
    sed -i "s/\r$/,${DIRNAME_Parent}, ${FILENAME}/ " $line
    
done

find . -name *.csv | grep -v SUM | xargs cat > combines.csv
cat combines.csv | awk 'NR>=2 && !/Perim/ ' > 123.csv


