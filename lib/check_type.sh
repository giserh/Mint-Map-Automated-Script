#!/usr/bin/env bash
set -e

### check_type.sh
# Checks to see if a data file is encoded as Byte data.  If not, extract min
# and max values and convert data to Byte.  
# (Note: Script assumes single band raster and TIFF file type)
### Inputs: 
# 1) Data file to check, 2) Name of output file
### Outputs: 
# Data file with _byte.tif tag (converted if necessary)
### Procedure:
# - Creates a temporary text file of the data file's gdalinfo
# - Uses grep on text file to see if file is Byte type
# - If the file is not Byte, extract min and max values from gdalinfo,
# rescale values and convert to Byte using gdal_translate.
# - Clean up temporary file

# Parse arguments:
export INPUT=$1
export OUTPUT=$2

# Get gdalinfo of input:
export GDALINFO="$(gdalinfo $INPUT)"

# Make temporary text file:
export TEMP=${INPUT%.*}_temp.txt
touch $TEMP
echo $GDALINFO >> $TEMP

# Check to see if data is byte format:
if grep -q 'Type=Byte' $TEMP; then
	cp $INPUT $OUTPUT
	echo "Data is already Byte type"
else

	# Extract min and max values from GDAL info:
	tmp_min=${GDALINFO#*Minimum=}
	export MIN_VAL=${tmp_min%", Max"*}
	echo "Minimum value: $MIN_VAL"
	tmp_max=${GDALINFO#*Maximum=}
	export MAX_VAL=${tmp_max%", M"*}
	echo "Maximum value: $MAX_VAL"

	# Rescale values and convert data to Byte:
	gdal_translate \
	-ot Byte \
	-scale $MIN_VAL $MAX_VAL 0 254 \
	-a_nodata 255 \
	$INPUT \
	$OUTPUT
fi

# Remove temporary file:
rm $TEMP