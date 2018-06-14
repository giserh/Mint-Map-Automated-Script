#!/usr/bin/env bash

### proc_clip.sh
# Clips data layer to South Sudan boundary as defined by input shapefile.
# (Note: Only works on unprojected data)
### Inputs: 
# 1) Data file to clip, 2) Name of output file, 3) South Sudan shapefile
### Outputs: 
# Clipped file
### Procedure:
# - Clip with gdalwarp

# Clip to South Sudan Boundary:
# 	-dstnodata 255 \
proc_clip () {
	# in case there is one
	if [[ -f "$2" ]]; then
		rm -f "$2"
	fi

	gdalwarp \
	-overwrite \
	-te 22.4 3.4 37.0 23.2 \
	--config GDALWARP_IGNORE_BAD_CUTLINE YES \
	-cutline $3 `#South Sudan boundary shapefile` \
	$1 `#Input filename`\
	$2 `#Output filename`
	
	if [[ $? != 0 ]]; then
		echo "gdalwarp failed in proc_clip.sh Exiting script."
		exit 1
	fi
}