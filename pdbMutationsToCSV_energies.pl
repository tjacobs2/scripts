#!/usr/bin/perl

use strict;
#use warnings;
use List::MoreUtils qw(firstidx);

if($#ARGV!=0){
	print "Calculates list of excel-friend mutations (from the required reference pdb) for each of the files in the current directory that end in pdb\nUsage: pdbMutationsToCSV.pl <reference pdb>\n";
	exit(1);
}

my @AAlist  = sort(split(//, "ARNDCQEGHILKMFPSTWYV"));
#foreach $amino (@AAlist){
#  print $amino . "\n" 
#}


my $referencePDB = $ARGV[0];
chomp $referencePDB; ## Chomp the last parameter because it has the newline character

my @foo = `ls *.pdb`;
#@foo = $ARGV[1];
my @mutationsTable;
my @energiesTable;
my @frequencyTable;
my @nativesTable;
my $count=0;
my @resNums;
push(@resNums, 0);
#my @mutationAAs;
#push(@mutationAAs,"X");
foreach my $fileName (@foo) {
  my $decoyNumber;
  if($fileName =~ /.*_(\d+)\.pdb/){
    $decoyNumber = $1;
  }
  my @mutationsListOut = `list_mutations_energies.pl $referencePDB $fileName`;	
  my @mutationsList1 = split(/\s+/,$mutationsListOut[3]);
  my @mutationsList2 = split(/\s+/,$mutationsListOut[5]);
  my @mutationsList = (@mutationsList1, @mutationsList2);
  foreach my $mutation (@mutationsList){
    if( $mutation =~ /(\w)(\d+)(\w)(\(-{0,1}\d*\.{0,1}\d+\))/){
      my $nativeRes = $1;
      my $mutatedRes = $3;
      my $resNum = $2;
      my $energy = $4;
      if(!grep $_ eq $resNum, @resNums){
	push(@resNums, $resNum);
      }
      
      $mutationsTable[$count][0]=$decoyNumber;
      $mutationsTable[$count][$resNum]=$mutatedRes; #. $energy;
      $energiesTable[$count][0] = $decoyNumber;
      $energiesTable[$count][$resNum]= $energy;
      #get index of Amino Acid
      #my $mut_res_id = firstidx { $_ eq $mutatedRes } @AAlist;
      #$frequencyTable[$mut_res_id][$resNum] = $frequencyTable[$mut_res_id][$resNum] + 1;
      #print "AA: ". $mutatedRes . " residue: " .$resNum . " has index: ".$mut_res_id."\n";
      #print "mut_res_id: "  .$mut_res_id. " counted x times: " . $frequencyTable[$mut_res_id][$resNum] . "\n";
      #MAKE ENERGY TABLE
      $nativesTable[$resNum]=$nativeRes;
      #print "resNum: $resNum\n";
      #print "native Res: " . $nativesTable[$resNum] . "\n";
    }
  }
  $count++;
}
#sort the resnums array by numbers
@resNums = sort {$a <=> $b} @resNums;

foreach my $res (@resNums){
  print $nativesTable[$res] . "\t";
}
print "\n";

foreach my $res (@resNums){
	print $res . "\t";
}
print "\n";

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
shift(@resNums);
$"= " OR resi ";
print "select resi @resNums \n";


#fill frequencies table:
#and find best energies
my @AAenergies;
for (my $i=0; $i<=$count-1; $i++) {
  foreach my $res (@resNums){
    my $thisres = $finalAATable[$i][ $res ];
    #print "Residue # ". $res ." is: " . $thisres . "\n";
    #does nothing yet
    #get index of Amino Acid
    my $res_id = firstidx { $_ eq $thisres } @AAlist;
    $frequencyTable[$res_id][ $res ] = $frequencyTable[$res_id][ $res ] + 1;
    #put info into the energies table
    my $this_energy = substr($energiesTable[$i][$res],1,-1);
    my $best_energy;
    if(!$AAenergies[$res_id][ $res ]){
      $best_energy=9999.99;
    }
    else{
      $best_energy = $AAenergies[$res_id][ $res ];}
    #print "ThisE: ".$this_energy . " bestE: ". $best_energy ."\n";
    if( $this_energy < $best_energy){
      #print "BEST E! \n";
      $AAenergies[$res_id][ $res ] = $this_energy;
    }
  }
}

#print out the frequency table
#print "Resnums size: " . $#resNums . "\n";
print "Residue Counts Table: \n";
#print "Frequency Table Size ", $#frequencyTable+1 , "\n";
print "aa/pos \t";
foreach my $res (@resNums){
	print $res . "\t";
}
print "\n";
for (my $aa=0; $aa<= $#AAlist; $aa++){
  print $AAlist[$aa]. "\t";
  for (my $res=0; $res<= $#resNums; $res++ ){
    #$temp=$resNums
    if($frequencyTable[$aa][$resNums[$res]]){
      #print "aa" . $aa . " res" . $res . "\t";
      print $frequencyTable[$aa][$resNums[$res]] . "\t";
    }
    else{
      print "0" . "\t";}
  }
print "\n";
}


print "Residue Frequency Table: \n";
#print "Frequency Table Size ", $#frequencyTable+1 , "\n";
#calculate and fill a new table
my @fractionTable;
foreach my $res (@resNums){
  my $total_muts=0;
  #find total first
  for (my $aa=0; $aa<= $#AAlist; $aa++){
    $total_muts += $frequencyTable[$aa][$res];
  }
  #now fill factionTable
  for (my $aa=0; $aa<= $#AAlist; $aa++){
    if($frequencyTable[$aa][$res]){
      my $value =  $frequencyTable[$aa][$res]/$total_muts;
      #print "Value: ".$value."\n";
      $fractionTable[$aa][$res] = sprintf("%.2f",$value);
    }
    else{
      $fractionTable[$aa][$res] = 0;
    }
  }
}

print "aa/pos \t";
foreach my $res (@resNums){
	print $res . "\t";
}
print "\n";
for (my $aa=0; $aa<= $#AAlist; $aa++){
  print $AAlist[$aa]. "\t";
  foreach my $res(@resNums){
    #sum residues in this column
    #print "aa" . $aa . " res" . $res . "\t";
    my $value = $fractionTable[$aa][$res] ;
    my $energy =  $AAenergies[$aa][ $res ];

    print $value ."(" .$energy.")\t";
  }
  print "\n";
}
