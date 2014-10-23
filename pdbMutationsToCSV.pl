#!/usr/bin/perl

use List::MoreUtils qw(firstidx);

if($#ARGV!=0){
	print "Calculates list of excel-friend mutations (from the required reference pdb) for each of the files in the current directory that end in pdb\nUsage: pdbMutationsToCSV.pl <reference pdb>\n";
	exit(1);
}

my $referencePDB = $ARGV[0];
my @AAlist  = sort(split(//, "ARNDCQEGHILKMFPSTWYV"));
chomp $referencePDB; ## Chomp the last parameter because it has the newline character

@foo = `ls *.pdb`;
#@foo = $ARGV[1];
@mutationsTable;
@nativesTable;
$count=0;
@resNums;
push(@resNums, 0);
foreach $fileName (@foo) {
	if($fileName =~ /.*_(\d+)\.pdb/){
		$decoyNumber = $1;
	}
	@mutationsListOut = `list_mutations.pl $referencePDB $fileName`;	
	@mutationsList = split(/\s+/,$mutationsListOut[3]);
	foreach $mutation (@mutationsList){
		if($mutation =~ /(\w)(\d+)(\w)/){
			$nativeRes = $1;
			$mutatedRes = $3;
			$resNum = $2;
			if(!grep $_ eq $resNum, @resNums){
				push(@resNums, $resNum);
			}
			$mutationsTable[$count][0]=$decoyNumber;
			$mutationsTable[$count][$resNum]=$mutatedRes;
			$nativesTable[$resNum]=$nativeRes;
			#print "resNum: $resNum\n";
			#print "native Res: " . $nativesTable[$resNum] . "\n";
		}
	}
	$count++;
}
#sort the resnums array by numbers
@resNums = sort {$a <=> $b} @resNums;
print join(",", @resnums);
exit;

foreach $res (@resNums){
	print $nativesTable[$res] . "\t";
}
print "\n";

foreach $res (@resNums){
	print $res . "\t";
}
print "\n";

for ($i=0; $i<=$count-1; $i++) {
	foreach $res (@resNums){
		if($mutationsTable[$i][$res]){
			print $mutationsTable[$i][$res] . "\t";
		}
		else{
			print "WT\t";
		}
	}
	print "\n";
}

#setup table of final muts
my @finalAATable;
#go through and figure out what's what
for (my $i=0; $i<=$count-1; $i++) {
  foreach my $res (@resNums){
    if($mutationsTable[$i][$res] ){
      print $mutationsTable[$i][$res];
      $finalAATable[$i][$res] = $mutationsTable[$i][$res];
      #don't need to reprint the first one
      if($res != 0){
	print $energiesTable[$i][$res];}
      print"\t";
    }
    else{
      print $nativesTable[$res] . "\t";
      $finalAATable[$i][$res] = $nativesTable[$res];
    }
  }
  print "\n";
}

#remove the 0 resnum from the res nums array and then print pymol-friendly selection
shift(@resnums);
$"= " OR resi ";
print "select resi @resNums \n";

my @frequencyTable;
for (my $j=0; $j<=$count-1; $j++) {
  foreach my $res (@resNums){
    my $thisres = $finalAATable[$j][ $res ];
    print "Residue # ". $res ." is: " . $thisres . "\n";
    #does nothing yet
    #get index of Amino Acid
    my $res_id = firstidx { $_ eq $thisres } @AAlist;
    $frequencyTable[$res_id][ $res ] = $frequencyTable[$res_id][ $res ] + 1;
    #put info into the energies table
  }
}

print "Residue Counts Table: \n";
print "aa/pos \t";
foreach my $res (@resNums){
	print $res . "\t";
}
print "\n";
for (my $aa=0; $aa<= $#AAlist; $aa++){
  print $AAlist[$aa]. "\t";
  for (my $res=0; $res<= $#resNums; $res++ ){
    if($frequencyTable[$aa][$resNums[$res]]){
      print $frequencyTable[$aa][$resNums[$res]] . "\t";
    }
    else{
      print "0" . "\t";
	 }
  }
print "\n";
}
