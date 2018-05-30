#!/usr/bin/env bash
set -e

#Checks to see if a data file is projected into WGS 84 / Pseudo-Mercator 
#(EPSG: 3857)
#Inputs: Data file to check
#Outputs: TRUE if file is projected, FALSE if it is not projected
#Procedure:
#-Creates a temporary text file of the data file's gdalinfo
#-Uses grep on text file to see if file is projected
#-Clean up temporary file


#Input file to be checked
export INPUT=$1

#Get gdalinfo of input
export GDALINFO="$(gdalinfo $INPUT)"

#Make temporary text file
export TEMP=${INPUT%.*}_temp.txt
touch $TEMP
echo $GDALINFO >> $TEMP

#Check to see if data is projected
if ! grep -q 'PROJCS\["WGS 84 / Pseudo-Mercator"' $TEMP; then
	echo "FALSE"
else
	echo "TRUE"
fi

#Remove temporary file
rm $TEMP