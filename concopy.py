#!/usr/bin/python
import argparse
import os
import commands

parser = argparse.ArgumentParser(description='Copy project files from contador to garin.')
parser.add_argument('--exclude', help='exclusion list to be used by rsync command')
parser.add_argument('--delete', help='delete files that exist on garin but not on contador', action="store_true")
args = parser.parse_args()

pwd = commands.getoutput("pwd")
tokens = pwd.split("PROJECTS")
if(len(tokens) < 2):
	print "You aren't in a PROJECTS subdirectory!"
	exit(1)
project_path = tokens[1]
print project_path

rsync_options = ""
if(args.exclude):
	rsync_options += " --exclude='"+args.exclude+"' "
if(args.delete):
	rsync_options += " --delete "

os.system("rsync "+rsync_options+" -vr -e ssh tjacobs2@rosettadesign.med.unc.edu:/media/scratch/tjacobs2/PROJECTS/"+project_path+"/ /Users/tjacobs2/PROJECTS/"+project_path);
