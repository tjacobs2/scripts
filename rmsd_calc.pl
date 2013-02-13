#!/usr/bin/perl
use Math::Complex;
@a = (
Math::Complex->make(-1.42,11.76,43.73),
Math::Complex->make(-4.43,9.48,44.14),
#Math::Complex->make(0, 3),
#Math::Complex->make(0, 3)
);

@b = (
Math::Complex->make(11.634,-19.967,52.077),
Math::Complex->make(15.223,-20.026,53.375),
#Math::Complex->make(0, 3),
#Math::Complex->make(0, 3)
);
foreach(@a){
	push(@distances, abs($a - $b));
}

$counter=0;
$sum=0;
foreach(@distances){
		
}
