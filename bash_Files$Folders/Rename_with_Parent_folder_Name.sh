#!/bin/bash

# by Hanzhou Wang
# Usage:==============================================================  
#         1. Copy this file to the folder that will be used for naming
#         2. git bash to the same folder
#         3. Run 'bash Rename_with_Parent_folder_Names.sh'
# ====================================================================


# exit if any error occurs

set -eux pipefail

# Setting(define the file type you want to rename)
pattern=JPG

# Loop the files and renaming with mv command

for f in $(find . -type f -name '*.${pattern}'); do
    echo $f
    mv "$f" "$(dirname "$f")/$(dirname "${f:2}" | tr "/" "_")_$(basename $f)"
done



