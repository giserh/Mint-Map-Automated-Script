#!/usr/bin/env bash

source $MINTCAST_PATH/lib/proc_getnetcdf_subdataset.sh
#source $MINTCAST_PATH/lib/handle_tiff.sh
source $MINTCAST_PATH/lib/handle_postgresql.sh

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
	OUT_DIR="$MINTCAST_PATH/dist/$PARTIAL_PATH"
	index=0
	if [[ ! -z $SINGLE_SUBSET_PATH ]]; then
		DATAFILE_PATH=$SINGLE_SUBSET_PATH
		LAYER_NAME=$SINGLE_SUBSET_LAYER_NAME
		LAYER_ID_SUFFIX=$(python3 $MINTCAST_PATH/python/macro_string/main.py path_to_suffix $PARTIAL_PATH)
		handle_tiff
		MBTILES_ARRAY=($RASTER_MBTILES $VECTOR_MBTILES)
		for ((i=0; i<${#MBTILES_ARRAY[@]}; i++)); do
			MBTILES_FILEPATH=${MBTILES_ARRAY[i]}
			echo "MBTILES_FILEPATH: $MBTILES_FILEPATH"
			if [[ ! -z $MBTILES_FILEPATH ]]; then
				if [[ $MBTILES_FILEPATH = *raster* ]]; then
					COL_RASTER_OR_VECTOR_TYPE="raster"
				elif [[ $MBTILES_FILEPATH = *vector* ]]; then
					COL_RASTER_OR_VECTOR_TYPE="vector"
				fi
				#echo "Handling SQLite..."
				#handle_sqlite
				echo "Handling PostgreSQL"
				handle_postgresql
				echo "Generating web JSON..."
				python3 $MINTCAST_PATH/python/macro_gen_web_json/main.py update-all 
				#echo "Getting CKAN_URL"
				#CKAN_URL=$(python3 $MINTCAST_PATH/python/macro_upload_ckan/main.py "get" "$TARGET_JSON_PATH/$COL_JSON_FILENAME")
				echo "COL_JSON_FILENAME: $COL_JSON_FILENAME"
				CKAN_URL="blahblahblah.com"
				echo "CKAN_URL: $CKAN_URL"
				# update database
				echo "Updating database..."
				echo "COL_LAYER_ID: $COL_LAYER_ID"
				echo "LAYER_ID_SUFFIX: $LAYER_ID_SUFFIX"
				#python3 $MINTCAST_PATH/python/macro_sqlite_curd/main.py update layer \
				python3 $MINTCAST_PATH/python/macro_postgres_curd/main.py update layer \
				"layerid='$COL_LAYER_ID'"
				#"ckan_url='$CKAN_URL'" \
				
				echo "Updating config..."
				python3 $MINTCAST_PATH/python/macro_gen_web_json/main.py update-config
			fi
		done
	else
		for subset_tiff in "${SUBDATASETS_ARRAY[@]}"; do
			DATAFILE_PATH="$subset_tiff"
			LAYER_NAME="${SUBDATASET_LAYERS_ARRAY[$index]}"
			LAYER_ID_SUFFIX=$(python3 $MINTCAST_PATH/python/macro_string/main.py path_to_suffix $PARTIAL_PATH)
			handle_tiff
			echo "FINISHED HANDLE TIFF"
			echo "RASTER_MBTILES: $RASTER_MBTILES"
			echo "VECTOR_MBTILES: $VECTOR_MBTILES"
			MBTILES_ARRAY=($RASTER_MBTILES $VECTOR_MBTILES)
			echo "MBTILES_ARRAY: ${MBTILES_ARRAY[@]}"
			echo "MBTILES_ARRAY[0]: ${MBTILES_ARRAY[0]}"
			echo "MBTILES_ARRAY[1]: ${MBTILES_ARRAY[1]}"
			for ((i=0; i<${#MBTILES_ARRAY[@]}; i++)); do
				MBTILES_FILEPATH=${MBTILES_ARRAY[i]}
				echo "MBTILES_FILEPATH: $MBTILES_FILEPATH"
				if [[ ! -z $MBTILES_FILEPATH ]]; then
					if [[ $MBTILES_FILEPATH = *raster* ]]; then
						COL_RASTER_OR_VECTOR_TYPE="raster"
					elif [[ $MBTILES_FILEPATH = *vector* ]]; then
						COL_RASTER_OR_VECTOR_TYPE="vector"
					fi
					#echo "Handling SQLite..."
					#handle_sqlite
					echo "Handling PostgreSQL"
					handle_postgresql
					echo "Generating web JSON..."
					python3 $MINTCAST_PATH/python/macro_gen_web_json/main.py update-all 
					#echo "Getting CKAN_URL"
					#CKAN_URL=$(python3 $MINTCAST_PATH/python/macro_upload_ckan/main.py "get" "$TARGET_JSON_PATH/$COL_JSON_FILENAME")
					echo "COL_JSON_FILENAME: $COL_JSON_FILENAME"
					CKAN_URL="blahblahblah.com"
					echo "CKAN_URL: $CKAN_URL"
					# update database
					echo "Updating database..."
					echo "COL_LAYER_ID: $COL_LAYER_ID"
					echo "LAYER_ID_SUFFIX: $LAYER_ID_SUFFIX"
					#python3 $MINTCAST_PATH/python/macro_sqlite_curd/main.py update layer \
					python3 $MINTCAST_PATH/python/macro_postgres_curd/main.py update layer \
					"layerid='$COL_LAYER_ID'"
					#"ckan_url='$CKAN_URL'" \
					
					echo "Updating config..."
					python3 $MINTCAST_PATH/python/macro_gen_web_json/main.py update-config
				fi
			done
			index=$((index+1))
		done
	fi	
	#rm $MINTCAST_PATH/tmp/*subset*

	IFS=$old
}	
