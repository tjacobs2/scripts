#!/bin/bash
if [[ -z "$1" ]]; then
	echo "usage: pymolSplit *pdb group index*"
	exit 1
fi

numPdbs=`ls *.pdb | wc -l`
delimiter=30
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
	ls *.pdb | head -n $include | tail -n $delimiter | tr '\n' ' '
fi
