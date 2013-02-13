for i in `ls -1 *pdb* | sed 's/\(.*\).pdb/\1/'`; do awk '!/^HETATM/{print}' ${i}.pdb > ${i}_clean.pdb; done
