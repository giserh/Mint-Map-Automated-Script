#!/usr/bin/env bash

source $MINTCAST_PATH/lib/proc_getnetcdf_subdataset.sh
source $MINTCAST_PATH/lib/handle_tiff.sh

handle_netcdf(){
	# python3 $MINTCAST_PATH/python/macro_traversal/main.py "/Users/liber/Documents/South_Sudan/RawData/Forcing/FLDAS_NOAH01_A_EA_D/" "{year}/{month}/*.nc" "2001 01" "2001 03"
	NETCDF_FILES_STRING=$(python3 $MINTCAST_PATH/python/macro_traversal/main.py "$DATASET_DIR" "$DATASET_DIR_STRUCTURE" "$START_TIME" "$END_TIME")
	old=$IFS
	IFS=$'\n'
	NETCDF_FILES=($NETCDF_FILES_STRING)
	SUBDATASETS_ARRAY=()
	SUBDATASET_LAYAERS_ARRAY=()
	for netcdf_file in "${NETCDF_FILES[@]}"; do
		proc_getnetcdf_subdataset "$netcdf_file"
		PARTIAL_PATH=$(python3 $MINTCAST_PATH/python/macro_path/main.py diff "$netcdf_file" "$DATASET_DIR")
		index=0
		for subset_tiff in "${SUBDATASETS_ARRAY[@]}"; do
			DATAFILE_PATH="$subset_tiff"
			LAYER_NAME="${SUBDATASET_LAYAERS_ARRAY[$index]}"
			OUT_DIR="$MINTCAST_PATH/dist/$PARTIAL_PATH"
			handle_tiff
			index=$((index+1))
		done
		rm "$MINTCAST_PATH/tmp/*subset*"
	done
	# xargs -I % proc_getnetcdf_subdataset %
	IFS=$old
}
# test
# DATASET_NAME='elevation' MINTCAST_PATH='.' DATASET_DIR='/Users/liber/Documents/South_Sudan/RawData/Forcing/FLDAS_NOAH01_A_EA_D/' DATASET_DIR_STRUCTURE='{year}/{month}/*.nc' START_TIME='2001 01' END_TIME='2001 03' ./lib/handle_netcdf.sh
# handle_netcdf