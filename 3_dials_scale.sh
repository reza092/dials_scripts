#!/usr/bin/env bash
set -e

# Read optional d_min argument
D_MIN="$1"

echo "=== Starting DIALS Downstream Pipeline ==="
echo "----------------------------------------------------------------------"

# Step 1: Symmetry assessment
echo "[1/4] Running dials.symmetry..."
dials.symmetry integrated.expt integrated.refl 2>&1 | tee 06_symmetry.log

# Step 2: Initial scaling
echo "[2/4] Running dials.scale (initial)..."
dials.scale symmetrized.expt symmetrized.refl 2>&1 | tee 07_scale.log

# Optional Step: Scale with d_min filter if provided
if [ -n "$D_MIN" ]; then
    echo "[2b] Applying resolution cutoff d_min=${D_MIN}..."
    dials.scale scaled.expt scaled.refl d_min="${D_MIN}" 2>&1 | tee 07b_scale_dmin.log
else
    echo "[2b] No d_min provided. Skipping resolution cutoff scaling step."
fi

# Step 3: Merge reflection data
echo "[3/4] Running dials.merge..."
dials.merge scaled.expt scaled.refl 2>&1 | tee 08_merge.log

# Step 4: Export reflection & experiment files
echo "[4/4] Running dials.export..."
dials.export scaled.refl scaled.expt 2>&1 | tee 09_export.log

# Rename MTZ output
if [ -f "scaled.mtz" ]; then
    mv scaled.mtz dials_processed_scaled.mtz
    echo "✓ Renamed scaled.mtz -> dials_processed_scaled.mtz"
fi

echo "----------------------------------------------------------------------"
echo "Processing complete! Output file: dials_processed_scaled.mtz"
