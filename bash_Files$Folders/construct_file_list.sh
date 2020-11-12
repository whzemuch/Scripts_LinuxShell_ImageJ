#!/bin/bash

set -euo pipefail
# set -x
current_path_win=$(pwd | sed 's/\/c/c:/' | sed 's/\//\\/g')
echo ${current_path_win}
prefix="c:\Users\whzemuch\Desktop\TCP\C"
middle="-AVG_Image"
suffix="_Coated human islets on TCP  for 7days.jpg"

for i in {9..10} ;do
    for j in {2,1,3} ;do
      echo ${current_path_win}"\C"${j}${middle}${i}${suffix} | tee -a file_list1.txt
  done

done
current_path_win=$(pwd | sed 's/\/c/c:/')
