#/bin/bash
basename=`pwd`
jobname=$1
struct=$2
scriptfile="$basename""/""$3"
nstruct=10
trials=5
#name and use the newly copied local script

numprocs=20
que="day"
#exe & database
exepath="/home/tjacobs2/rosetta/mini/bin/rosetta_scripts.linuxgccrelease"

logfile="$jobname.run.log"

cmd="$exepath \
-s $struct \
-nstruct $nstruct \
-jd2::ntrials $trials \
-out::pdb_gz true \
-parser:protocol $scriptfile \
-docking::dock_pert 5 7  \
-no_optH false -ex1 -ex2 -use_input_sc \
-run::min_type dfpmin_armijo_nonmonotone \
-mute protocols.moves.RigidBodyMover core.pack.task basic.io.database core.io.pdb.file_data core.scoring.etable \
-extrachi_cutoff 1 \
-linmem_ig 10 \
-ignore_unrecognized_res \
-mpi_tracer_to_file $jobname.tracers \
-overwrite"

#-native $native \

echo $cmd
$cmd

#-ex1 -ex2 -linmem_ig 5 -extrachi_cutoff 0 \
#-interface_cutoff 8.0 \
