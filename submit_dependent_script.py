#! /usr/bin/env python
import sys
import os

# this script is pretty generic: it will create a bsub command from a list of jobs
# that have been submitted already and will create a "done" string listing all of
# those jobs as having to complete before a particular script can be submitted.

# arg1: the submission-log file with lines looking like:
#     Job <4840690> is submitted to queue <32cpu>.
# arg2: the script to be run once all the jobs in the submission-log file have completed.


def get_jobids( fname ) :
	joblist = []
	for line in open( fname ).readlines():
		cols = line.split()
		if len(cols) < 1 : continue
		if cols[0] != "Job": continue
		jobid = int( cols[1][1:-1] )
		joblist.append( jobid )
	return joblist

def job_done_string( joblist ):
 cond = "\"("
 for job in joblist :
	 cond += "done( " + str( job ) + " ) && "
 cond = cond[:-4] + ")\""
 return cond

if __name__ == "__main__" :
	if len(sys.argv) != 3 :
		print "Error: expected at least 2 arguments -- arg1 == submission-log file, arg2 == script to run"
		sys.exit(1)
	submission_logfile = sys.argv[1]
	script = sys.argv[2]
	joblist = get_jobids( submission_logfile )
	cond = job_done_string( joblist )
	if script.find( "/" ) != -1 :
		script_name = script.rpartition("/")[ 2 ]
	else :
		script_name = script
	sub_cmd = "bsub -o log_submit_" + script_name + ".log -n 1 -q debug -w " + cond + " source " + script
	print sub_cmd
	os.system( sub_cmd )
