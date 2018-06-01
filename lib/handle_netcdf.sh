 #!/usr/bin/env bash

handle_netcdf(){
	SUBDATASET_STRING="$(gdalinfo $DATAFILE_PATH | sed -nE 's/SUBDATASET_.{1,2}_NAME=(.*)/\1/p' | grep -o 'N.*')"
	IFS=$'\n'
	SUBDATASETS=($SUBDATASET_STRING)
	for dataset in "${SUBDATASETS[@]}"; do
		echo $dataset 
		
	done
	
}

handle_netcdf 