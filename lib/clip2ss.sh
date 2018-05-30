#!/usr/bin/env bash
set -e

### clip2ss.sh
# Clips data layer to South Sudan boundary as defined by input shapefile.
# (Note: Only works on unprojected data)
### Inputs: 
# 1) Data file to clip, 2) Name of output file, 3) South Sudan shapefile
### Outputs: 
# Clipped file
### Procedure:
# - Parse arguments
# - Clip with gdalwarp

# Parse inputs:
export INPUT=$1
export OUTPUT=$2
export SOUTH_SUDAN=$3

# Clip to South Sudan Boundary:
gdalwarp \
-te 22.4 3.4 37.0 23.2 \
-dstnodata 255 \
-cutline $SOUTH_SUDAN \
$INPUT $OUTPUT