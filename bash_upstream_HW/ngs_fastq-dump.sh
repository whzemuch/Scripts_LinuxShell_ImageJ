#!/bin/bash

# Batch  fasterq-dump command
# by Hanzhou Wang 12/15/18

# –A Input, Replaces accession derived from <path> in filenames and defines
# –O output directory
# –-gzip compress output using gzip  # ONly for fast-dump
# -e threads
# –-split-3 write single reads in special file: each read have 4 lines. For spots having 2 reads, the reads go to *_1.fq and *_2.fq , unmated reads go to *_3.fq.
# --split-files  write reads into different files
# -p show progress

#   First biological reads satisfying dumping conditions are placed in files *_1.fastq and *_2.fastq 
#   If only one biological read is present it is placed in *.fastq Biological reads and above are ignored.

# command sample for a single sra file
#  ----------------------------------------------------------------------------------------------------------------------------------
   # download from NCBI
    # fastq-dump  -A sample -O outputdir --gzip --split-3  /sample/path/sra_name
    # fasterq-dump -e 8 --split-3 -o sample_name -O outputdir  /sample/path/sra_name
    # fasterq-dump -e 8 --split-files -0 sample_name -O outputdir  /sample/path/sra_name                

   #  ----------------------------------------------------------------------------------------------------------------------------------

   ##########################################
   # edit path below here to fit your machine
   # Usage: cat id.txt | bash fastq_dump.sh- use awk to add the order of the replicats in a list. 

    #| - use awk to add the order of the replicats in a list.
    #| cat id.txt | awk '{arr[$1]++;print $1arr[$1]"\t"$2}'
    #| 
    #| RNAPII_S5P_1    SRR391032
    #| RNAPII_S5P_2    SRR391033
    #| RNAPII_S7P_1    SRR391035
    #| RNAPII_S7P_2    SRR391040
    #| RNAPII_8WG16_1  SRR391036
    #| RNAPII_8WG16_2  SRR391037
    #| RNAPII_S2P_1    SRR391034
    #| RNAPII_S2P_2    SRR391038
    #| RNAPII_S2P_3    SRR391039
    #| H2Aub1_1        SRR391041
    #| H2Aub1_2        SRR391042
    #| H3K36me3_1      SRR391043
    #| H3K36me3_2      SRR391044
    #| Control_1       SRR391045
    #| Control_2       SRR391046
    #| Ring1B_1        SRR391047
    #| Ring1B_2        SRR391048
    #| Ring1B_3        SRR391049
    #| 
    #|    
    #|    
   ##########################################

   # exit this script on any error
   set -euo pipefail

   # runlog
   RUN_DATE=`date +%Y-%m-%d_hr%T`
   RUNLOG=runlog_fasterq-dump_${RUN_DATE//:/_}.txt

   # set out folders
   OUTPUT_DIR=/mnt/f/NGS_Projects/salivary/samples/fq
   SOURCE_DIR=/mnt/f/NGS_Projects/salivary/samples
   # iterate over the samples, use read -a to read several items into an array called arr

   while read -a arr;
   do

      # build the parameter for command
      SAMPLE=${arr[0]}
      SRA_ID=${arr[1]}

      # display the running information
       echo "***  From ${SOURCE_DIR} to ${OUTPUT_DIR}"

      # echo "fasterq-dump -e 3 --split-files -o ${SAMPLE}.fq -O ${OUTPUT_DIR}   ${SOURCE_DIR}/${SRA_ID}.sra"

      # run fasterq-dump
       nohup fasterq-dump -e 3  --split-files  -o ${SAMPLE}.fq -O ${OUTPUT_DIR}  ${SOURCE_DIR}/${SRA_ID}.sra  2>> ${RUNLOG} &

   done


