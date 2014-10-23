#! /usr/bin/env python
import sys
import os
import commands
import argparse

parser = argparse.ArgumentParser(description="Parse MSD output from tracer.")
parser.add_argument("tracer_file", help="tracer to parse")
args = parser.parse_args()

tracer_file = open(args.tracer_file, 'r')

all_output_values = {}
cur_output_values = {}
for line in tracer_file:
    line.strip()
    tokens = line.split()
    if(line.find('sub expression') != -1):
        name = tokens[4]
        value = tokens[7]
        cur_output_values[name] = value
    elif(line.find('EntityFunc') != -1 and line.find('mut_') != -1):
        name = tokens[3]
        value = tokens[4]
        cur_output_values[name] = value
    elif(line.find('msd_output') != -1):
        output_name = tokens[4].split('_')[2]
        if(output_name not in all_output_values):
            #print output_name
            #print cur_output_values
            all_output_values[output_name] = cur_output_values
            cur_output_values = {}

header_line = ""
value_lines = []
for output_name, cur_output in  all_output_values.items():
    header_line = "output_number"
    value_line = output_name
    for name, value in cur_output.items():
        header_line += "\t" + name
        value_line += "\t" + str(value)

    value_lines.append(value_line)

print header_line
for val in value_lines:
    print val

#for output_name, cur_output in  all_output_values.items():
#    print "output number %s " + str(output_name)
#    for name, value in cur_output.items():
#        print "\t" + name + ": " + str(value)



