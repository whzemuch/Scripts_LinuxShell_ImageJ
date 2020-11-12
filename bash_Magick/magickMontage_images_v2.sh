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
#************************************************************

# Settings
img_name="SD rat islets coated with ADMSCs 20200212"
img_input_type="*.tif"


img_output_size="400x300"
img_col=4

# img_title="Montage"$(date +"%Y%m%d")_${img_name}
img_title="Montage"_${img_name}

# This keeps track of the messages printed during execution.
#RUNLOG=${HOME}/Documents/Wang/magicK_runlog.txt
RUNLOG=magicK_runlog.txt
# MagickMontage=${HOME}/Documents/Wang/magickMontage_images.sh
printf "\n############################################\n\n" >>${RUNLOG}
echo "Run by `whoami` on `date`" >> ${RUNLOG}
printf "\n" >> ${RUNLOG}
#************************************************************

# magick montage --help
echo  "magick montage  -label %d%f -title "${img_title}" -tile ${img_col:=2}x -geometry ${img_output_size}+4+4 ${img_input_type} ${img_title// /_}.jpg" >> ${RUNLOG}
	       	

magick montage  -label %d%f \
         	-title "${img_title}" \
		-tile "${img_col:=2}x"  \
		-geometry "${img_output_size}"+4+4 \
		"${img_input_type}" "${img_title// /_}".jpg 2>> ${RUNLOG} 

printf "\n############################################\n\n" >> ${RUNLOG}
