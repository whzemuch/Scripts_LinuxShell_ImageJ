#!/usr/bin/env bash
# sra-paired.sh
# Kamil Slowikowski
# April 23, 2014
# https://www.biostars.org/p/139422/
# Check if an SRA file contains paired-end sequencing data.
#
# See documentation for the SRA Toolkit:
# http://www.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc&f=fastq-dump
# not working 2/18/2019


sra_paired() {
  local SRA="$1"
  local x=$(
    fastq-dump -I -X 1 -Z --split-spot "$SRA" 2>/dev/null \
      | awk '{if(NR % 2 == 1) print substr($1,length($1),1)}' \
      | uniq \
      | wc -l
  )
  [[ $x == 2 ]]
}

if [[ "$1" == "" ]]; then
  echo "usage: sra-paired.sh file.sra"
  exit 1
fi

if sra_paired "$1"; then
  echo "$1 contains paired-end sequencing data"
else
  echo "$1 does not contain paired-end sequencing data"
fi
