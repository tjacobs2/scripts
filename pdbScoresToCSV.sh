if [[ -z "$1" ]]; then
	echo "must give score file"
fi

grepstring=energy
for i in `ls *clean*.pdb | sed 's/.pdb//'`; do 
	grepstring="${grepstring}|${i}"
done
#echo $grepstring
~/bin/interfaceDesignScorer.pl -i $1 | egrep "$grepstring"
