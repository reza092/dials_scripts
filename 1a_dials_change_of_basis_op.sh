#!/usr/bin/env bash
set -e

# Check if change_of_basis_op argument was provided
if [ -z "$1" ]; then
    echo "Error: Missing change_of_basis_op value."
    echo "Usage: $0 <op_value>"
    echo "Example: $0 a+b,-a+b,c"
    exit 1
fi

CB_OP="$1"

echo "This step is only required when the selected Bravais lattice requires a change of basis operation."
echo "Applying change_of_basis_op=${CB_OP}..."
echo "----------------------------------------------------------------------"

dials.reindex indexed.refl "change_of_basis_op=${CB_OP}" 2>&1 | tee 04x_bravais_lattice_change_of_basis.log

echo "----------------------------------------------------------------------"
echo "Operation of basis for Bravais lattice changed!"
