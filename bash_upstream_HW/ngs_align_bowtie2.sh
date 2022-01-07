#!/bin/bash
#
# This script aligns ChIPseq Data against a genomic index: $IDX
#
# It produces a BAM file for each of the read files.
#====================================================================================================

#   bowtie2 [options]* -x <bt2-idx> {-1 <m1> -2 <m2> | -U <r> | --interleaved <i>} [-S <sam>]
#   bowtie2 -p 8 -x <bt2-idx> -U $id -S ${id%%.*}.sam 
    
#   -   <m1>       Files with #1 mates, paired with files in <m2>.   Could be gzip'ed (extension: .gz) or bzip2'ed (extension: .bz2). 
#   -   <m2>       Files with #2 mates, paired with files in <m1>.   Could be gzip'ed (extension: .gz) or bzip2'ed (extension: .bz2).
#   -   <r>        Files with unpaired reads.                        Could be gzip'ed (extension: .gz) or bzip2'ed (extension: .bz2).
#   -   <i>        Files with interleaved paired-end FASTQ reads

#   -   -p/--threads <int>       number of alignment threads to launch
#   -   <bt2-idx>  Index filename prefix (minus trailing .X.bt2)

#   - ls *.sam | parallel  "samtools view -bS {} | samtools sort - >{.}.bam; samtools index {.}.bam"  # -b output as bam file -S input format is auto-detected. "-" after samtools sort means output to standoutput(screen).

#   - bowtie2 -p 8 -x ~/biosoft/bowtie/hg19_index/hg19 -U $id -S ${id%%.*}.sam 2>${id%%.*}.align.log;

## samtools view -bhS -q 30 ${id%%.*}.sam > ${id%%.*}.bam ## -F 1548 https://broadinstitute.github.io/picard/explain-flags.html

## -F 0x4 remove the reads that didn't match

#   - samtools sort ${id%%.*}.bam ${id%%.*}.sort ## prefix for the output

## samtools view -bhS a.sam | samtools sort -o - ./ > a.bam

#   - samtools index ${id%%.*}.sorted.bam
#=========================================================================================================


# Exit this script on any error.
set -euo pipefail

# This keeps track of the messages printed during execution.
RUN_DATE=`date +%Y-%m-%d_hr%T`
RUNLOG=runlog_${RUN_DATE//:/_}.txt

# Create output folder
mkdir -p bam

# The index determines what the data is aligned against.
IDX=/mnt/f/bioinfo_data/refs/Homo_sapiens_UCSC_hg19/UCSC/hg19/Sequence/Bowtie2Index/genome

# Iterate over each sample
 

find . -name \*.fastq.gz | while read ID; 
do  
  SAMPLENAME=${ID%%.fastq.gz}
  bowtie2 -p 4 -x $IDX -U ${ID} | samtools view -bs - | samtools sort - >${SAMPLENAME}.bam; samtools index ${SAMPLENAME}.bam 
done &



