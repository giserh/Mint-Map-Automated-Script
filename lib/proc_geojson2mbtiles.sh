#!/usr/bin/env bash

### geojson2mbtiles.sh
# Generate zoom levels while converting GeoJSON file to MBTiles.
### Inputs:
# 1) Input file, 2) Name of output file, 3) Layer name
### Outputs:
# MBTiles file ready for mapping
### Procedure:
# - Convert to MBTiles and generate zoom levels with tippecanoe

# Convert GeoJSON to MBTiles:
convert_geojson() {
	tippecanoe \
	-f \
	-o $2`#Output filename` \
	-B11 \
	-Z3 \
	-z14 \
	-m8 \
	-pf \
	--maximum-tile-bytes=200000 \
	-s EPSG:3857 \
	--coalesce-smallest-as-needed \
	--extend-zooms-if-still-dropping \
	--layer=$3 `#Layer name`\
	$1 `#Input filename`
}