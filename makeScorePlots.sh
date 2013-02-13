#!/bin/bash


if [ $# -ne 1 ]
then
  echo "Usage: makeScorePlots.sh score_file"
  exit 1
fi

scorePlotter.pl $1 rmsd energy > rmsd_vs_energy.plot
#scorePlotter.pl score.sc dg energy > dg_vs_energy.plot
#scorePlotter.pl score.sc dgSasa energy > dg-dsasa_vs_energy.plot
