#!/usr/bin/env bash

# export MINTCAST_PATH='/usr/local/bin/mintcast'
export MINTCAST_PATH='.'

source $MINTCAST_PATH/lib/helper_usage.sh
source $MINTCAST_PATH/lib/helper_parameter.sh
source $MINTCAST_PATH/lib/handle_tiff.sh
source $MINTCAST_PATH/lib/handle_tiled_tiff.sh
source $MINTCAST_PATH/lib/handle_tiff_qml.sh
source $MINTCAST_PATH/lib/handle_netcdf.sh
source $MINTCAST_PATH/lib/handle_sqlite.sh

VERSION="$(cat package.json | sed -nE 's/.+@ver.*:.*\"(.*)\".*/\1/p' | tr -d '\r')"

USAGE=""
helper_usage 

if [[ $# -lt 1 ]]; then
    echo "$USAGE"
    exit 0
fi

DATASET_TYPE="tiff"         # DATASET_TYPE, tiff, netcdf or tiled
QML_FILE=""                 # QML file path
DATASET_DIR=""              # If dataset has timeseries or tiled
DATASET_DIR_STRUCTURE=""    # If DATASET_DIR is set, set structure `{year}/{month}/{day}/*.nc` or `*.zip`
START_TIME=""               # If dataset has timeseries, start time string, like `2018 05 01`
END_TIME=""                 # Same as start time
LAYER_NAME=""               # Layer name could be a string or a json file, as input of tippecanoe
TARGET_MBTILES_PATH=""      # Production mode: path to store mbtiles files and config files
TARGET_JSON_PATH=""         # Production mode: path to store json files
TILESEVER_PROG=""           # Path of tileserver program
TILESEVER_PORT="8082"       # Used by tileserver
TILESEVER_BIND="0.0.0.0"    # Used by tileserver
DEV_MODE=YES                # Default is dev mode. Generate all files (mbtiles or json) in dist/.
NO_WEBSITE_UPDATE=NO        # Only generate tiles in dist/, no json, no restart tileserver
TILED_FILE_EXT="dem.tif"	# for tiled dataset, the suffix and extension of the files to be merged
WITH_QUALITIY_ASSESSMENT=NO # for tiled dataset, if with --with-quality-assessment, then generate like elevation.num.raster.mbtiles
DATASET_NAME="output" 		# output mbtiles name like -o elevation, output will be elevation.raster.mbtiles and elevation.vector.mbtiles
DATAFILE_PATH=""            # Single file path like tiff

OUTPUT_DIR_STRUCTURE_FOR_TIMESERIES="" # how netcdf's timeseries mbtiles are stored

# store mbtiles in a specific folder and read by website

helper_parameter $@

echo $START_TIME

if [[ -z "$START_TIME" ]]; then
	if [[ -z "$LAYER_NAME" ]]; then
		echo "Please set up -l|--layer-name which is the LAYER_NAME and also part of Layer ID"
		exit 1
	fi
else
	if [[ -z "$OUTPUT_DIR_STRUCTURE_FOR_TIMESERIES" ]]; then
		echo "Please set up -z|--output-dir-structure which is how timeseries mbtiles are stored"
		exit 1
	fi
	if [[ -z "$DATASET_DIR" ]]; then
		echo "Please set up -d|--dir which is used for traversal"
		exit 1
	fi
	
fi
	
if [[ $DATASET_TYPE == "tiff" ]]; then
	if [[ -z "$QML_FILE" ]]; then
		handle_tiff
	else
		handle_tiff_qml
	fi
elif [[ $DATASET_TYPE == "tiled" ]]; then
	handle_tiled_tiff
elif [[ $DATASET_TYPE == "netcdf" ]]; then
	handle_netcdf
else
	echo "$DATASET_TYPE is an invalid dataset type." 
	echo "Valid choices include: tiff, tiled, netcdf"
	exit 1
fi

# save raster
COL_RASTER_OR_VECTOR_TYPE="raster"
MBTILES_FILEPATH=$RASTER_MBTILES
handle_sqlite

# save vector
COL_RASTER_OR_VECTOR_TYPE="vector"
MBTILES_FILEPATH=$VECTOR_MBTILES
handle_sqlite

if [[ -z "$TARGET_JSON_PATH" ]]; then
	export TARGET_JSON_PATH="$MINTCAST_PATH/dist/json"
fi

if [[ ! -d "$TARGET_JSON_PATH" ]]; then
	mkdir -p $TARGET_JSON_PATH
fi
python3 $MINTCAST_PATH/python/macro_gen_web_json/main.py update-all 
CKAN_URL=$(python3 $MINTCAST_PATH/python/macro_upload_ckan/main.py "$TARGET_JSON_PATH/$COL_JSON_FILENAME")
echo $CKAN_URL
# update database
python3 $MINTCAST_PATH/python/macro_sqlite_curd/main.py update layer \
"ckan_url='$CKAN_URL'" \
"layerid='$COL_LAYER_ID'"
python3 $MINTCAST_PATH/python/macro_gen_web_json/main.py update-config