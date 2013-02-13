#!/usr/bin/perl
#lists the mutations from one pdb to another
#by Bryan Der and Ben Stranges

my $pdb1_input = $ARGV[0];
my $pdb2_input = $ARGV[1];

my $pymol_sel = "";

#Write a temporary file with only C-alpha lines
print "Comparing $pdb1_input and $pdb2_input \n";
my $name_length = length($pdb2);
my $pdb2_substr = substr($pdb2, 0, $name_length - 4 );

system("grep \" CA \" $pdb1_input > pdb1");
system("grep \" CA \" $pdb2_input > pdb2");

my @seq1;
my @seq2;

$seq1[0] = "";
$seq2[0] = "";
$chain1[0] = "";
$res1[0] = "";

# open the input files for kicks
open (PDB1_INPUT, "< $pdb1_input" );
open (PDB2_INPUT, "< $pdb2_input" );


#Fill a vector in which index equals residue number, and the string is the 3-letter amino acid name
#also make a vector with the pdb resnum and the chain
my $i = 1;
open PDB1, "<pdb1";
while ( <PDB1> ) {
    my $line = $_;
    chomp($line);
    $seq1[$i] = substr($line, 17, 3);
    $chain1[$i] = substr($line, 21, 1);
    $res1[$i] = substr($line, 23, 3);
    while(substr($res1[$i],0,1) eq " "){
      $res1[$i]=substr($res1[$i],1,length($res1[$i]));
    }

    $i++;
}

#Fill the second vector, and at each step along the way, compare that AA with the AA of that same index(residue number) from the first pdb
$i = 1;
$curr_chain = "_";
$res2[0] = "";
$chain2[0] = "";
open PDB2, "<pdb2";
while ( <PDB2> ) {
    my $line = $_;
    chomp($line);
    $seq2[$i] = substr($line, 17, 3);
    $chain2[$i] = substr($line, 21, 1);
    $res2[$i] = substr($line, 23, 3);

    #$crap = substr($res2[$i], 0, length($res2[$i]));
    #print "resid_start:" . $res2[$i]; 

    while(substr($res2[$i],0,1) eq " "){
      $res2[$i]=substr($res2[$i], 1, length($res2[$i]));
    }
    #print ".  cleaned_resid:". $res2[$i].". \n";

    if($seq2[$i] ne $seq1[$i]) {

      #make what we need to look for
      $Enative=0.0;
      $Emut=0.0;
      #print"Looking for: " . $string1 . " and " . $string2 . "\n";

      #now find the energies
      while(my $pdb1_line = <PDB1_INPUT>){
	@this_line = split(/\s+/,$pdb1_line);
	@resident = split("_",@this_line[0]);
	if(($seq1[$i] eq @resident[0] ) and ($i eq @resident[-1]) ){
	  #print "FOUND 1: ";
	  $Enative = @this_line[-1];
	  #print "Enative: " . $Enative ."\n";
	  last;
	}
      }
      while(my $pdb2_line = <PDB2_INPUT>){
	@this_line = split(/\s+/,$pdb2_line);
	@resident = split("_",@this_line[0]);
	if(($seq2[$i] eq @resident[0] ) and ($i eq @resident[-1]) ){
	  #print "FOUND 2: ";
	  $Emut = @this_line[-1];
	  #print "Emut: " . $Emut ."\n";
	  last;
	}
      }
      $Ediff =sprintf("%.3f", $Emut - $Enative) ;
      #print "Ediff: " . $Ediff . "\n" ;
      #Let's work with the one-letter code instead...
      if ($seq1[$i] eq "ALA") {$seq1[$i] = "A";}
      elsif ($seq1[$i] eq "ARG") {$seq1[$i] = "R";}
      elsif ($seq1[$i] eq "ASN") {$seq1[$i] = "N";}
      elsif ($seq1[$i] eq "ASP") {$seq1[$i] = "D";}
      elsif ($seq1[$i] eq "CYS") {$seq1[$i] = "C";}
      elsif ($seq1[$i] eq "GLN") {$seq1[$i] = "Q";}
      elsif ($seq1[$i] eq "GLU") {$seq1[$i] = "E";}
      elsif ($seq1[$i] eq "GLY") {$seq1[$i] = "G";}
      elsif ($seq1[$i] eq "HIS") {$seq1[$i] = "H";}
      elsif ($seq1[$i] eq "ILE") {$seq1[$i] = "I";}
      elsif ($seq1[$i] eq "LEU") {$seq1[$i] = "L";}
      elsif ($seq1[$i] eq "LYS") {$seq1[$i] = "K";}
      elsif ($seq1[$i] eq "MET") {$seq1[$i] = "M";}
      elsif ($seq1[$i] eq "PHE") {$seq1[$i] = "F";}
      elsif ($seq1[$i] eq "PRO") {$seq1[$i] = "P";}
      elsif ($seq1[$i] eq "SER") {$seq1[$i] = "S";}
      elsif ($seq1[$i] eq "THR") {$seq1[$i] = "T";}
      elsif ($seq1[$i] eq "TRP") {$seq1[$i] = "W";}
      elsif ($seq1[$i] eq "TYR") {$seq1[$i] = "Y";}
      elsif ($seq1[$i] eq "VAL") {$seq1[$i] = "V";}
      else {$seq1[$i] = " "};
	
      if ($seq2[$i] eq "ALA") {$seq2[$i] = "A";}
      elsif ($seq2[$i] eq "ARG") {$seq2[$i] = "R";}
      elsif ($seq2[$i] eq "ASN") {$seq2[$i] = "N";}
      elsif ($seq2[$i] eq "ASP") {$seq2[$i] = "D";}
      elsif ($seq2[$i] eq "CYS") {$seq2[$i] = "C";}
      elsif ($seq2[$i] eq "GLN") {$seq2[$i] = "Q";}
      elsif ($seq2[$i] eq "GLU") {$seq2[$i] = "E";}
      elsif ($seq2[$i] eq "GLY") {$seq2[$i] = "G";}
      elsif ($seq2[$i] eq "HIS") {$seq2[$i] = "H";}
      elsif ($seq2[$i] eq "ILE") {$seq2[$i] = "I";}
      elsif ($seq2[$i] eq "LEU") {$seq2[$i] = "L";}
      elsif ($seq2[$i] eq "LYS") {$seq2[$i] = "K";}
      elsif ($seq2[$i] eq "MET") {$seq2[$i] = "M";}
      elsif ($seq2[$i] eq "PHE") {$seq2[$i] = "F";}
      elsif ($seq2[$i] eq "PRO") {$seq2[$i] = "P";}
      elsif ($seq2[$i] eq "SER") {$seq2[$i] = "S";}
      elsif ($seq2[$i] eq "THR") {$seq2[$i] = "T";}
      elsif ($seq2[$i] eq "TRP") {$seq2[$i] = "W";}
      elsif ($seq2[$i] eq "TYR") {$seq2[$i] = "Y";}
      elsif ($seq2[$i] eq "VAL") {$seq2[$i] = "V";}
      else {$seq2[$i] = " "};

      #set up mut outputs
      my $out = $out . $seq1[$i] . $res2[$i] . $seq2[$i]. "(" .$Ediff. ") ";
      #print out better pymol selection stuff!
      if ($curr_chain eq $chain2[$i]){
	#print "$out";
	$pymol_sel = $pymol_sel . $res2[$i] . "+";
      }
      else{
	print "\n"."Chain: ".$chain2[$i]."\n";
	$pymol_sel = $pymol_sel. " /".$pdb2_substr."//".$chain2[$i]."/".$res2[$i]."+";
	#print "$out";
      }
      $curr_chain = $chain2[$i];
      print $out;
    }
    $i++;
  }

print "\n";
system("rm pdb1 pdb2");
print "pymol: select $pdb2_substr\_muts, $pymol_sel\n";
