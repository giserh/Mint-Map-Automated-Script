#!/usr/bin/env bash

### proc_newres.sh
# Sets raster tile resolution to 10x10
### Inputs: 
# 1) Input, 2) Name of output file
### Outputs: 
# Raster tiles with new resolution
### Procedure:
# - Set resolution with gdalwarp

# Set raster tile resolution:
proc_newres () {
	gdalwarp \
	-tr 10 10 \
	$1 `#Input filename`\
	$2 `#Output filename`

	if [[ $? != 0 ]]; then
		echo "gdalwarp failed in proc_newres.sh  Exiting script."
		exit 1
	fi
}