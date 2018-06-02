#!/usr/bin/env bash

### proc_tif2mbtiles.sh
# Convert TIFF to MBTiles
### Inputs:
# 1) Input TIFF file, 2) Name of output MBTiles
### Outputs:
# MBTiles file ready for mapping
### Procedure:
# - Convert to MBTiles with gdal_translate

# Convert GeoJSON to MBTiles:
proc_tif2mbtiles() {
	gdal_translate \
	-co QUALITY=100 \
	-co ZOOM_LEVEL_STRATEGEY=UPPER \
	-of mbtiles \
	$1`#Input TIFF` \
	$2 `#Output MBTiles`
}