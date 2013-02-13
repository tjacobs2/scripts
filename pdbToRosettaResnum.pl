#!/usr/bin/perl

if($#ARGV!=2){
	print "converts a PDB chain and atom number (ie 24A) to a rosetta resnum\n usage pdbToRosettaResnum.pl <pdb files> <pdb chain> <pdb res>\n";
	exit(1);
}

my $fileName = $ARGV[0];
chomp $fileName; ## Chomp the last parameter because it has the newline character

open(my $inputFile, "$fileName") || die("Can't open $fileName:!\n");

my $searchChain=$ARGV[1];
my $searchRes=$ARGV[2];

my $curChain;
my $curPdbnum;
my $resNum = 0;
while($line=<$inputFile>){
	chomp($line);
	if($line=~/^ATOM/){
		$chain = substr($line,21,1);
		$res = substr($line,22,4);
		if($chain ne $curChain or $res!=$curPdbNum){
			$resNum++;	
			$curChain=$chain;
			$curPdbNum=$res;
		}	
		if($chain eq $searchChain and $res==$searchRes){
			print "$resNum\n";	
			exit(0);
		}
	}
}
