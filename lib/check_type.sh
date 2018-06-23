#!/usr/bin/env bash

### check_type.sh
# Checks to see if a data file is encoded as Byte data.  If not, extract min
# and max values and convert data to Byte.  
# (Note: Script assumes single band raster and TIFF file type)
### Inputs: 
# 1) Data file to check, 2) Name of output file
### Outputs: 
# Data file with _byte.tif tag (converted if necessary)
### Procedure:
# - Uses grep on gdalinfo to see if file is Byte type
# - If the file is not Byte, extract min and max values from gdalinfo,
# rescale values and convert to Byte using gdal_translate.

check_type () {
	# Make temporary stats file:
	STATS=$1 
	#${1%.*}_stats.tif
	# gdal_translate -stats $1 $STATS

	# Get gdalinfo of stats:
	GDALINFO="$(gdalinfo $STATS)"
	IS_BYTE=$(echo $GDALINFO | grep 'Type=Byte')
	IS_INT=$(echo $GDALINFO | grep 'Type=Int16')
	IS_FLOAT=$(echo $GDALINFO | grep 'Type=Float32')

	if [[ ! -z "$IS_BYTE" ]]; then
		# mv $STATS $2 # Set temporary stats file as output
		echo "Data is already Byte type"
		NODATAFLAG='-dstnodata 255 '
	elif [[ ! -z "$IS_FLOAT" ]]; then
		NODATAFLAG='-dstnodata -9999 '
		POLYGOINZE_FLOAT_FLAG="-float "
	elif [[ ! -z "$IS_INT" ]]; then
		NODATAFLAG='-dstnodata 32222 '
	else
		NODATAFLAG='-dstnodata 32222 '
		#statements
		# Extract min and max values from GDAL info:
		# tmp_min=${GDALINFO#*Minimum=}
		# MIN_VAL=${tmp_min%", Max"*}
		# echo "Minimum value: $MIN_VAL"
		# tmp_max=${GDALINFO#*Maximum=}
		# MAX_VAL=${tmp_max%", M"*}
		# echo "Maximum value: $MAX_VAL"

		# Rescale values and convert data to Byte:

		# no need to convert to byte  by libo
		
		# gdal_translate \
		# -ot Byte \
		# -scale $MIN_VAL $MAX_VAL 0 254 \
		# -a_nodata 255 \
		# $1 \
		# $2

		# Remove temporary stats file:
		# rm $STATS
	fi
}