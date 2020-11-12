#!/usr/bin/env bash
#
# This script aligns the Griffith Data against a genomic index: $IDX
#
# It produces a BAM file for each of the read files.
#
# We have two samples: HBR and UHR with three replicates per sample.
# For a total of 6 samples.
#
# Look inside the file called runlog.txt if things don't seem to work.
#

# Exit this script on any error.
set -euo pipefail

# This keeps track of the messages printed during execution.
RUNLOG=runlog.txt
echo "Run by `whoami` on `date`" > $RUNLOG

# Create output folder
mkdir -p bam

# The index determines what the data is aligned against.
IDX=refs/ERCC92.fa

# Iterate over each sample
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
