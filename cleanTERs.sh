linenums=`awk '/^TER/ { print FNR }' $1`

for i in $linenums; do
	precedingchain=`awk -v linenum="${i}" '{ if(NR==linenum-1){ print substr($0,22,1)  } }' $1`
	nextchain=`awk -v linenum="${i}" '{ if(NR==linenum+1){ print substr($0,22,1)  } }' $1`
	echo $precedingchain
	echo $nextchain
done
