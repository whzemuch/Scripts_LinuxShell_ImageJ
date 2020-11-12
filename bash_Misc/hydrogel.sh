#!/bin/bash

while read FILE
do
    for I in {3..8}
    do
        echo  "Process $I row"
        sed -n '28,441p' | awk '((NR-2)%9 == 0){printf ("\t"}; ((NR-$I)%9 == 0){print $2"\t"$3}' > softmax_$I.txt
    done
done
