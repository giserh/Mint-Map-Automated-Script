#!/usr/bin/env bash
source lib/helper_usage.sh
source lib/helper_parameter.sh

VERSION="$(cat package.json | sed -nE 's/.+@ver.*:.*\"(.*)\".*/\1/p' | tr -d '\r')"

USAGE=""
helper_usage 

if [[ $# -lt 1 ]]; then
    echo "$USAGE"
    exit 0
fi


DATASET_TYPE="tiff"         # DATASET_TYPE, tiff, nc or tiled
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

helper_parameter $@

