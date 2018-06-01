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
# - Clip with gdalwarp

# Clip to South Sudan Boundary:
proc_clip () {
	gdalwarp \
	-te 22.4 3.4 37.0 23.2 \
	-dstnodata 255 \
	-cutline $3 `#South Sudan boundary shapefile` \
	$1 `#Input filename`\
	$2 `#Output filename`
}