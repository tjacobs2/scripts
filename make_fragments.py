#!/usr/bin/env python
import os
import sys
import argparse
from shutil import copy

def chckmkdir(path,out = sys.stdout):
	if not os.path.exists(path):
		os.mkdir(path)
		return True
	else:
		return False

parser = argparse.ArgumentParser(description="Pick fragments for pdb file")
parser.add_argument("pdb_file", help="pdb file")
args = parser.parse_args()

fragment_tools = '/home/tjacobs2/PROJECTS/fragments_baker'
scripts_dir = '/home/tjacobs2/workspace/rosetta_extras/bakerlab_scripts/boinc'
nnmake = '/home/tjacobs2/PROJECTS/fragments_baker/nnmake/pNNMAKE.gnu'
  
currentdir = os.getcwd()
basename, extension = os.path.splitext(args.pdb_file)
pdbname = os.path.split(basename)[-1]
exec_dir = currentdir +"/" +  pdbname + "_fragments"
dir_maked  = chckmkdir(exec_dir)

if dir_maked:

	copy(args.pdb_file, exec_dir + "/00001.pdb")
	os.chdir(exec_dir)
	os.system("/home/tjacobs2/bin/pdb2fasta.pl 00001.pdb")
	
	#CSBuild version
	os.system(fragment_tools + "/runpsipred_csbuild_single 00001.fasta")
	os.system(fragment_tools + "/csbuild/csbuild -i  00001.fasta -I fas -D /home/tjacobs2/PROJECTS/fragments_baker/csbuild/csblast-2.2.3/data/K4000.crf -o  00001.check -O chk")
	
	#os.system(fragment_tools + "/make_fragments_tjTest.pl  -nosam -id 00001 00001.fasta -psipredfile 00001.csb.ss2 -nopsiblast_profile")
	
	os.system("cp 00001.csb.ss2 00001.psipred_ss2")
	copy(scripts_dir +"/path_defs.txt", exec_dir)
	os.system(scripts_dir+"/make_checkpoint.pl -id 00001 -fasta 00001.fasta")
	os.system(nnmake + " aa 0000 1")
	os.system("mv aa0000103_05.200_v1_3 00001.200.3mers")
	os.system("mv aa0000109_05.200_v1_3 00001.200.9mers")
	
	#Normal? version
	#os.system(fragment_tools + "/psipred/runpsipred_single 00001.fasta")
	#os.system(fragment_tools + "/make_fragments_tjTest.pl  -nosam -id 00001 00001.fasta -psipredfile 00001.ss2 -nopsiblast_profile")



