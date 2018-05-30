#!/bin/bash

#Checks to see if a directory of tiled TIFF files is zipped and needs to be unzipped.
#Inputs: Directory of TIFF tile files
#Outputs: Unzips files into directory (if necessary)
#Procedure:
#-Check if there are TIFF files in the directory aleady
#-If not, unzips zip files

# Parse arguments:
export INPUT_DIR=$1 #Directory of tiles to be checked
export FILE_SUFFIX=$2 #extension (and suffix) of files to merge (e.g. dem.tif)

# Clean input directory name:
export CLEANED_DIR=${INPUT_DIR%/*}

#Check if there are unzipped files in the directory, unzip them if not
if ! [ -n "($ls -A $CLEANED_DIR/*$FILE_SUFFIX 2>/dev/null)" ]; then
	for file in $CLEANED_DIR/*.zip; do
		unzip -o $file
	done
else
	echo "Files already unzipped."
fi
