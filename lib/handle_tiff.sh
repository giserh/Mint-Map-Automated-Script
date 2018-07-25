#!/usr/bin/env bash

### handle_tiff.sh
# Complete workflow for generating raster and vector tiles from TIFFs.
### Inputs:
# 1) Input filepath, 2) Layer name

### TO DO: figure out what to use for no data value depending on data type

# Source functions:
source $MINTCAST_PATH/lib/check_projection.sh
source $MINTCAST_PATH/lib/check_type.sh
source $MINTCAST_PATH/lib/proc_clip.sh
source $MINTCAST_PATH/lib/proc_newres.sh
source $MINTCAST_PATH/lib/proc_tif2mbtiles.sh
source $MINTCAST_PATH/lib/proc_gdaladdo.sh
source $MINTCAST_PATH/lib/proc_gdaldem.sh
source $MINTCAST_PATH/lib/proc_polygonize.sh
source $MINTCAST_PATH/lib/proc_geojson2mbtiles.sh

handle_tiff(){
	# Parse arguments from mintcast.sh:
	INPUT=$DATAFILE_PATH
	LAYER_NAME=$LAYER_NAME

	# Hard-coded paths (passed from mintcast.sh?):
	if [[ -z "$OUT_DIR" ]]; then
		OUT_DIR="$MINTCAST_PATH/dist"
	fi
	if [[ ! -d "$OUT_DIR" ]]; then
		mkdir -p "$OUT_DIR"
	fi
	if [[ -z "$TEMP_DIR" ]]; then
		TEMP_DIR="$MINTCAST_PATH/tmp"
	fi
	if [[ ! -d "$TEMP_DIR" ]]; then
		mkdir -p "$TEMP_DIR"
	fi
	if [[ $DEV_MODE != 'YES' ]]; then
		OUT_DIR=$TARGET_MBTILES_PATH
	fi
	#OUT_DIR=$MINTCAST_PATH/dist
	#TEMP_DIR=$OUT_DIR
	#TEMP_DIR=$MINTCAST_PATH/tmp
	SS_BOUNDARY="$MINTCAST_PATH/shp/ss.shp"

	# Remove path from inpust:
	echo "INPUT: $INPUT"
	FILENAME=$(basename $INPUT)

	# Set names for intermediary and output files:
	CLIP_OUT=$TEMP_DIR/${FILENAME%.*}_clip.tif
	PROJ_OUT=${CLIP_OUT%.*}_proj.tif
	RES_OUT=${PROJ_OUT%.*}_newres.tif
	COLOR_OUT=${RES_OUT%.*}_color.tif
	POLY_OUT=${PROJ_OUT%.*}_poly.geojson
	if [[ -z "$LAYER_ID_SUFFIX" ]]; then
		LAYER_ID_SUFFIX=''
	fi

	echo "VECTOR_MD5: $VECTOR_MD5"
	VECTOR_LAYER_ID=$(python3 $MINTCAST_PATH/python/macro_string/main.py layer_name_to_layer_id $LAYER_NAME$LAYER_ID_SUFFIX vector pbf)
	### CHANGE THE LINE BELOW TO GET THE PROPER MD5 (AFTER INTEGRATING WITH THE DATA CATALOG)
	if [[ -z $VECTOR_MD5 ]]; then
		export VECTOR_LAYER_ID_MD5=$(python3 $MINTCAST_PATH/python/macro_md5/main.py $VECTOR_LAYER_ID)
	elif [[ ! -z $VECTOR_MD5 ]]; then
		export VECTOR_LAYER_ID_MD5=$VECTOR_MD5
	fi
	#echo "VECTOR_LAYER_ID_MD5: $VECTOR_LAYER_ID_MD5"
	VECTOR_MBTILES=$OUT_DIR/$VECTOR_LAYER_ID.mbtiles
	echo "VECTOR_MBTILES: $VECTOR_MBTILES"
	if [[ -f $VECTOR_MBTILES ]]; then
		rm -f $VECTOR_MBTILES
	fi

	RASTER_LAYER_ID=$(python3 $MINTCAST_PATH/python/macro_string/main.py layer_name_to_layer_id $LAYER_NAME$LAYER_ID_SUFFIX raster png)
	#echo "RASTER_LAYER_ID: $RASTER_LAYER_ID"
	### CHANGE THE LINE BELOW TO GET THE PROPER MD5 (AFTER INTEGRATING WITH THE DATA CATALOG)
	if [[ -z $VECTOR_MD5 ]]; then
		export RASTER_LAYER_ID_MD5=$(python3 $MINTCAST_PATH/python/macro_md5/main.py $RASTER_LAYER_ID)
	elif [[ ! -z $VECTOR_MD5 ]]; then
		export RASTER_LAYER_ID_MD5=$(python3 $MINTCAST_PATH/python/macro_md5/main.py $VECTOR_MD5)
		echo "RASTER_LAYER_ID_MD5: $RASTER_LAYER_ID_MD5"
	fi



	#echo "RASTER_LAYER_ID_MD5: $RASTER_LAYER_ID_MD5"
	RASTER_MBTILES=$OUT_DIR/$RASTER_LAYER_ID.mbtiles
	echo "RASTER_MBTILES: $RASTER_MBTILES"
	if [[ -f $RASTER_MBTILES ]]; then
		rm -f $RASTER_MBTILES
	fi

	#HAS_LAYER=$(python3 $MINTCAST_PATH/python/macro_sqlite_curd/main.py has_tileserver_config $RASTER_LAYER_ID)
	HAS_LAYER=$(python3 $MINTCAST_PATH/python/macro_postgres_curd/main.py has_tileserver_config $RASTER_LAYER_ID)
	if [[ "$HAS_LAYER" = "None" ]]; then
		#python3 $MINTCAST_PATH/python/macro_sqlite_curd/main.py insert tileserverconfig \
		python3 $MINTCAST_PATH/python/macro_postgres_curd/main.py insert tileserverconfig \
			"layerid, mbtiles, md5" \
			"'$RASTER_LAYER_ID', '$RASTER_MBTILES', '$RASTER_LAYER_ID_MD5'"

	else
		#python3 $MINTCAST_PATH/python/macro_sqlite_curd/main.py update tileserverconfig \
		python3 $MINTCAST_PATH/python/macro_postgres_curd/main.py update tileserverconfig \
			"layerid='$RASTER_LAYER_ID', mbtiles='$RASTER_MBTILES', md5='$RASTER_LAYER_ID_MD5'" \
			"id=$HAS_LAYER"
	fi




	#HAS_LAYER=$(python3 $MINTCAST_PATH/python/macro_sqlite_curd/main.py has_tileserver_config $VECTOR_LAYER_ID)
	HAS_LAYER=$(python3 $MINTCAST_PATH/python/macro_postgres_curd/main.py has_tileserver_config $VECTOR_LAYER_ID)
	if [[ "$HAS_LAYER" = "None" ]]; then
		#python3 $MINTCAST_PATH/python/macro_sqlite_curd/main.py insert tileserverconfig \
		python3 $MINTCAST_PATH/python/macro_postgres_curd/main.py insert tileserverconfig \
			"layerid, mbtiles, md5" \
			"'$VECTOR_LAYER_ID', '$VECTOR_MBTILES', '$VECTOR_LAYER_ID_MD5'"
	else
		#python3 $MINTCAST_PATH/python/macro_sqlite_curd/main.py update tileserverconfig \
		python3 $MINTCAST_PATH/python/macro_postgres_curd/main.py update tileserverconfig \
			"layerid='$VECTOR_LAYER_ID', mbtiles='$VECTOR_MBTILES', md5='$VECTOR_LAYER_ID_MD5'" \
			"id=$HAS_LAYER"
	fi
	# Check for QML file:
	echo "QML_FILE: $QML_FILE"
	if [[ -z "$QML_FILE" ]]; then
		COLOR_TABLE="$MINTCAST_PATH/shp/colortable.txt"
	else
		QML_EXTRACT_PATH="$MINTCAST_PATH/python/macro_extract_colors/main.py"
		COLOR_TABLE=$TEMP_DIR/${FILENAME%.*}_color.txt
		echo "COLOR_TABLE: $COLOR_TABLE"
		python3 $QML_EXTRACT_PATH $QML_FILE $COLOR_TABLE #Make colortable
	fi
	# CheckType for Already Byted file and add nodata flag
	NODATAFLAG=''
	POLYGONIZE_FLOAT_FLAG=''
	check_type $INPUT
	# Pre-processing:
	echo "handle_tiff.sh"
	echo "INPUT: $INPUT"
	echo "CLIP_OUT: $CLIP_OUT"
	echo "Clipping..."
	echo "USE_SS_SHAPE: $USE_SS_SHAPE"
	echo "CLIP_BOUNDS: $CLIP_BOUNDS"
	if [[ USE_SS_SHAPE != "NO" ]]; then
		echo "Using SS shapefile..."
		echo "SS_BOUNDARY: $SS_BOUNDARY"
		proc_clip $INPUT $CLIP_OUT $SS_BOUNDARY #Clip to South Sudan boundary
	else
		echo "Not using SS shapefile..."
		#CLIP_OUT=$INPUT
		proc_clip $INPUT $CLIP_OUT
	fi

	echo "Projecting..."
	check_projection $CLIP_OUT $PROJ_OUT #Check projection/change to EPSG 3857

	echo "GENERATE_RASTER_TILE: $GENERATE_RASTER_TILE"
	echo "GENERATE_NEW_RES: $GENERATE_NEW_RES"
	echo "GENERATE_VECTOR_TILE $GENERATE_VECTOR_TILE"
	if [[ $GENERATE_RASTER_TILE == "YES" ]]; then
		echo "Generating raster tiles..."
	# Generate raster tiles:
		if [[ $GENERATE_NEW_RES == "YES" ]]; then
			# with new res proc
			echo "Setting new resolution..."
			proc_newres $PROJ_OUT $RES_OUT #Set resolution for raster tiles
			echo "Adding colors..."
			echo "COLOR_TABLE: $COLOR_TABLE"
			proc_gdaldem $RES_OUT $COLOR_TABLE $COLOR_OUT
		else
			# without new res proc
			echo "Adding colors..."
			echo "COLOR_TABLE: $COLOR_TABLE"
			proc_gdaldem $PROJ_OUT $COLOR_TABLE $COLOR_OUT
		fi
	echo "Making raster tiles..."
	proc_tif2mbtiles $COLOR_OUT $RASTER_MBTILES #Make .mbtiles
	echo "Generating zoom levels..."
	proc_gdaladdo $RASTER_MBTILES #Generate zoom levels
	### TO DO: read MBTiles metadata table/store to database
	fi

	if [[ $GENERATE_VECTOR_TILE == "YES" ]]; then
		# Generate vector tiles:
		echo "Generating polygonized GeoJSON..."
		proc_polygonize $PROJ_OUT $POLY_OUT $LAYER_NAME #Make GeoJSON
		echo "Making vector tiles..."
		proc_geojson2mbtiles $POLY_OUT $VECTOR_MBTILES $LAYER_NAME #Make .mbtiles
	fi

	#TODO by Libo
	# if [[ $DEV_MODE != 'NO' ]]; then
	# 	# move to OUT_DIR=$TARGET_MBTILES_PATH
	# fi

	# Delete intermediate files:
	#rm $CLIP_OUT $PROJ_OUT $RES_OUT $COLOR_OUT $POLY_OUT

}