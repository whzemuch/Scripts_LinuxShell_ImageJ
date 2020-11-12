#!/bin/bash

# Purpose: reorganize files for Read10X() of Seurat package(10xGenomics)
#  For each three files:
#     GSM4213197_NOD_8w_2734_barcodes.tsv.gz
#     GSM4213197_NOD_8w_2734_genes.tsv.gz
#     GSM4213197_NOD_8w_2734_matrix.mtx.gz

# Create a folder "GSM4213197_NOD_8w_2734", move the above three files to the new folder and 
# rename themto barcodes.tsv.gz, genes.tsv.gz, matrix.mtx.ga

# Usage==============================
# 
#  Change to target direcotry > bash sort2foler.sh
#
#====================================


set -euo pipefail
# set -x

ls *.gz | while read file;
 do
     prefix="${file##*_}"  # name for the new filename
     sufix="${file%_*}"    # name for the new folder
     # echo "+++++++++++++++++++++"
     # echo "prefix:" $prefix
     # echo $sufix
     # echo "+++++++++++++++++++++"
     if [ ! -d "${sufix}" ] ;then  # Create the new folder if it does not exist
         mkdir -p "$sufix"
     fi
     echo "Create foler $sufix"
     mv "${file}"  ./"${sufix}"/"${prefix}"  # move and rename files
 done

