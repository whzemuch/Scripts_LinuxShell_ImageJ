#!bin/bash

# Cancer_Type=$1 # a.txt
# Data_type=$2  # b.txt

##################################################

# This is a demo used for downloading TCGA data from xena data portal
# The ideal came from here:https://cloud.tencent.com/developer/article/1168369
# The motivation is to use a loop to get all the data from one cancer type instead of typing 8 lines wget -c .....

# Fils used for this script:
# a.txt: CHOL ACC BRCA
# b.txt:htseq_counts mutated_snv mirna

# Usage: bash tcga_demo.sh a.txt b.txt

####################################################

# Get data from 2 shell parameters
cancer=$(<a.txt)  # or caner=`cat a.txt`
data=$(<b.txt)


echo $cancer | xargs -n1
echo $data
# cat $1 | xargs -n1 -i bash -c 'echo {}; mkdir -p {}; cd {}'

# Fist loop is to create folder, second loop to download different data
# for real script, touch command can be replaed by wget -c ....

 echo ${cancer} | xargs -n1 |while read line;
  do
     echo $line
     mkdir -p $line
     cd $line

     # not working if xargs -n1 -i touch xena_download_$(line)e_${id}.tsv.gz because pass all the parameters one time instead one by one
     echo  ${data} | xargs -n1 | while read  id;
       do
          touch xena_downlad_${line}e_${id}.tsv.gz
       done

     cd ../  # if missed, it will make tree like folder structure
 done
