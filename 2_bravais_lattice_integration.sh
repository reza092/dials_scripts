#!/usr/bin/env bash
set -e

# Check if an argument was provided
if [ -z "$1" ]; then
    echo "Error: Missing argument."
    echo "Usage: $0 bravais_setting_#.expt (or just the number #)"
    exit 1
fi

EXPT_INPUT="$1"

# If user passed just a number (e.g. 2), expand to filename format
if [[ "$EXPT_INPUT" =~ ^[0-9]+$ ]]; then
    EXPT_FILE="bravais_setting_${EXPT_INPUT}.expt"
else
    EXPT_FILE="$EXPT_INPUT"
fi

echo "Running refinement with: ${EXPT_FILE}"
echo "----------------------------------------------------------------------"

dials.refine "${EXPT_FILE}" reindexed.refl 2>&1 | tee 05_refine.log
dials.integrate refined.expt refined.refl nproc=12 2>&1 | tee 06_integrate.log

echo "----------------------------------------------------------------------"
echo "Refinement complete! Log saved to 05_refine.log"
echo "Integration complete! Log saved to 06_integrate.log"
