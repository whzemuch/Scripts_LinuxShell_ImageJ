#!/bin/bash

# by Hanzhou Wang 03/23/2021

# Purpose: renames multiple files in a folder, the new names are listed in a txt files.

# Usage:======================================
# bash rename_files_based_on_a_file.sh < file_with_names
#
# parameters
#   1.file_with_names must have two columns: the first column is the old names,
#                                        the second column is the new names.
#   2.file_with_names can be generated using the command below:
#       cat NHASLab.txt | awk 'BEGIN{FS="\t"};{gsub(/ Doc/, ""); print $3, $1"_"$3}' > file_with_names
#
# ============================================

input_file=$1

# exit if any errow occurs
set -eou pipefail
awk 'BEGIN{FS="\t"};{gsub(/ Doc/, ""); print $3, $1"_"$3}' ${input_file} > file_with_names


printf "\n================\n"

while read -r old_name new_name; do
    if [ -f "${old_name}.XPT" ]; then
        #rename "s/$old_name/$new_name/" ${old_name}.XPT
        mv ${old_name}.XPT  ${new_name}.XPT
        printf "\nrenaming ${old_name}.XPT, done!\n "
    else
        printf "\n${old_name}.XPT does not exit!\n"
    fi

done < file_with_names

printf "\n================\n"
