 #!/usr/bin/env bash

source handle_tiff.sh

handle_netcdf(){
	SUBDATASET_STRING="$(gdalinfo $DATAFILE_PATH | sed -nE 's/SUBDATASET_.{1,2}_NAME=(.*)/\1/p' | grep -o 'N.*')"
	IFS=$'\n'
	SUBDATASETS=($SUBDATASET_STRING)
	for dataset in "${SUBDATASETS[@]}"; do
		IFS=$':'
		echo $dataset 
		name=($dataset)
		gdalwarp -t_srs EPSG:4326 "$dataset" "$MINTCAST_PATH/tmp/${name[2]}.tif"
		# gdalwarp -te 22.4 3.4 37.0 23.2 -cutline $MINTCAST_PATH/shp/ss.shp
		# gdal_translate -a_srs EPSG:3857 -tr 0.01 0.01 "$dataset" "$MINTCAST_PATH/tmp/${name[2]}.tif"
		# gdalwarp -te 22.4 3.4 37.0 23.2  -dstnodata 255 -cutline $MINTCAST_PATH/shp/ss.shp 
		# exit 0
	done
	
}

handle_netcdf 