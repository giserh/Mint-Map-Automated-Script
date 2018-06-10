#!/usr/bin/env bash

### proc_gdaladdo.sh
# Generates zoom levels for raster tiles
### Inputs: 
# 1) Input
### Outputs: 
# Adds zoom levels to input
### Procedure:
# - Set resolution with gdalwarp

# Generate zoom levels:
proc_gdaladdo () {
	gdaladdo \
	-r bilinear \
	$1 `#Input filename` \
	2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536
	
	if [[ $? != 0 ]]; then
		echo "gdaladdo failed in proc_gdaladdo.sh  Exiting script."
		exit 1
	fi


}