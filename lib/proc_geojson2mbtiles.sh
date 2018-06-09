#!/usr/bin/env bash

### proc_geojson2mbtiles.sh
# Generate zoom levels while converting GeoJSON file to MBTiles.
### Inputs:
# 1) Input file, 2) Name of output file, 3) Layer name
### Outputs:
# MBTiles file ready for mapping
### Procedure:
# - Convert to MBTiles and generate zoom levels with tippecanoe

# Convert GeoJSON to MBTiles:
proc_geojson2mbtiles() {
	tippecanoe \
	-f \
	-o $2`#Output filename` \
	-B11 \
	-Z3 \
	-z14 \
	-m5 \
	-d16 \
	-D13 \
	-pf \
	-s EPSG:3857 \
	--layer=$3 `#Layer name`\
	$1 `#Input filename`
}