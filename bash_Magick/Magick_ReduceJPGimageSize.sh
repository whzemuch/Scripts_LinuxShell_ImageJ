#!/bin/bash

# by Hanzhou Wang
# Ref: https://stackoverflow.com/questions/7261855/recommendation-for-compressing-jpg-files-with-imagemagick
# Usage:==============================================================  
#         1. Copy this file to the folder that will be used for converting 
#         2. git bash to the same folder
#         3. Run 'bash ReduceJPGimageSize_Magick.sh'
# ====================================================================


# exit if any error occurs

set -euo pipefail
# set -x

# Setting(define the file type you want to convert)
pattern=JPG 

# Loop the files and renaming with magick convert command

for f in $(find . -type f -name "*.${pattern}"); do
    echo $f
    magick convert -sampling-factor 4:2:0 -strip -quality 80 -interlace Plane \
	    $f new_${f}    # use the same name
done

# change the name for line 24:  $f  "$(dirname "$f")/$(basename ${f%.*})_small.${pattern}"


