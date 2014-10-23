#!/usr/bin/python

import argparse
from subprocess import Popen, PIPE
import sys
import re
import csv

def three_to_one(three):
    if three == "ALA":
        return "A"
    elif three == "ARG":
        return "R"
    elif three == "ASN":
        return "N"
    elif three == "ASP":
        return "D"
    elif three == "CYS":
        return "C"
    elif three == "GLN":
        return "Q"
    elif three == "GLU":
        return "E"
    elif three == "GLY":
        return "G"
    elif three == "HIS":
        return "H"
    elif three == "ILE":
        return "I"
    elif three == "LEU":
        return "L"
    elif three == "LYS":
        return "K"
    elif three == "MET":
        return "M"
    elif three == "PHE":
        return "F"
    elif three == "PRO":
        return "P"
    elif three == "SER":
        return "S"
    elif three == "THR":
        return "T"
    elif three == "TRP":
        return "W"
    elif three == "TYR":
        return "Y"
    elif three == "VAL":
        return "V"

parser = argparse.ArgumentParser(description="Evaluate all mutatiosn against reference")
parser.add_argument("reference", help="reference pdb")
parser.add_argument("-s", "--swiftlib", action="store_true", help="produce output that is swiftlib-ready")
parser.add_argument("-m", "--multiple", type=int, help="produce output that is swiftlib-ready")
args = parser.parse_args()

process = Popen("ls *.pdb", shell=True, stdout=PIPE)
output_files = process.communicate()[0].split('\n')
mut_pattern = re.compile('(\w)(\d+)(\w)')

position_mutations = {}
mutations_count = {
'A':0,
'C':0,
'D':0,
'E':0,
'F':0,
'G':0,
'H':0,
'I':0,
'K':0,
'L':0,
'M':0,
'N':0,
'P':0,
'Q':0,
'R':0,
'S':0,
'T':0,
'V':0,
'W':0,
'Y':0
}

counter = 0
natives = {}
#First, go through and tally up the mutations
native_command = 'grep CA '+args.reference+'| awk \'{foo=substr($0, 23, 4); sub(/[ \\t]+/,"",foo); print foo" "substr($0, 18, 3)}\' | uniq';
natives_proc = Popen(native_command, stdout=PIPE, shell=True)
natives_list = natives_proc.communicate()[0].split('\n')
for output_file in output_files:
    if(output_file.find("pdb") == -1):
        continue
    design_command = 'grep CA '+output_file+'| awk \'{foo=substr($0, 23, 4); sub(/[ \\t]+/,"",foo); print foo" "substr($0, 18, 3)}\' | uniq';
    design_proc = Popen(design_command, stdout=PIPE, shell=True)
    design_list = design_proc.communicate()[0].split('\n')

    native_residues = set(natives_list) - set(design_list)
    #print output_file
    #print native_residues
    #sys.exit(0)
    for residue in native_residues:
        resnum = residue.split()[0]
        aa = three_to_one(residue.split()[1])
        natives[resnum] = aa

    mutated_residues = set(design_list) - set(natives_list)
    #print mutated_residues
    for residue in mutated_residues:
        resnum = residue.split()[0]
        aa = three_to_one(residue.split()[1])
        if resnum in position_mutations:
            position_mutations[resnum][aa] += 1
        else:
            position_mutations[resnum] = mutations_count.copy()
            position_mutations[resnum][aa] += 1
    counter += 1

#Now add any counts for positions where there wasn't always a mutation
for resnum, native in natives.items():
    resnum_mutations_count = 0
    for aa, count in position_mutations[resnum].items():
        resnum_mutations_count += count
    position_mutations[resnum][native] += counter - resnum_mutations_count

resnums = sorted(position_mutations.keys(),key=int)
aas = sorted(position_mutations.values()[0].keys())
print ','.join(["resnum"]+resnums)
if(args.swiftlib):
    if(args.multiple):
        primer_boundaries=['']
        cur_start_res = 0
        for resnum in resnums:
            if(len(primer_boundaries) == 1):
                cur_start_res = int(resnum)
                primer_boundaries.append('|')
            elif(int(resnum) - cur_start_res > 20):
                cur_start_res = int(resnum)
                primer_boundaries.append('|')
            else:
                primer_boundaries.append('-')
        print ','.join(primer_boundaries)
        print ','.join([str(args.multiple)]*(len(resnums)+1))
    else:
        print ','.join(["-"]*(len(resnums)+1))
        print ','.join(["1"]*(len(resnums)+1))
for aa in aas:
    aa_list = []
    aa_list.append(aa)
    for resnum in resnums:
        aa_list.append(str(position_mutations[resnum][aa]))
    print ','.join(aa_list)
if(args.swiftlib):
    print ','.join((["!"]*(len(resnums)+1)))

    #calulate total diversity
    complete_diversity = 1
    for resnum in resnums:
        position_count = 0
        for aa in aas:
            if(position_mutations[resnum][aa] > 0):
                position_count += 1
        complete_diversity *= position_count
    print complete_diversity
