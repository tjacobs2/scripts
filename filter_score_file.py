#!/usr/bin/python

import argparse
import math
import sys
from operator import itemgetter

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

parser = argparse.ArgumentParser(description="Filter a score file based on a variety of columns")
parser.add_argument("score_file", help="score file")
parser.add_argument("--print_names", "-n", action="store_true", help="print field names and exit")
parser.add_argument("--print_summary", "-v", action="store_true", help="print the summary of each field")
parser.add_argument("--filters", "-f", action="append", help="filter a columns values - syntax is field_name:min_value:max_value. If either min or max is excluded, then overall min/max is used.")
parser.add_argument("--count", "-c", action="store_true", help="Return just a count of all fields that pass filters")
parser.add_argument("--desc", "-d", action="store_true", help="Print only the description field at the end")
parser.add_argument("--sort", "-s", type=int, help="Sort by the given field")
args = parser.parse_args()

col_names = []
values = []
score_file = open(args.score_file, 'r')
for line in score_file:
    cols = line.split()

    #remove empty lines and the sequence line if there is one
    if(len(cols) == 0 or cols[0] == "SEQUENCE:"):
        continue

    #remove the SCORE prefix
    cols.pop(0)

    #create a list of fields
    if(cols[0] == "total_score"):
        col_names = cols
        for elem in col_names:
            col_vals = []
            values.append(col_vals)
        if(args.print_names):
            for name in col_names:
                print name
            sys.exit(0)
    #collect all the scores
    else:
        for i in xrange(0, len(cols)):
            if(is_number(cols[i])):
                values[i].append(float(cols[i]))
            else:
                values[i].append(cols[i])

if(args.print_summary):
    for i in xrange(0, len(col_names)):
        if(is_number(values[i][0])):
            print "%s(%d): %.2f -> %.2f" % (col_names[i], i, min(values[i]), max(values[i]))
        else:
            print "%s(%d): %s -> %s" % (col_names[i], i, min(values[i]), max(values[i]))
    sys.exit(0)

#values = np.array(values)
if(args.sort):
    values = sorted(zip(*values), key=itemgetter(args.sort), reverse=True)
    values = list(map(list, zip(*values)))

if(args.filters):
    for f in args.filters:
        fields = f.split(':')
        if(len(fields) != 3):
            "Error parsing filter argument %s" % fields
            raise argparse.ArgumentTypeError(msg)
        index = int(fields[0])
        min_val = fields[1]
        max_val = fields[2]
    
        print "Filtering %s with min value %s and max value %s" % (col_names[index], min_val, max_val)
        elems_to_remove = []
        for i in xrange(0, len(values[index])):
            val = values[index][i]
            if(min_val != "" and val < float(min_val)):
                elems_to_remove.append(i);
            elif(max_val != "" and val > float(max_val)):
                elems_to_remove.append(i);
        for i in elems_to_remove:
            for cols in values:
                cols.pop(i)
            elems_to_remove[:] = [x - 1 for x in elems_to_remove]

if(args.count):
    print "%d decoys pass all filters." % len(values[0])
elif(args.desc):
    desc_index = 0
    for i in xrange(0, len(col_names)):
        if(col_names[i] == "description"):
            desc_index = i
    for i in xrange(0, len(values[desc_index])):
        print(values[desc_index][i])
else:
    for name in col_names:
        print name,
    print
    
    for i in xrange(0, len(values[0])):
        for j in xrange(0, len(col_names)):
            print(values[j][i]),
        print
