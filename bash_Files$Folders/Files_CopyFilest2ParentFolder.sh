#!/bin/bash

# Hanzhou Wang 20200407
# Purpose: Copy/move files to the parent folder

#*************************************************************************************************************
# Usage: 1. Go to one level up of your target folder
#        2. Run bash RenameWithParentFolderName.sh

#*************************************************************************************************************

# Exit this script on any error.

set -euo pipefail
# set -x
#************************************************************

# Settings
input_file_type="*.jpg"
search_depth=2  # 1 is the current folder


find . -maxdepth ${search_depth} -type f  -name "Montage*.jpg" | 
    while read file; do
	
	  dir_name=$(dirname $file)
	  cp  "${file}" "${dir_name%/*}"
	  
	done
