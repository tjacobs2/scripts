#!/usr/bin/perl

if($#ARGV!=0){
	print "Calculates list of excel-friend mutations (from the required reference pdb) for each of the files in the current directory that end in pdb\nUsage: pdbMutationsToCSV.pl <reference pdb>\n";
	exit(1);
}

my $referencePDB = $ARGV[0];
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
			print $nativesTable[$res] . "\t";
		}
	}
	print "\n";
}

#remove the 0 resnum from the res nums array and then print pymol-friendly selection
shift(@resnums);
$"= " OR resi ";
print "select resi @resNums \n"
