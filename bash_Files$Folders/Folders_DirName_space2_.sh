#!/bin/bash


# Purpose: recusively replace space in folder name with _ in a target folder and subfolder


# Usage===========================
#  bash dirname_space2_.sh  
#=================================

# Exit on any error

set -euo pipefail
set -x 


find  . -type d | 
   while read dir; do 
     if [ "$dir" != "${dir%[[:space:]]*}" ]; then  # find if dirname has a space
	  
       mv "${dir}"  "${dir/ /_}"
       echo "$dir""   >   " "${dir/ /_}"
     fi
   done
