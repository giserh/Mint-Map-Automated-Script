#!/usr/bin/env bash

### handle_tiff.sh
# Complete workflow for generating raster and vector tiles from TIFFs.
### Inputs:
# 1) Input filepath, 2) Layer name, 3) Value name

### TO DO: return YES or NO at EOF
### TO DO: exit on non-zero status

# Source functions:
source check_type.sh
source check_projection.sh
source proc_clip.sh
source proc_newres.sh
source proc_tif2mbtiles.sh
source proc_gdaladdo.sh
source proc_polygonize.sh
source proc_geojson2mbtiles.sh

handle_tiff(){
	# Parse arguments:
	INPUT=$1
	LAYER_NAME=$2
	VALUE_NAME=$3

	# Hard-coded paths (passed from mintcast.sh?):
	OUT_DIR='/Volumes/BigMemory/mint-webmap/data'
	#OUT_DIR=$MINTCAST_PATH/dist
	TEMP_DIR=$OUT_DIR
	#TEMP_DIR=$MINTCAST_PATH/tmp
	SS_BOUNDARY='../shp/ss.shp'
	#SS_BOUNDARY=$MINTCAST_PATH/shp/ss.shp

	# Remove path from input:
	FILENAME=$(basename $INPUT)

	# Set names for intermediary and output files:
	BYTE_OUT=$TEMP_DIR/${FILENAME%.*}_byte.tif
	CLIP_OUT=${BYTE_OUT%.*}_clip.tif
	PROJ_OUT=${CLIP_OUT%.*}_proj.tif
	RES_OUT=${PROJ_OUT%.*}_newres.tif
	POLY_OUT=${PROJ_OUT%.*}_poly.geojson
	RASTER_MBTILES=$OUT_DIR/${INPUT%.*}_raster_tiles.mbtiles
	VECTOR_MBTILES=$OUT_DIR/${INPUT%.*}_vector_tiles.mbtiles

	# Pre-processing:
	check_type $INPUT $BYTE_OUT #Check data type/convert to byte
	proc_clip $BYTE_OUT $CLIP_OUT $SS_BOUNDARY #Clip to South Sudan boundary
	check_projection $CLIP_OUT $PROJ_OUT #Check projection/change to EPSG 3857

	# Generate raster tiles:
	proc_newres $PROJ_OUT $RES_OUT #Set resolution for raster tiles
	proc_tif2mbtiles $RES_OUT $RASTER_MBTILES #Make .mbtiles
	proc_gdaladdo $RASTER_MBTILES #Generate zoom levels
	### TO DO: read MBTiles metadata table/store to database

	# Generate vector tiles:
	proc_polygonize $PROJ_OUT $POLY_OUT $LAYER_NAME $VALUE_NAME #Make GeoJSON
	proc_geojson2mbtiles $POLY_OUT $VECTOR_MBTILES $LAYER_NAME #Make .mbtiles
	### TO DO: read MBTiles metadata table/store to database
	### TO DO: generate dataset.json file for vector tile

	### TO DO: update website's config.json

	### TO DO: copy mbtiles files to location
	#mv $RASTER_MBTILES $OUT_DIR/
	#mv $VECTOR_MBTILES $OUT_DIR/

	# Delete intermediate files:
	rm $BYTE_OUT $CLIP_OUT $PROJ_OUT $RES_OUT $POLY_OUT

}