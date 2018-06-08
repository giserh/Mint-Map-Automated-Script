#!/usr/bin/env bash

### handle_tiff_qml.sh
# Complete workflow for generating raster and vector tiles from TIFFs with QML.
### Inputs:
# 1) Input filepath, 2) Layer name

### TO DO: return YES or NO at EOF (can just use #?)
### TO DO: exit on non-zero status (using #?)
### TO DO: add mintcast path
### TO DO: add error handling (using #?)
### TO DO: change inputs to names from positional to names from mintcast.sh

# Source functions:
source $MINTCAST_PATH/lib/check_projection.sh
source $MINTCAST_PATH/lib/proc_clip.sh
source $MINTCAST_PATH/lib/proc_newres.sh
source $MINTCAST_PATH/lib/proc_tif2mbtiles.sh
source $MINTCAST_PATH/lib/proc_gdaladdo.sh
source $MINTCAST_PATH/lib/proc_polygonize.sh
source $MINTCAST_PATH/lib/proc_geojson2mbtiles.sh

handle_tiff(){
	# Parse arguments from mintcast.sh:
	INPUT=$DATAFILE_PATH
	LAYER_NAME=$LAYER_NAME
	QML_FILE=$QML_FILE

	# Hard-coded paths (passed from mintcast.sh?):
	OUT_DIR="$MINTCAST_PATH/dist"
	if [[ ! -d "$OUT_DIR" ]]; then
		mkdir -p "$OUT_DIR"
	fi
	if [[ $DEV_MODE != 'NO' ]]; then
		OUT_DIR=$TARGET_MBTILES_PATH
	fi
	TEMP_DIR=$OUT_DIR
	SS_BOUNDARY="$MINTCAST_PATH/shp/ss.shp"
	QML_EXTRACT_PATH="$MINTCAST_PATH/python/macro_extract_colors/main.py"

	# Remove path from inpust:
	FILENAME=$(basename $INPUT)

	# Set names for intermediary and output files:
	CLIP_OUT=$TEMP_DIR/${FILENAME%.*}_clip.tif
	COLOR_TABLE=$TEMP_DIR/${FILENAME%.*}_color.txt
	PROJ_OUT=${CLIP_OUT%.*}_proj.tif
	RES_OUT=${PROJ_OUT%.*}_newres.tif
	COLOR_OUT=${RES_OUT%.*}_color.tif
	POLY_OUT=${PROJ_OUT%.*}_poly.geojson
	RASTER_MBTILES=$OUT_DIR/${FILENAME%.*}.raster.mbtiles
	VECTOR_MBTILES=$OUT_DIR/${FIlENAME%.*}.vector.mbtiles

	# Pre-processing:
	#check_type $INPUT $BYTE_OUT #Check data type/convert to byte
	proc_clip $INPUT $CLIP_OUT $SS_BOUNDARY #Clip to South Sudan boundary
	check_projection $CLIP_OUT $PROJ_OUT #Check projection/change to EPSG 3857

	# Generate raster tiles:
	proc_newres $PROJ_OUT $RES_OUT #Set resolution for raster tiles
	python $QML_EXTRACT_PATH $QML_FILE $COLOR_TABLE #Make colortable
	proc_gdaldem $RES_OUT $COLOR_TABLE $COLOR_OUT #Add colors
	proc_tif2mbtiles $COLOR_OUT $RASTER_MBTILES #Make .mbtiles
	proc_gdaladdo $RASTER_MBTILES #Generate zoom levels
	### TO DO: read MBTiles metadata table/store to database

	# Generate vector tiles:
	proc_polygonize $PROJ_OUT $POLY_OUT $LAYER_NAME #Make GeoJSON
	proc_geojson2mbtiles $POLY_OUT $VECTOR_MBTILES $LAYER_NAME #Make .mbtiles
	### TO DO: read MBTiles metadata table/store to database
	### TO DO: generate dataset.json file for vector tile

	### TO DO: update website's config.json

	### TO DO: copy mbtiles files to location
	#scp $RASTER_MBTILES $OUT_DIR/
	#scp $VECTOR_MBTILES $OUT_DIR/

	# Delete intermediate files:
	rm $BYTE_OUT $CLIP_OUT $PROJ_OUT $RES_OUT $COLOR_OUT $POLY_OUT

}