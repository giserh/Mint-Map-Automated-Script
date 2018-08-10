#!/usr/bin/env bash

### proc_clip.sh
# Clips data layer to South Sudan boundary as defined by input shapefile, 
# or to a bounding box.
### Inputs: 
# 1) Data file to clip, 2) Name of output file, 3) South Sudan shapefile
### Outputs: 
# Clipped file
### Procedure:
# - Clip with gdalwarp
### Notes:
# - Only works on projected data
# - Can be used with any shapefile (does not have to be South Sudan boundary)

# Clip to South Sudan Boundary:
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
    echo "CLIP_BOUNDS_ARRAY: ${CLIP_BOUNDS_ARRAY[*]}"
    echo "NODATAFLAG: $NODATAFLAG"

    if [[ USE_SS_SHAPE != "NO" ]]; then
        echo "Using SS shapefile..."
        echo "SS_SHAPEFILE: $3"
        echo "gdalwarp -overwrite -te ${CLIP_BOUNDS_ARRAY[*]} $NODATAFLAG --config GDALWARP_IGNORE_BAD_CUTLINE YES -cutline $3 $1 $2"
        #echo "gdalwarp -overwrite -te ${CLIP_BOUNDS_ARRAY[*]} $NODATAFLAG --config GDALWARP_IGNORE_BAD_CUTLINE YES -cutline $3 $1 $2"
        eval "gdalwarp -overwrite -te ${CLIP_BOUNDS_ARRAY[*]} $NODATAFLAG --config GDALWARP_IGNORE_BAD_CUTLINE YES -cutline $3 $1 $2"

    else
        echo "Not using SS shapefile..."
        # echo "gdalwarp -overwrite -te ${CLIP_BOUNDS_ARRAY[*]} $NODATAFLAG $1 $2"
        # gdalwarp -overwrite -te ${CLIP_BOUNDS_ARRAY[0]} ${CLIP_BOUNDS_ARRAY[1]} ${CLIP_BOUNDS_ARRAY[2]} ${CLIP_BOUNDS_ARRAY[3]} $NODATAFLAG $1 $2
        # echo $(which gdalwarp)
        eval "gdalwarp -overwrite --config GDALWARP_IGNORE_BAD_CUTLINE YES $NODATAFLAG -te ${CLIP_BOUNDS_ARRAY[*]} $1 $2"
    fi
        
    if [[ $? != 0 ]]; then
        echo "gdalwarp failed in proc_clip.sh Exiting script."
        exit 1
    fi
}