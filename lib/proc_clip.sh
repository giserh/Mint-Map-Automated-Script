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
	echo "Checking for existing file..."
	if [[ -f "$2" ]]; then
		rm -f "$2"
	fi
	echo "Done."

	# check if there are commas in input bounds, replace with spaces, convert to array
	echo "Checking boundary string for commas..."
	if [[ $CLIP_BOUNDS = *","* ]]; then
		echo "Commas found in boundary string."
		CLIP_BOUNDS_ARRAY=`(echo $CLIP_BOUNDS | tr , " ")`
		echo "Commas removed."	
	else
		echo "No commas found."
		CLIP_BOUNDS_ARRAY=(`echo $CLIP_BOUNDS`)
	fi
	echo "Boundary string converted to array."
	echo "CLIP_BOUNDS_ARRAY: $CLIP_BOUNDS_ARRAY"
	echo "NODATAFLAG: $NODATAFLAG"

	if [[ USE_SS_SHAPE == "YES" ]]; then
		echo "Using SS shapefile..."
		echo "gdalwarp -overwrite -te ${CLIP_BOUNDS_ARRAY[*]} $NODATAFLAG --config GDALWARP_IGNORE_BAD_CUTLINE YES -cutline $3 $1 $2"
		gdalwarp \
		-overwrite \
		-te ${CLIP_BOUNDS_ARRAY[*]} \
		$NODATAFLAG \
		--config GDALWARP_IGNORE_BAD_CUTLINE YES \
		-cutline $3 \
		$1 \
		$2
	else
		echo "Not using SS shapefile..."
		echo "gdalwarp -overwrite -te ${CLIP_BOUNDS_ARRAY[*]} $NODATAFLAG --config GDALWARP_IGNORE_BAD_CUTLINE YES $1 $2"
		gdalwarp \
		-overwrite \
		-te ${CLIP_BOUNDS_ARRAY[*]} \
		$NODATAFLAG \
		--config GDALWARP_IGNORE_BAD_CUTLINE YES \
		$1 \
		$2
	fi
		
	if [[ $? != 0 ]]; then
		echo "gdalwarp failed in proc_clip.sh Exiting script."
		exit 1
	fi
}