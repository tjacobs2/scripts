#!/bin/bash
#
# This script is used to split up the list of pdbs in the
# current directory into managable groups analysis in pyMOL
#
if [[ -z "$1" ]]; then
	echo "usage: split_for_pymol.sh *pdb group index*"
	exit 1
fi

numPdbs=`find . -name "*.pdb" | wc -l`
delimiter=20
group=$1
include=`echo ${delimiter}*${group} | bc`
max=`echo ${delimiter}*${group}-${delimiter} | bc`

if [ $include -ge $numPdbs ]; then
	subtract=`echo $include-$numPdbs | bc`
	delimiter=`echo $delimiter-$subtract | bc`
fi

if [ $max -ge $numPdbs ]; then
	echo "Not that many groups"
else
	find . -name "*.pdb" | head -n $include | tail -n $delimiter | tr '\n' ' '
fi
