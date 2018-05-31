#!/usr/bin/env bash
set -e

### geojson2mbtiles.sh
# Generate zoom levels while converting GeoJSON file to MBTiles.
### Inputs:
# 1) Input file, 2) Output file, 3) Layer name
### Outputs:
# MBTiles file ready for mapping
### Procedure:
# - Parse arguments
# - Convert to MBTiles and generate zoom levels with tippecanoe

# Parse inputs:
export INPUT=$1
export OUTPUT=$2
export LAYER=$3

# Convert to MBTiles and generate zoom levels:
tippecanoe \
-f \
-o $OUTPUT \
-B11 \
-Z3 \
-z14 \
-m8 \
-pf \
--maximum-tile-bytes=200000 \
-s EPSG:3857 \
--coalesce-smallest-as-needed \
--extend-zooms-if-still-dropping \
--layer=$LAYER \
$INPUT