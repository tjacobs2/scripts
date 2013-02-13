#!/usr/bin/perl

use Switch;

if($#ARGV!=2){
	print "plot rmsd vs. score\nusage: rmsdVsScore.pl <scores files> <x-axis> <y-axis>\n";
	exit(1);
}

my $fileName = $ARGV[0];
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
				if($colNames[$i] eq "rms"){
					$rmsd = $vals[$i];
				}
				if($colNames[$i] eq "total_score"){
					$energy = $vals[$i];
				}
				if($colNames[$i] eq "ddg_lax"){
					$ddg = $vals[$i];
				}
				if($colNames[$i] eq "sasa"){
					$sasa = $vals[$i];
				}
				if($sasa != 0){
					$dgSasa = ($ddg/$sasa);
				}
			}
			switch($ARGV[1]){
				case "rmsd" {print "$rmsd\t"}
				case "energy" {print "$energy\t"}
				case "dg" {print "$ddg\t"}
				case "dgSasa" {print "$dgSasa\t"}
				else {die "available axis are rmsd, energy, dg, dgSasa"}
			}
			switch($ARGV[2]){
				case "rmsd" {print "$rmsd\n"}
				case "energy" {print "$energy\n"}
				case "dg" {print "$dg\n"}
				case "dgSasa" {print "$dgSasa\n"}
				else {die "available axis are rmsd, energy, dg, dgSasa"}
			}
		}
		$count++;
	}
}

