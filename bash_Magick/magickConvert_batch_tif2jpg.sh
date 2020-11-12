#!/bin/bash

#Purpose: use magick convert command to convert multiple tif files in a folder to jpg files and keep the original directory structure.

# Usage==============================
#  1. Run `magick convert` to confirm that Magick has been install on windows
#  2. Right click the target folder, select "git Bash"
#  3. Run bash batch_convert_tif_jpg.sh 
#=========================================

# Exit this script on any error

set -euo pipefail
# set -x  # debug mode

#===== The following codes do not work when there are some white space in the path of the filenames
# Use find command to get the file list for converting.
# find . -name \*.tif  | while read file;
# do 
# 	FILENAMES_JPG=${file%%.tif}
# 	magick convert -quiet  $file  ${FILENAMES_JPG}.jpg
# 	echo " Convert [$file]  to  [${FILENAMES_JPG}.jpg] done!"
# 
# done

# use -print 0  and while together to deal with white space, add double quotes to deal with white space in filenames.
# ref1: https://unix.stackexchange.com/questions/131766/why-does-my-shell-script-choke-on-whitespace-or-other-special-characters
# ref2: https://stackoverflow.com/questions/9612090/how-to-loop-through-file-names-returned-by-find/37210472#37210472

find . -name "*.tif" -print0 | 
  while IFS= read -r -d '' file; do
	FILENAMES_JPG=${file%%.tif}
        magick convert -quiet  "$file"  "${FILENAMES_JPG}".jpg
        echo " Convert [$file]  to  [${FILENAMES_JPG}.jpg] done!"
  done 
