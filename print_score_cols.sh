#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: print_score_cols.sh score_file"
  exit 1
fi

awk '{ if(NR==1) { for (i=1; i<=NF; i++){ print i" "$i } } }' $1

