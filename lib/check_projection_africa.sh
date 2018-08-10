#!/usr/bin/env bash

### check_projection.sh
# Checks to see if a data file is projected into WGS 84 
# and projects it using gdalwarp if necessary.
### Inputs: 
# 1) Data file to check, 2) Name of output file
### Outputs:
# File in EPSG: 3857 projected coordinate system with _proj.tif suffix
### Procedure:
# - Creates a temporary text file of the data file's gdalinfo
# - Uses grep on text file to see if file is projected
# - Projects file into WGS84 if necessary
# - Clean up temporary file
### Notes:
# This script was necessary for the Africa demo because many of the provided
# datasets did not come with a coordinate system defined.

check_projection_africa() {
	# Get gdalinfo of input:
	GDALINFO="$(gdalinfo $INPUT)"

	# Make temporary text file:
	TEMP=${1%.*}_temp.txt
	touch $TEMP
	echo $GDALINFO >> $TEMP

	# Check to see if data is projected:
	if ! grep -q 'WGS 84' $TEMP; then
		gdalwarp \
		-overwrite \
		-t_srs WGS84 \
		-r near \
		$1 $2
		if [[ $? != 0 ]]; then
			echo "gdalwarp failed in check_projection.sh  Exiting script."
			exit 1
		fi
	else
		cp $1 $2
		if [[ $? != 0 ]]; then
			echo "Copy failed in check_projection.sh  Exiting script."
			exit 1
		fi
	fi

	# Remove temporary file:
	rm $TEMP
}