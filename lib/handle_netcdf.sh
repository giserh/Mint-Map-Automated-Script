#!/usr/bin/env bash

source $MINTCAST_PATH/lib/proc_getnetcdf_subdataset.sh
source $MINTCAST_PATH/lib/handle_tiff.sh

handle_netcdf(){
	# python3 $MINTCAST_PATH/python/macro_traversal/main.py "/Users/liber/Documents/South_Sudan/RawData/Forcing/FLDAS_NOAH01_A_EA_D/" "{year}/{month}/*.nc" "2001 01" "2001 03"
	NETCDF_FILES_STRING=$(python3 $MINTCAST_PATH/python/macro_traversal/main.py "$DATASET_DIR/" "$DATASET_DIR_STRUCTURE" "$START_TIME" "$END_TIME")
	
    # printf "%s\n" "$NETCDF_FILES_STRING" | {
    # 	while IFS=$'\n' read -r line_data; do
    #         NETCDF_FILES+=("$line_data")
    # 	done
    # }
	IFS=$'\n'
	NETCDF_FILES=($NETCDF_FILES_STRING)
	SUBDATASETS_ARRAY=()
	SUBDATASET_LAYERS_ARRAY=()
	for netcdf_file in "${NETCDF_FILES[@]}"; do
		# echo $netcdf_file
		proc_getnetcdf_subdataset "$netcdf_file"
		PARTIAL_PATH=$(python3 $MINTCAST_PATH/python/macro_path/main.py diff "$netcdf_file" "$DATASET_DIR")
		echo $PARTIAL_PATH
		let index=0
		for subset_tiff in "${SUBDATASETS_ARRAY[@]}"; do
			echo $subset_tiff
			DATAFILE_PATH="$subset_tiff"
			LAYER_NAME="${SUBDATASET_LAYERS_ARRAY[$index]}"
			OUT_DIR="$MINTCAST_PATH/dist/$PARTIAL_PATH"
			LAYER_ID_SUFFIX=$(python3 $MINTCAST_PATH/python/macro_string/main.py path_to_suffix $PARTIAL_PATH)
			handle_tiff
			index=$((index+1))
		done

		rm "$MINTCAST_PATH/tmp/*subset*"
	done
	# xargs -I % proc_getnetcdf_subdataset %
}
# test
# DATASET_NAME='elevation' MINTCAST_PATH='.' DATASET_DIR='/Users/liber/Documents/South_Sudan/RawData/Forcing/FLDAS_NOAH01_A_EA_D/' DATASET_DIR_STRUCTURE='{year}/{month}/*.nc' START_TIME='2001 01' END_TIME='2001 03' ./lib/handle_netcdf.sh
# handle_netcdf