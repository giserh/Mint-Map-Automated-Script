#!/usr/bin/env bash

### handle_tiled_tif.sh
# Complete workflow for generating raster and vector tiles from tiled TIFFs.
### Inputs: 
# 1) Tile directory, 2) File extension (and suffix) to check before unzipping
# 3) Desired filename (w/o extension), 4) Layer name, 5) Value name
### Outputs: 
# MBTiles ready to be displayed on website.  Creates intermediate files at
# each step of the process.

### TO DO: return YES or NO at EOF
### TO DO: exit on non-zero status

# Source functions:
source check_zipped.sh
source handle_tiff.sh
#source handle_tiff_qml.sh

handle_tiled_tif(){
	# Parse arguments:
	TILE_DIR=$1 #Directory containing tiles
	FILE_EXT=$2 #File extension (and suffix) to check before unzipping
	FILENAME=$3 #Desired filename (without extension) for output
	LAYER_NAME=$4 #Layer name (displayed on map)
	VALUE_NAME=$5 #Value name (displayed on map)
	QML_FILE="" #Will be passed from mintcast.sh (remove this later)

	# Hard-coded paths (passed from mintcast.sh?):
	OUT_DIR='/Volumes/BigMemory/mint-webmap/data'
	#OUT_DIR=$MINTCAST_PATH/dist
	TEMP_DIR=$OUT_DIR
	#TEMP_DIR=$MINTCAST_PATH/tmp

	# Clean directory and filenames:
	if [ "${TILE_DIR: -1}" == "/" ]; then
		CLEANED_TILE_DIR=${TILE_DIR%/*} #Remove trailing / from tile directory
	else
		CLEANED_TILE_DIR=$TILE_DIR
	fi
	CLEANED_FILENAME=${FILENAME%.*} #Remove extension from output filename

	# Set names for intermediate and output files:
	MERGE_OUT=$TEMP_DIR/$CLEANED_FILENAME.tif #Merged tiles

	# Check to see if data is zipped, unzip if necessary:
	check_zipped $CLEANED_TILE_DIR $FILE_EXT

	# Merge tiles:
	gdal_merge.py \
	-o $MERGE_OUT \
	$CLEANED_TILE_DIR/*$FILE_EXT

	# Choose and execute routine (TIFF or TIFF w/ QML):
	if [ "$QML_FILE" == "" ]; then
		handle_tiff $MERGE_OUT $LAYER_NAME $VALUE_NAME
	else
		#handle_tiff_qml $MERGE_OUT $LAYER_NAME $VALUE $QML_FILE
	fi

	# Delete intermediate files:
	rm $MERGE_OUT
}