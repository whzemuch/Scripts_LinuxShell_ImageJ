#!/bin/bash

# Hanzhou Wang 20191029
# Purpose: Use magick(win version) to make montage

#*************************************************************************************************************
# Usage: 1. Set the parameters as below
#        2. Right click folder containing images and select "git bash", then run bash magickMontage_images.sh
#*************************************************************************************************************

# Exit this script on any error.

set -euo pipefail

#************************************************************

# Settings
img_name="This is a test"
img_input_type="*.jpg"


img_output_size="400x300"
img_col=2

img_title="Montage"$(date +"%Y%m%d")_${img_name}

# This keeps track of the messages printed during execution.
RUNLOG=runlog.txt
echo "Run by `whoami` on `date`" >> ${RUNLOG}

#************************************************************

# magick montage --help
echo  "magick montage  -label %d%f -title "${img_title}" -tile ${img_col:=2}x -geometry ${img_output_size}+4+4 ${img_input_type} ${img_title// /_}.jpg" >> ${RUNLOG}
	       	

magick montage  -label %d%f \
         	-title "${img_title}" \
		-tile ${img_col:=2}x  \
		-geometry ${img_output_size}+4+4 \
		${img_input_type} ${img_title// /_}.jpg 2>> ${RUNLOG} 
