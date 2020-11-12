#!/bin/bash

# Hanzhou Wang 20191029
# Purpose: Use magick(win version) to make montage

#*************************************************************************************************************
# Usage: 1. Set the parameters as below
#        2. Right click folder containing images and select "git bash", then run  "bash ${HOME}/Documents/Wang/magickMontage_images.sh" or "bash magickMontages.sh"
#  3. find . -name *.jpg | xargs -i -n1 mv {} .

#*************************************************************************************************************

# Exit this script on any error.

set -euo pipefail
set -x
#************************************************************

# Settings
img_name="Test111"  # File name can not  contain "." in it

# Img input options:
# 
#   1. *.tif;   
#   2. a command like :$(ls -1 {$input_dir}/*.png | sort -g);  
#   3. @list.txt (put file names in a txt file called list.txt 
#       example: 
#       Image_8074_10x_bf.tif Image_8074-8075_10x_PKH.tif blank.tiff                      # 2 files and one place holder
#       Image_8076_10x_bf.tif Image_8076-8077_10x_bf.tif Image_8076-8078_20x_PKH.tif      # 3 files
#

img_input="*.tif"   

img_output_size="400x300"
img_col=3

# img_title="Montage"$(date +"%Y%m%d")_${img_name}
full_path_current=$(pwd)
parent_dir=${full_path_current##*/}

img_title="Montage-"${parent_dir}"_"${img_name}

echo $img_title

# This keeps track of the messages printed during execution.
#RUNLOG=${HOME}/Documents/Wang/magicK_runlog.txt
RUNLOG=magicK_runlog.txt
# MagickMontage=${HOME}/Documents/Wang/magickMontage_images.sh

printf "\n############################################\n\n" >>${RUNLOG}
echo "Run by `whoami` on `date`" >> ${RUNLOG}
printf "\n" >> ${RUNLOG}
#************************************************************

# magick montage --help
echo  "magick montage  -label %d%f -title "${img_title}" -tile ${img_col:=2}x -geometry ${img_output_size}+4+4 ${img_input} ${img_title// /_}.jpg" | tee -a ${RUNLOG}
	       	

magick montage  -label %d%f \
                -title "${img_title}" \
		-tile "${img_col:=2}x"  \
		-geometry "${img_output_size}"+4+4 \
		${img_input} 	${img_title// /_}.jpg 2>> ${RUNLOG} 

printf "\n############################################\n\n" >> ${RUNLOG}
