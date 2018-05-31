#!/usr/bin/env bash
set -e

### generate_mbtiles_from_tiled_tif.sh
# Complete workflow for generating MBTiles from tiled TIFFs.
### Inputs: 
# 1) Tile directory, 2) Output directory, 
# 3) Path to South Sudan boundary shapefile, 
# 4) Desired filename (w/o extension),
# 5) File extension (and suffix) to check before unzipping
# 6) Layer name, 7) Value name
### Outputs: 
# MBTiles ready to be displayed on website.  Creates intermediate files at
# each step of the process.
### Procedure:
# -Parse arguments, clean directory and filenames, set names for ouput files
# -Check if tiles are zipped, unzip if necessary
# -Merge tiles
# -Check data type, convert to Byte if necessary
# -Clip to South Sudan boundary

# Parse arguments:
export TILE_DIR=$1 #Directory containing tiles
export OUT_DIR=$2 #Output directory
export SOUTH_SUDAN=$3 #Path to South Sudan boundary shapefile
export FILENAME=$4 #Desired filename (without extension) for output
export FILE_EXT=$5 #File extension (and suffix) to check before unzipping
export LAYER_NAME=$6 #Layer name (displayed on map)
export VALUE_NAME=$7 #Value name (displayed on map)

# Clean directory and filenames:
export CLEANED_TILE_DIR=${TILE_DIR%/*} #Remove trailing / from tile directory
echo "CLEANED TILE DIR: $CLEANED_TILE_DIR"
export CLEANED_OUT_DIR=${OUT_DIR%/*} #Remove trailing / from output directory
echo "CLEANED OUT DIR: $CLEANED_OUT_DIR"
export CLEANED_FILENAME=${FILENAME%.*} #Remove extension from output filename
echo "CLEANED FILENAME: $CLEANED_FILENAME"

# Set names for intermediary and output files:
export MERGE_OUT=$CLEANED_OUT_DIR/$CLEANED_FILENAME.tif #Merged tiles
export BYTE_OUT=${MERGE_OUT%.*}_byte.tif
export CLIP_OUT=${BYTE_OUT%.*}_clip.tif #Clipped
export PROJ_OUT=${CLIP_OUT%.*}_proj.tif #Projected
export POLY_OUT=${PROJ_OUT%.*}_poly.geojson #Polygonized
export RETILE_OUT=${POLY_OUT%.*}.mbtiles #Converted to MBTiles

# Check to see if data is zipped, unzip if necessary:
./check_zipped_tif.sh $CLEANED_TILE_DIR $FILE_EXT


echo $CLEANED_TILE_DIR/*$FILE_EXT

# Merge tiles:
gdal_merge.py \
-o $MERGE_OUT \
$CLEANED_TILE_DIR/*$FILE_EXT

# Check data type, convert to Byte, if necessary:
./check_type.sh $MERGE_OUT $BYTE_OUT

# Check projection, project to EPSG:3857, if necessary:
./check_projection.sh $CLIP_OUT $PROJ_OUT

# Polygonize data and add layer/value names:
./polygonize.sh $PROJ_OUT $POLY_OUT $LAYER_NAME $VALUE_NAME

# Convert polygonized GeoJSON to MBTiles:
./geojson2mbtiles.sh $POLY_OUT $RETILE_OUT $LAYER_NAME


