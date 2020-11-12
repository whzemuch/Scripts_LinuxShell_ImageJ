#!/bin/bash

# Batch Download files from NCBI SRA using Aspera ascp on  Linux WSL
# to 'current_folder'/aspera_download
# by Hanzhou Wang 12/15/18



##########################################
# edit path below here to fit your machine
# AsperageT=/mnt/e/Dropbox/00_RNAseq/asperaget.sh
# 1. Usage: cat SRR_Acc_List.txt | bash asperaget.sh
# 2. Usage:
##########################################

# exit this script on any error
set -euo pipefail

# runlog
RUN_DATE=`date +%Y-%m-%d_hr%T`
RUNLOG=runlog_${RUN_DATE//:/_}.txt

# Time for starting
printf "%s %s %s %s %s %s"::  Start dowmloading \n $(echo `date`) ans
start=$(date +%s.%N)

# Setting: build the parameter for command

KEYFILE="~/.aspera/connect/etc/asperaweb_id_dsa.openssh"
SERVER_HOST="fasp.sra.ebi.ac.uk"
SERVER_USER="era-fasp"

DOWNLOAD_LINK_LIST=
OUTPUT_DIR="."

# output dir



# display the running information
echo "Downloading files using ASPERA, Start now......"

 # run ascp

 nohup  ascp -v -k 1 -T -l400m  -i ${KEYFILE}  --host ${SERVER_HOST} --user ${SERVER_USER} --file-list ${DOWNLOAD_LINK_LIST} ${OUTPUT_DIR} | tee -a ${RUNLOG} &




 dur=$(echo "($(date +%s.%N) - $start)/60" | bc -l)
 printf "%s %s %s %s %s %s":: It took %.2f minutes to finish  QC \n $(echo `date`) $dur | tee -a ${RUNLOG}


# Reference:
# ---------------------------------------------------------------------------------------------------------------------------------
# –-Q (for adaptive flow control) – needed for disk throttling!
# –-T to disable encryption
# –-k1 enable resume of failed transfers
# –-l (maximum bandwidth of request, try 200M and go up from there)
# –-r recursive copy
# –-i <private key file>
# -- mode: send or recv
# --host: server,  fasp.sra.ebi.ac.uk
# --user era-fasp
# --file-list the file with all the download link 
#   /vol1/fastq/SRR679/001/SRR6790711/SRR6790711.fastq.gz


# command sample for a single sra file
#  ----------------------------------------------------------------------------------------------------------------------------------
# 1. download from NCBI

#  ascp -v -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh \
#      -k 1 -T -l200m anonftp@ftp-private.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/SRR/SRR949/SRR949627/SRR949627.sra \
#      /mnt/f/bioinfo_data
#   **anonftp@ftp-private.ncbi.nlm.nih.gov need change to  anonftp@ftp.ncbi.nlm.nih.gov** ,
#         other wise cause "fail to open TCP connectin for SSH"  5/15/2019 several days to figure out

#   2. Download from ENA
# 2. ascp -QT -l 300m -P33001 -k1 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh \
#      --mode recv --host fasp.sra.ebi.ac.uk --user era-fasp \
#      --file-list fastqid_trim.txt
#      -- /media/yanfang/FYWD/RNA_seq/fastq_files/single_cell_data/
#  ----------------------------------------------------------------------------------------------------------------------------------


