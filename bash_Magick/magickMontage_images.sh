#!/bin/bash

# Hanzhou Wang 20191029
# Purpose: Use magick(win version) to make montage

#*************************************************************************************************************
# Usage: 1. Set the parameters as below
#        2. Right click folder containing images and select "git bash", then run  "bash ${HOME}/Documents/Wang/magickMontage_images.sh" or "bash magickMontages.sh"

#*************************************************************************************************************


# Exit this script on any error.

set -euo pipefail
# set -x

# Log File=================================================================

RUNLOG=magicK_runlog.txt


# Settings==================================================================

img_name="test"                  # img_name with "." will cause error.

img_input=@list.txt
printf "\n############################################\n\n" | tee -a ${RUNLOG}
echo "Input Image Files: "${img_input}  

img_output_size="400x300"
img_col=3
full_path_current=$(pwd)
parent_dir=${full_path_current##*/}

# Alternative title: img_title="Montage"$(date +"%Y%m%d")_${img_name}
img_title="Montage-"${parent_dir}"_"${img_name}
echo "The Image Title: "$img_title


# Make montage=================================================================

printf "\n############################################\n\n" | tee -a ${RUNLOG}
echo "Run by $(whoami) on $(date)" | tee -a ${RUNLOG}
printf "\n" | tee -a ${RUNLOG}


echo  "magick montage  -label %d%f -title "${img_title}" -tile ${img_col:=2}x -geometry ${img_output_size}+4+4 ${img_input} ${img_title// /_}.jpg" | tee -a  ${RUNLOG}
	       	

magick montage -label %d%f \
               -title "${img_title}" \
	       -tile "${img_col:=2}x"  \
	       -geometry "${img_output_size}+4+4" \
               "${img_input}" "${img_title// /_}".jpg 2>> ${RUNLOG}   # separate this line to two lines  >> will cause error 

printf "\n####################### Done! ##############################\n\n" | tee -a ${RUNLOG}



# Reading image files by magick****************************************

# 1. The special character '@' at the start of a filename, means replace the filename, with contents of the given file.
#   echo "eye.gif news.gif storm.gif" > filelist.txt
#   convert @filelist.txt  -frame 5x5+2+2 +append filelist.gif

# 2. You can also use '@' with the special filename '-' to read the filenames from standard input.

#   echo "eye.gif news.gif storm.gif" |\
#   convert @- -frame 5x5+2+2 +append filelist_stdin.gif

#********************************************************************

# Img input options**************************************
# 
#   1. *.tif   
#   2. a command like :$(ls -1 {$input_dir}/*.png | sort -g)  
#   3. @list.txt (put file names in a txt file called list.txt 
#       example: 
#       Image_8074_10x_bf.tif Image_8074-8075_10x_PKH.tif blank.tiff                      # 2 files and one place holder
#       Image_8076_10x_bf.tif Image_8076-8077_10x_bf.tif Image_8076-8078_20x_PKH.tif      # 3 files

# RUNLOG******************************** 
#    RUNLOG=${HOME}/Documents/Wang/magicK_runlog.txt
#    MagickMontage=${HOME}/Documents/Wang/magickMontage_images.sh
