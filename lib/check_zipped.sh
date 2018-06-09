#!/usr/bin/env bash

### check_zipped.sh
# Checks to see if a directory of tiled files is zipped and needs to be 
# unzipped.  Unzips the files if necessary.
### Inputs: 
# 1) Directory of TIFF tile files, 2) File suffix
### Outputs: 
# Unzips files into directory (if necessary)
### Procedure:
# - Check if there are TIFF files in the directory aleady
# - If not, unzips zip files

check_zipped() {
	# Clean input directory name:
	if [ "${1: -1}" == "/" ]; then
		CLEANED_DIR=${1%/*}
	else
		CLEANED_DIR=$1
	fi

	# Check if there are unzipped files in the directory, unzip them if not:
	if [ -n "$(ls -A $CLEANED_DIR/*$2 2>/dev/null)" ]; then
		echo "Files already unzipped."
	else
		for file in $CLEANED_DIR/*.zip; do
			unzip -o $file -d $CLEANED_DIR
		done
	fi
}