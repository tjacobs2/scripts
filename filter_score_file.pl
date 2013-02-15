#!/usr/bin/perl

use Getopt::Long;

&Getopt::Long::Configure('pass_through', 'no_autoabbrev');
&Getopt::Long::GetOptions('help|h' => \$help,
	'input|i=s' => \$fileName,
	'score|s:f' => \$scoreCut,
	'ddg|d:f' => \$ddgCut,
	'rmsd|r:f' => \$rmsdCut,
	'sasa:f' => \$sasaCut,
	'unsat:f' => \$unsatCut,
	'ddgSasa:f' => \$ddgSasaCut,
	'sasaUnsat:f' => \$sasaUnsatCut,
	);

if($help == 1){
	print "retrieve score file entries on any of the following metrics (assuming they exist in your score file):
	input* -- score file name
	score -- score cutoff
	ddg -- ddg cutoff
	rmsd -- rmsd cutoff
	sasa -- sasa cutoff
	unsat -- unsat cutoff
	ddgSasa -- ddgSasa cutoff
	sasaUnsat -- sasaUnsat cutoff\n";
	exit(0);
}

if(! $fileName){
	print "Error: must provide score file name using -i or --input\n";
	exit(1);
}

chomp $fileName; ## Chomp the last parameter because it has the newline character

open(my $inputFile, "$fileName") || die("Can't open $fileName:!\n");

my @colNames;
my $count = 0;
while($line=<$inputFile>){
	chomp($line);
	if($line=~/^SCORE/){
		if($count==0){
			@colNames = split(/\s+/,$line);
		}
		else{
			@vals = split(/\s+/,$line);
			for($i=0; $i<=$#colNames; $i++){
				if($colNames[$i] eq "total_score"){
					$energy = $vals[$i];	
				}
				if($colNames[$i] eq "packstat"){
					$packstat = $vals[$i];	
				}
				if($colNames[$i] eq "ddg_lax"){
					$ddg = $vals[$i];
				}
				if($colNames[$i] eq "rms"){
					$rmsd = $vals[$i];
				}
				if($colNames[$i] eq "sasa"){
					$sasa = $vals[$i];
				}
				if($colNames[$i] eq "unsats"){
					$unsats = $vals[$i];
				}
				if($colNames[$i] eq "description"){
					$desc = $vals[$i];
				}
			}
			if($sasa != 0){
				$ddgSasa = ($ddg/$sasa);
			}
			if($unsats != 0){
				$sasaUnsat = ($sasa/$unsats);
			}
			else{
				$sasaUnsat = "N/A";
			}
			if( (!$scoreCut or $energy < $scoreCut) and
					(!$ddgCut or $ddg < $ddgCut) and
					(!$rmsdCut or $rmsd<$rmsdCut) and 
					(!$ddgSasaCut or $ddgSasa < $ddgSasaCut) and 
					(!$sasaUnsatCut or $sasaUnsat eq "N/A" or $sasaUnsat > $sasaUnsatCut)
					){
				print $desc . ":\n\tenergy:" . $energy . "\n\trmsd:" . $rmsd . "\n\tddg:" . $ddg . "\n\tsasa:" . 
				$sasa . "\n\tburied unsatisfied:" . $unsats . 
				"\n\t(dg/sasa):" . $ddgSasa . "\n\t(sasa/unsat):" . $sasaUnsat . "\n";

				$desc =~ s/.*_//g;
				print "$desc\t$energy\t$rmsd\t$ddg\t$sasa\t$unsats\t$firstMetric\t$secondMetric\n";
			}
		}
		$count++;
	}
}
