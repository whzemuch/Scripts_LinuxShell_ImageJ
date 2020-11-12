#!/bin/bash

#****************************************





#****************************************

set -euo pipefail
IFS=$`\n\\t`


##  Positional parameters


bar=${foo:-alpha}
name=${1:-}

if [[ -z "$name" ]];then
   echo "Usage: $0 NAME"
   exit 1
fi

echo "Hello $name"


## Commands you expect to have non-zero exit status

count=$(grep -c some_string some-file || true)


## Essential Clean up

scratch=$(mkemp -d  -t tmp.XXXXXXXXXX)

function finish{
  rm -rf "$scratch"
}
trap finish EXIT


## Short-circuiting consideration

[[ -f "$somefile" ]] && echo "Found file:$somefile"

first_task && {
  second_task
  third_task
}
next_task


