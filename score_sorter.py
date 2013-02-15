#! /usr/bin/env python
import sys
import os
import commands
import argparse

parser = argparse.ArgumentParser(description="Run loop creation designer on helix sewing output.")
parser.add_argument("score_file", help="score file to sort")
parser.add_argument("columns", help="Columns. If only one is given then we sort on this column and print everything. If multiple columns are given then sort on the first and print all of them", nargs="+")
parser.add_argument("-l", "--list", help="list score file headers", action="store_true")
args = parser.parse_args()

file = open(args.score_file, 'r')
lines = file.readlines()

headers=lines[1].split()

if(args.list):
	print headers
	exit(1)
else:
	all_data=[]
	for line_index in range(2,len(lines)):
		cols=lines[line_index].split()
		line_data=[]
		for col_index in range(0,len(cols)):
			line_data.append(cols[col_index])
		all_data.append(line_data)

found=False
for header_index in range(0, len(headers)):
	if(headers[header_index] == args.columns[0]):
		sorted_data = sorted(all_data, key=lambda row: float(row[header_index]))
		found=True;

if(not found):
	print "Column name not found. For a list of columns use the -l flag"
	exit(1);

print headers
for row in sorted_data:
	print_line = ""
	for field_index in range(0, len(row)):
		if(len(args.columns)==1 or headers[field_index] in args.columns):
			print_line=print_line+row[field_index]+" "
	print print_line

