#!/bin/bash

# FastQC seqfiles
# by Hanzhou Wang 12/15/18

# –- o /output/folder
# –- t --threads:  the number of files that can be processed simultaneously
#  - f --format: fastq, bam, sam, bam_mapped, sam_mapped

# cosingle sra file
#  ----------------------------------------------------------------------------------------------------------------------------------
   # FastQCing reads
     # fastqc seqfile -o /output/dir -t 4

   #  ----------------------------------------------------------------------------------------------------------------------------------

   ##########################################
   # edit path below here to fit your machine
   # Usage: cat id.txt | bash fastqc.sh
   # Usage: ls *.fastqc | bash fastqc.sh
   # Usage: ls *.fastqc.gz | bash fastqc.sh
   ##########################################

   # exit this script on any error
   set -euo pipefail

   # runlog
   RUN_DATE=`date +%Y-%m-%d_hr%T`
   RUNLOG=runlog_fastqc_${RUN_DATE//:/_}.txt

   # set out folders
   OUTPUT_DIR="${PWD}"
   # iterate over the samples, use read -a to read several items into an array called arr

   while read FILE;
   do

      # display the running information
       echo "***FastQC ${FILE}}"  >> ${RUNLOG}
       echo "fastqc ${FILE} -o ${OUTPUT_DIR} -t 4" >> ${RUNLOG}

      # run fastc
       nohup fastqc ${FILE} -o ${OUTPUT_DIR} -t 4  2>> ${RUNLOG} &

   done

