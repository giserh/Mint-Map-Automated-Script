#!/usr/bin/env bash

source $MINTCAST_PATH/lib/proc_getnetcdf_subdataset.sh
source $MINTCAST_PATH/lib/handle_tiff.sh

handle_netcdf_single(){
	old=$IFS
	IFS=$'\n'
	SUBDATASETS_ARRAY=()
	SUBDATASET_LAYERS_ARRAY=()
	NETCDF_FILE=$DATAFILE_PATH
	proc_getnetcdf_subdataset "$NETCDF_FILE"
	#echo "NETCDF_FILE: $NETCDF_FILE"
	#echo "DATASET_DIR: $DATASET_DIR"
	PARTIAL_PATH=$(python3 $MINTCAST_PATH/python/macro_path/main.py diff "$NETCDF_FILE" "$DATASET_DIR")
	index=0
	for subset_tiff in "${SUBDATASETS_ARRAY[@]}"; do
		DATAFILE_PATH="$subset_tiff"
		LAYER_NAME="${SUBDATASET_LAYERS_ARRAY[$index]}"
		OUT_DIR="$MINTCAST_PATH/dist/$PARTIAL_PATH"
		LAYER_ID_SUFFIX=$(python3 $MINTCAST_PATH/python/macro_string/main.py path_to_suffix $PARTIAL_PATH)
		handle_tiff
		index=$((index+1))
	done

	MBTILES_DIR=$(dirname "${RASTER_MBTILES}")
	echo "MBTILES_DIR: $MBTILES_DIR"
	MBTILES_ARRAY=($MBTILES_DIR/*.mbtiles)
	for ((i=0; i<${#MBTILES_ARRAY[@]}; i++)); do
		MBTILES_FILEPATH=${MBTILES_ARRAY[i]}
		echo "MBTILES_FILEPATH: $MBTILES_FILEPATH"
		if [[ $MBTILES_FILEPATH = *raster* ]]; then
			COL_RASTER_OR_VECTOR_TYPE="raster"
		elif [[ $MBTILES_FILEPATH = *vector* ]]; then
			COL_RASTER_OR_VECTOR_TYPE="vector"
		fi
		echo "Handling SQLite..."
		handle_sqlite
		echo "Generating web JSON..."
		python3 $MINTCAST_PATH/python/macro_gen_web_json/main.py update-all 
		echo "Getting CKAN_URL"
		CKAN_URL=$(python3 $MINTCAST_PATH/python/macro_upload_ckan/main.py "get" "$TARGET_JSON_PATH/$COL_JSON_FILENAME")
		echo "CKAN_URL: $CKAN_URL"
		# update database
		echo "Updating database..."
		python3 $MINTCAST_PATH/python/macro_sqlite_curd/main.py update layer \
		"ckan_url='$CKAN_URL'" \
		"layerid='$COL_LAYER_ID'"
		echo "Updating config..."
		python3 $MINTCAST_PATH/python/macro_gen_web_json/main.py update-config
	done	
	#rm $MINTCAST_PATH/tmp/*subset*

	IFS=$old
}	
