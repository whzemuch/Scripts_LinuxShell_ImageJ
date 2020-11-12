#!/usr/bin/env bash
#
# This script makes use of the BAM files to compute
# the coverages counts.
#
# It then run three different statistical methods on the count file.
# For these methods to run you will need R to be installed as well as
# Bioconductor and the necessary packages. See the book for details.
#
#
# Look inside the file called runlog.txt if things don't seem to work.
#

#
# Stop this script on any error.
set -euxo pipefail

# The gene feature file that will be used to count against.
GTF=refs/ERCC92.gtf

# Collect the output of commands here.
RUNLOG=runlog.txt

# Generate the counts.
echo "*** Counting features with: $GTF"
featureCounts -a $GTF -g gene_name -o counts.txt  bam/HBR*.bam  bam/UHR*.bam 2>> $RUNLOG

# Simplify the file to keep only the count columns.
echo "*** Generating simple counts."
cat counts.txt | cut -f 1,7-12 > simple_counts.txt

# Run the DESeq1 method on the simple count file.
echo "*** Running DESeq1."
curl -s -O http://data.biostarhandbook.com/rnaseq/code/deseq1.r
cat simple_counts.txt | Rscript deseq1.r 3x3 > results_deseq1.txt  2> $RUNLOG

# Run the DESeq2 method on the simple count file.
echo "*** Running DESeq2."
curl -s -O http://data.biostarhandbook.com/rnaseq/code/deseq2.r
cat simple_counts.txt | Rscript deseq2.r 3x3 > results_deseq2.txt  2>> $RUNLOG

# Run the EdgeR method on the simple count file.
echo "*** Running EdgeR."
curl -s -O http://data.biostarhandbook.com/rnaseq/code/edger.r
cat simple_counts.txt | Rscript edger.r 3x3 > results_edger.txt  2>> $RUNLOG
