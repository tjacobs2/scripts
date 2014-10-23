#!/usr/bin/python

import argparse
import math

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

parser = argparse.ArgumentParser(description="Evaluate statistics for each fragment window")
parser.add_argument("score_file", help="score file")
args = parser.parse_args()

numerator = 0.0
denominator = 0.0
lam = 2
score_file = open(args.score_file, 'r')
for line in score_file:
	cols = line.split()
	if(is_number(cols[1])):
		energy = float(cols[1])
		rms = float(cols[23])
		numerator += math.exp(-1*(rms*rms)/(lam*lam)) * math.exp(-energy )
		denominator += math.exp( -energy )
print numerator/denominator
