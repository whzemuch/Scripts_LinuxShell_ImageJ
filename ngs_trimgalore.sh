#!/bin/bash

# Batch  trimgalore command
# by Hanzhou Wang 12/15/18

# –-o output dir
# –-q
#  -e error rate
#  -stringency bases overlap with adapters
#  --phred33 | --phred64
#  ----------------------------------------------------------------------------------------------------------------------------------
   # trimming
    # trim_galore -q 25 --phred33 --length 25 -e 0.1 --stringency 4  -o /output/dir /fa/file


   #  ----------------------------------------------------------------------------------------------------------------------------------

   ##########################################
   # edit path below here to fit your machine
   # cat id.txt | bash trigalore.sh
   ##########################################

   # exit this script on any error
   set -euo pipefail

   # runlog
    RUNLOG=runlog.txt

   # set out folders
   OUTPUT_DIR=/mnt/f/bioinfo_data/trim
   # TEMP_DIR=/mnt/f/bioinfo_data/tmp

   # iterate over the samples

   while read FILE
   do
      # display the running information
       echo *** Trimmng on  ${FILE}
       echo "ftrim_galore ${FILE} -o ${OUTPUT_DIR} -q 25 --phred33 --length 25 -e 0.1 --stringency 4"

       # run trim_galore
      nohup trim_galore ${FILE} -o ${OUTPUT_DIR} -q 25 --phred33 --length 25 -e 0.1 --stringency 4  2>>$RUNLOG &

   done


