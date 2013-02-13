wget http://www.rcsb.org/pdb/files/${1}.pdb.gz
gunzip ${1}.pdb.gz
awk '!/^HETATM/{print}' ${1}.pdb > ${1}_clean.pdb
