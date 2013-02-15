#! /usr/bin/env python
import argparse
import os
import commands

# This class provides the functionality we want. You only need to look at
# this if you want to know how this works. It only needs to be defined
# once, no need to muck around with its internals.
class switch(object):
    def __init__(self, value):
        self.value = value
        self.fall = False

    def __iter__(self):
        """Return the match method once, then stop"""
        yield self.match
        raise StopIteration
    
    def match(self, *args):
        """Indicate whether or not to enter a case suite"""
        if self.fall or not args:
            return True
        elif self.value in args: # changed for v1.5, see below
            self.fall = True
            return True
        else:
            return False

parser = argparse.ArgumentParser(description='Copy project files from a remote machine to this one.')
parser.add_argument('servername', help='server to copy from')
parser.add_argument('-r', '--recurse', help='recurse', action="store_true")
parser.add_argument('--user', help='username, if not default (tjacobs2)', default="tjacobs2")
parser.add_argument('--exclude', help='exclusion list to be used by rsync command')
parser.add_argument('--delete', help='delete files that exist locally, but not remotely. USE WITH CAUTION', action="store_true")
args = parser.parse_args()

for case in switch(args.servername):
	if case('contador'):
		#server="contador.med.unc.edu"
		server="rosettadesign.med.unc.edu"
		break
	if case('garin'):
		server="garin.med.unc.edu"
		break
	if case('killdevil'):
		server="killdevil.unc.edu"
		break
	if case('imac'):
		server="152.19.81.194"
		break
	if case():
		print "Error: unknown server "+args.servername
		exit(1)

pwd = commands.getoutput("pwd")
tokens = pwd.split("PROJECTS")
if(len(tokens) < 2):
	print "You aren't in a PROJECTS subdirectory!"
	exit(1)
project_path = tokens[1]
print project_path

rsync_options = ""
if(args.recurse):
	rsync_options += " -r "
if(args.exclude):
	rsync_options += " --exclude='"+args.exclude+"' "
if(args.delete):
	rsync_options += " --delete "

os.system("rsync "+rsync_options+" -v -e ssh "+args.user+"@"+server+":~/PROJECTS/"+project_path+"/ ~/PROJECTS/"+project_path);
