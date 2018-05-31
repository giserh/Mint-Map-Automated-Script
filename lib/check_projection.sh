#!/usr/bin/env bash
set -e

### check_projection.sh
# Checks to see if a data file is projected into WGS 84 / Pseudo-Mercator
# (EPSG: 3857) and projects it using gdalwarp if necessary.
### Inputs: 
# Data file to check
### Outputs:
# File in EPSG: 3857 PCS with _proj.tif suffix
### Procedure:
# - Creates a temporary text file of the data file's gdalinfo
# - Uses grep on text file to see if file is projected
# - Projects file into EPSG: 3857 if necessary
# - Clean up temporary file

# Parse arguments:
export INPUT=$1
export OUTPUT=$2

# Get gdalinfo of input:
export GDALINFO="$(gdalinfo $INPUT)"

# Make temporary text file:
export TEMP=${INPUT%.*}_temp.txt
touch $TEMP
echo $GDALINFO >> $TEMP

# Check to see if data is projected:
if ! grep -q 'PROJCS\["WGS 84 / Pseudo-Mercator"' $TEMP; then
	gdalwarp \
	-t_srs EPSG:3857 \
	-r near \
	$INPUT $OUTPUT

else
	cp $INPUT $OUTPUT
fi

# Remove temporary file:
rm $TEMP