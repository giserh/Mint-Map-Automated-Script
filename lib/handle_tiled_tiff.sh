#!/usr/bin/env bash

### handle_tiled_tif.sh
# Complete workflow for generating raster and vector tiles from tiled TIFFs.
### Inputs: 
# 1) Tile directory, 2) File extension (and suffix) to check before unzipping
# 3) Desired filename (w/o extension), 4) Layer name
### Outputs: 
# MBTiles ready to be displayed on website.  Creates intermediate files at
# each step of the process.

### TO DO: return YES or NO at EOF
### TO DO: exit on non-zero status

# Source functions:
source $MINTCAST_PATH/lib/check_zipped.sh
source $MINTCAST_PATH/lib/handle_tiff.sh
#source handle_tiff_qml.sh

handle_tiled_tiff(){
	# Parse arguments from mintcast.sh:
	TILE_DIR=$DATASET_DIR #Directory containing tiles
	echo "TILE DIR: $DATASET_DIR"
	FILENAME=$DATASET_NAME #Desired filename (without extension) for output
	echo "FILENAME: $DATASET_NAME"
	LAYER_NAME=$LAYER_NAME #Layer name (displayed on map)
	echo "LAYER: $LAYER_NAME"
	QML_FILE=$QML_FILE #Will be passed from mintcast.sh (remove this later)
	echo "QML_FIlE: $QML_FILE"

	echo "MINTCAST_PATH: $MINTCAST_PATH"
	# Hard-coded paths (passed from mintcast.sh?):
	OUT_DIR="$MINTCAST_PATH/dist"
	echo "OUT_DIR: $OUT_DIR"
	if [[ ! -d "$OUT_DIR" ]]; then
		mkdir -p "$OUT_DIR"
	fi
	if [[ $DEV_MODE != 'YES' ]]; then
		echo "TARGET_MBTILES_PATH: $TARGET_MBTILES_PATH"
		OUT_DIR=$TARGET_MBTILES_PATH
	fi	#OUT_DIR=$MINTCAST_PATH/dist
	TEMP_DIR=$OUT_DIR
	echo "TEMP_DIR: $TEMP_DIR"

	if [[ $WITH_QUALITY_ASSESSMENT != 'NO' ]]; then
		FILE_EXT='num.tif'
	else
		FILE_EXT=$TILED_FILE_EXT
		echo "FILE_EXT: $TILED_FILE_EXT"
	fi


	# Clean directory and filenames:
	if [ "${TILE_DIR: -1}" == "/" ]; then
		CLEANED_TILE_DIR=${TILE_DIR%/*} #Remove trailing / from tile directory
	else
		CLEANED_TILE_DIR=$TILE_DIR
	fi
	CLEANED_FILENAME=${FILENAME%.*} #Remove extension from output filename
	echo "CLEANED_FILENAME: $CLEANED_FILENAME"

	# Set names for intermediate and output files:
	MERGE_OUT=$TEMP_DIR/$CLEANED_FILENAME.tif #Merged tiles
	echo "MERGE OUT: $MERGE_OUT"

	# Check to see if data is zipped, unzip if necessary:
	check_zipped $CLEANED_TILE_DIR $FILE_EXT

	# Merge tiles:
	echo "gdal_merge.py -o $MERGE_OUT $CLEANED_TILE_DIR/*$FILE_EXT DATAFILE_PATH=$MERGE_OUT"
	gdal_merge.py \
	-o $MERGE_OUT \
	$CLEANED_TILE_DIR/*$FILE_EXT
	DATAFILE_PATH=$MERGE_OUT
	echo "DATAFILE_PATH: $DATAFILE_PATH"

	# Choose and execute routine (TIFF or TIFF w/ QML):
	if [ "$QML_FILE" == "" ]; then
		handle_tiff
	else
		handle_tiff_qml
		echo $QML_FILE #placeholder
	fi

	# Delete intermediate files:
	#rm $MERGE_OUT
}