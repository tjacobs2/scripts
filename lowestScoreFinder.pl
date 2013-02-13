#!/usr/bin/perl

if($#ARGV!=0){
	print "finds decoy with lowest score, ddg, ddg/sasa, sasa/unsat from a scores.sc file\nusage: lowestScoreFinder.pl <scores file> \n";
	exit(1);
}

my $fileName = $ARGV[0];
chomp $fileName; ## Chomp the last parameter because it has the newline character

open(my $inputFile, "$fileName") || die("Can't open $fileName:!\n");

my @colNames;
my $count = 0;
my $lowEnergy=0;
my $lowDdg=0;
my $lowDdgSasa=0;
my $lowSasaUnsat=0;
my @colNames;
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
					if($energy<$lowEnergy){
						$lowEnergy=$energy;
						$energyLine=$line;
					}
				}
				if($colNames[$i] eq "ddg_filter"){
					$ddg = $vals[$i];
					if($ddg<$lowDdg){
						$lowDdg=$ddg;
						$ddgLine=$line;
					}
				}
				if($colNames[$i] eq "rms"){
					$rmsd = $vals[$i];
				}
				if($colNames[$i] eq "sasa_filter"){
					$sasa = $vals[$i];
				}
				if($colNames[$i] eq "unsats"){
					$unsats = $vals[$i];
				}
				if($colNames[$i] eq "description"){
					$desc = $vals[$i];
				}
			}
			$ddgSasa = ($ddg/$sasa);
			if($ddgSasa<$lowDdgSasa){
				$lowDdgSasa=$ddgSasa;
				$ddgSasaLine=$line;
			}
		}
		$count++;
	}
}
@lowestLines=($energyLine,$ddgLine,$ddgSasaLine);
foreach(@lowestLines){
	@vals = split(/\s+/,$_);
	for($i=0; $i<=$#colNames; $i++){ 
		if($colNames[$i] eq "total_score"){
			$energy = $vals[$i];	
		}
		if($colNames[$i] eq "ddg_filter"){
			$ddg = $vals[$i];
		}
		if($colNames[$i] eq "rms"){
			$rmsd = $vals[$i];
		}
		if($colNames[$i] eq "sasa_filter"){
			$sasa = $vals[$i];
		}
		if($colNames[$i] eq "unsats"){
			$unsats = $vals[$i];
		}
		if($colNames[$i] eq "description"){
			$desc = $vals[$i];
		}
	}
	$ddgSasa = ($ddg/$sasa);
	if($unsats != 0){
		$secondMetric = ($sasa/$unsats);
	}
	else{
		$secondMetric = "N/A";
	}
 	print $desc . ":\n\tenergy:" . $energy . "\n\trmsd:" . $rmsd . "\n\tddg:" . $ddg . "\n\tsasa:" . 
 	$sasa . "\n\tburied unsatisfied:" . $unsats . 
 	"\n\t(dg/sasa):" . $ddgSasa . "\n\t(sasa/unsat):" . $secondMetric . "\n";
	
	$desc =~ s/.*_//g;
	print "$desc\t$energy\t$rmsd\t$ddg\t$sasa\t$unsats\t$ddgSasa\t$secondMetric\n";
}
