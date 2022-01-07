#!/bin/bash


# Batch Download files from NCBI SRA using Aspera ascp on  Linux WSL
# to 'current_folder'/aspera_download
# by Hanzhou Wang 12/15/18

# –-Q (for adaptive flow control) – needed for disk throttling!
# –-T to disable encryption
# –-k1 enable resume of failed transfers
# –-l (maximum bandwidth of request, try 200M and go up from there)
# –-r recursive copy
# –-i <private key file>

# command sample for a single sra file
#  ----------------------------------------------------------------------------------------------------------------------------------
   # download from NCBI
# ascp -v -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh \
#      -k 1 -T -l200m anonftp@ftp-private.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/SRR/SRR949/SRR949627/SRR949627.sra \
#      /mnt/f/bioinfo_data
#   **anonftp@ftp-private.ncbi.nlm.nih.gov need change to  anonftp@ftp.ncbi.nlm.nih.gov** ,
#         other wise cause "fail to open TCP connectin for SSH"  5/15/2019 several days to figure out
#  ----------------------------------------------------------------------------------------------------------------------------------

##########################################
# edit path below here to fit your machine
# AsperageT=/mnt/e/Dropbox/00_RNAseq/asperaget.sh
# Usage: cat SRR_Acc_List.txt | bash asperaget.sh
##########################################

# exit this script on any error
set -euo pipefail

# runlog
RUN_DATE=`date +%Y-%m-%d_hr%T`
RUNLOG=runlog_${RUN_DATE//:/_}.txt



#########################################################
# source: https://www.cyberciti.biz/faq/shell-script-get-current-directory/

# DocumentRoot permissions
_dp="0544"
_fp="0444"
_sp="0744"
 
# Apache user/group
_user="www-data"
_group="www-data"

# set out folders, if $1 is not passed, set to the current working directory using $PWD

OUTPUT_DIR="${1:-${PWD}}"

# Die if $OUPPUT_DIR  does not exitss
[ ! -d "$OUTPUT_DIR" ] && { echo "Error: Directory $OUTPUT_DIR not found."; exit 2: }

# Get confirmation
read -p " The current working directory is ${PWD}. Are you sure (y/n)?"

# Lowercase #ans and compare it

if [ "${ans,,}" == "y" ]
then 
	chown -R  ${_user}:${_group} "$OUTPUT_DIR"
        chmod -R $_fp "$OUTPUT_DIR"

fi

#########################################################



printf "%s %s %s %s %s %s"::  Start dowmloading \n $(echo `date`) ans
start=$(date +%s.%N)

# iterate over the samples

while read FILE;
do

   # build the parameter for command

   KEYFILE=~/.aspera/connect/etc/asperaweb_id_dsa.openssh
   NCBI_FTP_SAMPLE=anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/${FILE:0:3}/${FILE:0:6}/${FILE}/${FILE}.sra

   # display the running information
   echo "ascp -v -i ${KEYFILE} -k l -T -l400m ${NCBI_FTP_SAMPLE} ${OUTPUT_DIR}"

   # run ascp
   nohup  ascp -v -i ${KEYFILE} -k 1 -T -l400m ${NCBI_FTP_SAMPLE} ${OUTPUT_DIR} 2>> ${RUNLOG} &

done

 dur=$(echo "($(date +%s.%N) - $start)/60" | bc -l)
 printf "%s %s %s %s %s %s":: It took %.2f minutes to finish  QC \n $(echo `date`) $dur | tee -a ${RUNLOG}
