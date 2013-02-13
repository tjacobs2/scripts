#!/usr/bin/perl

use Getopt::Long;

&Getopt::Long::Configure('pass_through', 'no_autoabbrev');
&Getopt::Long::GetOptions('help|h' => \$help,
	'input|i=s' => \$fileName,
	'pattern|p=s' => \$pattern,
	);

if($help == 1){
	print "pick fragments that have sec struct pattern
  -i
  --input
  \n";
	exit(0);
}

if(! $fileName){
	print "Error: must provide frag file name using -i or --input\n";
	exit(1);
}

if(! $pattern){
	print "Error: must provide pattern -p or --pattern\n";
	exit(1);
}
@patternArray = split('',$pattern);

$length=length($pattern);
open(my $inputFile, "$fileName") || die("Can't open $fileName:!\n");

$counter=0;
$good=1;
$outputString="";
$tempOutputString="";
while($line=<$inputFile>){
	if($line=~/^ \d/){
		@cols = split(/\s+/,$line);
		$secStructure=$cols[5];
		if($secStructure eq $patternArray[$counter]){
			$tempOutputString.=$line;		
		}
		else{
			$good=0;
		}
		$counter++;
		if($counter==$length){
			if($good==1){
				$outputString.=$tempOutputString;
			}
			$tempOutputString="";
			$counter=0;
			$good=1;
		}
	}
	else{
		$tempOutputString.=$line;
	}
}

print $outputString;
