#!/bin/bash

# by Hanzhou Wang 6/20/20
# Purpose: Search the key word in all the Rmd files in the specified folders
# Usage:==================================================
# ./findStings@rmd  keyword
#
# ========================================================

# exit if any error occurs
set -euo pipefail
#set -x # debug mode

# Store the target folders in an array. ** When  XiaoYa folder and 00_Rprojs folder were put next each other, it will only one of them that is on the top, therefor I put F-Proj_data to separate them
target_path=(
"/mnt/c/Users/whzemuch/Documents/00_Rprojs/01_Rproj_Visulization_XiaoYa"
"/mnt/f/F_Rproj_data"
"/mnt/c/Users/whzemuch/Documents/00_Rprojs"
)


# it will take longer time to finish searching, also have problems in folder' name with space
# mapfile -d ''  dirs < <(find /mnt/c/Users/whzemuch/Documents /mnt/f/WSLapp -maxdepth 3 -type d -name "*Rproj*" ! -name "*Rproj.user" -print0)

# Generate the file list for grep command
for item in "${target_path[@]}"
# for item in "${dirs[@]}"
do
    include_path="${target_path}/*/*.Rmd ${item}/*/*.Rmd"
done

# Get the keyword from command line
key=$1
# echo ${include_path}
# Use grep command to search keyword and output to screen: --color=always will keep the color
#grep -nr --color=always ${key} /mnt/c/Users/whzemuch/Documents/*/*.Rmd /mnt/f/WSLapp/*/*.Rmd
grep -Enr -B 2 -A 3  --color=always ${key} ${include_path} | less -SNr
