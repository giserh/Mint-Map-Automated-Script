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

	# check if there are commas in input bounds, replace with spaces, convert to array
	if [[ $CLIP_BOUNDS = *","* ]]; then
		CLIP_BOUNDS_ARRAY=`(echo $CLIP_BOUNDS | tr , " ")`	
	else
		CLIP_BOUNDS_ARRAY=(`echo ${CLIP_BOUNDS}`)
	fi

	if [[ USE_SS_SHAPE == "YES" ]]; then
		gdalwarp \
		-overwrite \
		-te $CLIP_BOUNDS_ARRAY $NODATAFLAG\
		--config GDALWARP_IGNORE_BAD_CUTLINE YES \
		-cutline $3 `#South Sudan boundary shapefile` \
		$1 `#Input filename`\
		$2 `#Output filename`
	else
		gdalwarp \
		-overwrite \
		-te $CLIP_BOUNDS_ARRAY $NODATAFLAG\
		--config GDALWARP_IGNORE_BAD_CUTLINE YES \
		$1 `#Input filename`\
		$2 `#Output filename`
	fi
		
	if [[ $? != 0 ]]; then
		echo "gdalwarp failed in proc_clip.sh Exiting script."
		exit 1
	fi
}