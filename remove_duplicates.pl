#!/usr/bin/perl

@bundle_pdbs = `ls *bundle.pdb`;
foreach $file1 (@bundle_pdbs){
	chomp($file1);
	if (-e $file1) {
		@tokens=split(/_/, $file1);
		@similar_pdbs = `ls *bundle.pdb | grep -v $file1 | grep $tokens[0]`;
		foreach $file2 (@similar_pdbs){
			chomp($file2);
			$rms=`profit -f profit_script.txt $file1 $file2 | grep RMS | cut -c 9-`;
			if ($rms < 1){
				print "$file1 AND $file2 - $rms\n";
				`rm $file2`;
			}
		}
	}
}
