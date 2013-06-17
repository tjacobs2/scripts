#!/usr/bin/perl

#USE THIS tr '\015' '\n' < very_filtered_scores.txt

die "Usage: $0 < files >\n" unless @ARGV;

for $file (@ARGV)
{
    open IN, $file or die "$0: Cannot open $file for input!\n";

    my @lines = <IN>;

    close IN;
    open OUT, "> $file" or die "$0: Cannot open $file for output!\n";

    s/\r$// for @lines;
    print OUT for @lines;
}
