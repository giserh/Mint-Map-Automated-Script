#!/usr/bin/env bash

### proc_gdaldem.sh
# Adds color from color table to raster tiles
### Inputs: 
# 1) Input, 2) Color table, 3) Name of output
### Outputs: 
# Raster tiles with color added
### Procedure:
# - Add color with gdaldem and color table text file

# Add colors:
proc_gdaldem () {
	gdaldem \
	color-relief \
	$1 `#Input filename`\
	$2 `#Colormap filename`\
	$3 `#Output filename`\
	-alpha

	if [[ $? != 0 ]]; then
		echo "gdaldem failed in proc_gdaldem.sh  Exiting script."
		exit 1
	fi
}