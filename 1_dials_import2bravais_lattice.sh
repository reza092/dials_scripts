#!/usr/bin/env bash
set -e

echo "DIALS is assuming image files are located one directory above (../*.h5)."
echo "All steps will generate individual log files. For any errors or incongruities, please check the corresponding log file."
echo "DIALS is using 16 CPU cores."
echo "----------------------------------------------------------------------"

dials.import ../*.h5 2>&1 | tee 01_import.log
dials.find_spots imported.expt nproc=16 2>&1 | tee 02_find_spots.log
dials.index imported.expt strong.refl 2>&1 | tee 03_index.log
dials.refine_bravais_settings indexed.expt indexed.refl nproc=16 2>&1 | tee 04_bravais.log

echo "----------------------------------------------------------------------"
echo "Processing complete! All steps (Import, Spot Finding, Indexing, and Bravais refinement) finished successfully."
