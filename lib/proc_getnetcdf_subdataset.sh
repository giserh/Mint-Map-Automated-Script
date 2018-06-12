 #!/usr/bin/env bash

proc_getnetcdf_subdataset(){
	SUBDATASETS_ARRAY=()
	SUBDATASET_LAYAERS_ARRAY=()
	NETCDF_FILEPATH=$1
	SUBDATASET_STRING="$(gdalinfo $NETCDF_FILEPATH | sed -nE 's/SUBDATASET_.{1,2}_NAME=(.*)/\1/p' | grep -o 'N.*')"
	IFS=$'\n'
	SUBDATASETS=($SUBDATASET_STRING)
	old=$IFS
	for dataset in "${SUBDATASETS[@]}"; do
		IFS=$':'
		name=($dataset)
		if [[ ${name[2]} != 'time_bnds' ]]; then
			gdalwarp -t_srs EPSG:4326 "$dataset" "$MINTCAST_PATH/tmp/$DATASET_NAME.subset.${name[2]}.tif"
			# gdalwarp -t_srs EPSG:3857 "$dataset" "$MINTCAST_PATH/tmp/$DATASET_NAME.subset.${name[2]}.tif"
			SUBDATASETS_ARRAY+=("$MINTCAST_PATH/tmp/$DATASET_NAME.subset.${name[2]}.tif")
			SUBDATASET_LAYAERS_ARRAY+=(${name[2]})
		fi
		
		# gdalwarp -te 22.4 3.4 37.0 23.2 -cutline $MINTCAST_PATH/shp/ss.shp
		# gdal_translate -a_srs EPSG:3857 -tr 0.01 0.01 "$dataset" "$MINTCAST_PATH/tmp/${name[2]}.tif"
		# gdalwarp -te 22.4 3.4 37.0 23.2  -dstnodata 255 -cutline $MINTCAST_PATH/shp/ss.shp 
		# exit 0
	done
	IFS=$old
}
 