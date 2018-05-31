#!/usr/bin/env bash
set -e

### polygonize.sh
# Polygonize TIF and add layer and value names using gdal_polygonize.py
### Inputs:
# 1) Input file, 2) Output file, 3) Layer name, 4) Value name
### Outputs:
# GeoJSON file containing polygonized data
### Procedure:
# - Parse arguments
# - Polygonize with gdal_polygonize.py

# Parse inputs:
export INPUT=$1
export OUTPUT=$2 
export LAYER=$3 #Layer name
export VALUE=$4 #Value name

# Polygonize data:
gdal_polygonize.py \
$INPUT \
-f geojson \
$OUTPUT \
$LAYER \
$VALUE