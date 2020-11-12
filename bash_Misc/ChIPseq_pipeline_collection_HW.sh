#!/bin/bash

set -oeu pipefail

set -euo pipefail

# ********************Aspera downloading SRR dataset************************************************************
# runlog
RUN_DATE=`date +%Y-%m-%d_hr%T`
RUNLOG=runlog_${RUN_DATE//:/_}.txt

# set out folders
OUTPUT_DIR=/mnt/f/bioinfo_data/


# iterate over the samples

while read FILE;
do

  # build the parameter for command

  KEYFILE=~/.aspera/connect/etc/asperaweb_id_dsa.openssh
  NCBI_FTP_SAMPLE=anonftp@ftp-private.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/${FILE:0:3}/${FILE:0:6}/${FILE}/${FILE}.sra

  # display the running information
  echo "***Downloading $FILE to $OUTPUT_DIR"
  echo "ascp -v -i ${KEYFILE} -k l -T -l200m ${NCBI_FTP_SAMPLE} ${OUTPUT_DIR}"

  # run ascp
  nohup  ascp -v -i ${KEYFILE} -k 1 -T -l200m ${NCBI_FTP_SAMPLE} ${OUTPUT_DIR} 2>> ${RUNLOG} &

done

#  ****************************************************************************************************






# ********************bowtie2 alignment************************************************************
# set index for bowtie2
BOWTIE2_INDEX= /mnt/f/bioinfo_data/refs/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome

# iterate
 time ls ../trim/*fq | while read ID;
 do
       SAMPLENAME=$(basename ${ID%trim*})
         bowtie2 -p 4  -x ${BOWTIE2INDEX}/genome -U ${ID} | samtools sort -O bam  -@ 4 -o - > ${SAMPLENAME}.bam
     done &
# ****************************************************************************************************
