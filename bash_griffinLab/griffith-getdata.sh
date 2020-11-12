# This script will download the data for the Griffith Experiment.
#
# It requires hisat2 to be installed.
#
# The archive contains sequenced reads of mRNA from biological samples
# mixed with a spike-in control (ERCC92) of known abundances.
#
# The archive also contains the genome for chromosome 22 and the known sequence
# of the spike-in controls. We use these to align the reads against.

# Make the script stop on any error.
set -uxeo pipefail

# These are the sequences for the spike-in control.
REF_ERCC=refs/ERCC92.fa

# Limit the reference genome to chromosome 22 of the human genome.
REF_HUMAN=refs/22.fa

# We'll call the indices the same way since the
# index builder will add extra file extensions.
IDX_HUMAN=refs/22.fa
IDX_ERCC=refs/ERCC92.fa

# The following files will contain the annotations for
# the spike-in and chromosome 22.

# Spike-in annotations.
GTF_ERCC=refs/ERCC92.gtf

# Chromosome 22 of human genome.
GTF_HUMAN=refs/22.gtf

# Download and unpack the data.
# It is already organized into the reads/refs folders that will be create upon unpacking.
URL=http://data.biostarhandbook.com/rnaseq/projects/griffith/griffith-data.tar.gz
# Downloading: $URL
curl -s $URL | tar zxv

# Build the indices for both the spike-in genome and chromosome 22.
# Building hisat indices: $IDX_ERCC and $IDX_HUMAN
hisat2-build $REF_ERCC $IDX_ERCC 1>runlog.txt 2> runlog.txt
hisat2-build $REF_HUMAN $IDX_HUMAN 1>>runlog.txt 2>> runlog.txt
