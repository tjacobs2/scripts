#!/bin/bash

for i in `find . -type d ! \( -name "*.CAP" -o -name "." \)`; do
	cd $i
	filename=`echo $i | sed -r 's/^.{2}//'`
	native=${filename}.pdb
	echo $filename
	if [ -f 00001.200.3mers ] && [ -f 00001.200.9mers ]; then
		if [ ! -f 00001.pdb ]; then
			echo "Can't find native!"
			exit
		fi
		if [ ! -f qual3.out ]; then
			echo "Checking quality of 3mers for $native"
			/home/tjacobs2/workspace/clean_rosetta/source/bin/r_frag_quality.cxx11threadmpi.linuxgccrelease -database /home/tjacobs2/workspace/clean_rosetta/database -in:file:native 00001.pdb -f 00001.200.3mers -out:qual qual3.out
		fi
		if [ ! -f qual9.out ]; then
			echo "Checking quality of 9mers for $native"
			/home/tjacobs2/workspace/clean_rosetta/source/bin/r_frag_quality.cxx11threadmpi.linuxgccrelease -database /home/tjacobs2/workspace/clean_rosetta/database -in:file:native 00001.pdb -f 00001.200.9mers -out:qual qual9.out
		fi
	fi
	cd ../
done
