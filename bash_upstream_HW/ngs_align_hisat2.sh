#!/usr/bin/env bash
#
# This script aligns the Griffith Data against a genomic index: $IDX
#
# It produces a BAM file for each of the read files.
#====================================================================================================
#   hisat2 [options]* -x <ht2-idx> {-1 <m1> -2 <m2> | -U <r> | --sra-acc <SRA accession number>} [-S <sam>]
#=========================================================================================================
# ht2-index: index filename prefix(minus trainling .X.ht2)
# m1: Files with #1 mates, paired with files in <m2>, could be gzip'ed, gz
# m2: Files with #2 mates, paired with files in <m1>
# r: files with unpaired reads
# -p: specifies the number of threads to use



# Exit this script on any error.
set -euo pipefail

# This keeps track of the messages printed during execution.
RUN_DATE=`date +%Y-%m-%d_hr%T`
RUNLOG=runlog_${RUN_DATE//:/_}.txt

# Create output folder
mkdir -p bam

# The index determines what the data is aligned against.
IDX=/mnt/f/bioinfo_data/refs/hg19_ht2/genome

# Iterate over each sample
  for

for SAMPLE in HBR UHR;
do
  
    # Iterate over each of the replicates.
    for REPLICATE in 1 2 3;
    do
        # Build the name of the files.
        R1=reads/${SAMPLE}_${REPLICATE}_R1.fq
        R2=reads/${SAMPLE}_${REPLICATE}_R2.fq
        BAM=bam/${SAMPLE}_${REPLICATE}.bam

        # Run the aligner.
        echo "*** Aligning: $BAM"
        hisat2 $IDX -1 $R1 -2 $R2 2>> $RUNLOG | samtools sort > $BAM 2>> $RUNLOG
        samtools index $BAM
    done
done
