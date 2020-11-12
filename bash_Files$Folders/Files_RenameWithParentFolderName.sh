#!/bin/bash

# Hanzhou Wang 20200407
# Purpose: Use Add the parent folder name to the current file name

#*************************************************************************************************************
# Usage: 1. Go to one level up of your target folder
#        2. Run bash RenameWithParentFolderName.sh

#*************************************************************************************************************

# Exit this script on any error.

set -euo pipefail
# set -x
#************************************************************

# Settings
input_file_type="*.tif"



$ find . -type f -name ${input_file_type} |
    while read file; do
      dir_name=$(dirname $file)
      parent_dir_name=${dir_name##*/}
      mv "${file}" "--->" "${dir_name}"/"${parent_dir_name}"_"$(basename $file)" 
      echo mv "${file}" "--->" "${dir_name}"/"${parent_dir_name}"_"$(basename $file)" 
    done
