#!/usr/bin/env bash

# store data to sqlite3

handle_sqlite() {

	if [[ -z "$LAYER_ID_SUFFIX" ]]; then
		LAYER_ID_SUFFIX=''
	fi

	if [[ $INSERT_LAYER_WITHOUT_DATA -eq 1 ]]; then
		COL_LAYER_ID=$(python3 $MINTCAST_PATH/python/macro_string/main.py layer_name_to_layer_id $LAYERNAME$LAYER_ID_SUFFIX vector pbf)
		COL_LAYER_NAME=$(python3 $MINTCAST_PATH/python/macro_string/main.py gen_layer_name $LAYERNAME)
		COL_MAPPING=''
		python3 $MINTCAST_PATH/python/sqlite3_curd/main.py insert layer \
			"null, '$COL_LAYER_ID', 'vector', 'pbf', '$COL_LAYER_NAME', '', 0, 0, 0, 0, 0, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '$COL_MAPPING', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP"
		exit(0)
	fi
	COL_RASTER_OR_VECTOR_TYPE=$COL_RASTER_OR_VECTOR_TYPE

	COL_TILE_FORMAT='png'
	if [[ $COL_RASTER_OR_VECTOR_TYPE = 'vector' ]]; then
		COL_TILE_FORMAT='pbf'
	fi

	COL_LAYER_ID=$(python3 $MINTCAST_PATH/python/macro_string/main.py layer_name_to_layer_id $LAYERNAME$LAYER_ID_SUFFIX $COL_RASTER_OR_VECTOR_TYPE $COL_TILE_FORMAT)
	COL_LAYER_NAME=$(python3 $MINTCAST_PATH/python/macro_string/main.py gen_layer_name $LAYERNAME)
	COL_SOURCE_LAYER=$LAYERNAME
	COL_ORIGINIAL_ID=0
	COL_HAS_DATA=1
	
	COL_START_TIME=$START_TIME
	COL_END_TIME=$END_TIME

	COL_SERVER=''
	COL_TILE_URL=''
	COL_STYLE_TYPE='fill'
	COL_MAPPING=''


	$MBTILES_FILEPATH
	COL_MBTILES_FILENAME=$(python3 $MINTCAST_PATH/python/macro_path/main.py basename $MBTILES_FILEPATH)
	COL_BOUNDS=$(python3 $MINTCAST_PATH/python/macro_mbtiles/main.py bounds $MBTILES_FILEPATH)
	COL_MAXZOOM=$(python3 $MINTCAST_PATH/python/macro_mbtiles/main.py minzoom $MBTILES_FILEPATH)
	COL_MINZOOM=$(python3 $MINTCAST_PATH/python/macro_mbtiles/main.py maxzoom $MBTILES_FILEPATH)
	COL_VALUE_ARRAY=''
	COL_VECTOR_JSON=''
	if [[ $COL_RASTER_OR_VECTOR_TYPE = 'vector' ]]; then
		COL_VALUE_ARRAY=$(python3 $MINTCAST_PATH/python/macro_mbtiles/main.py values $MBTILES_FILEPATH)
		COL_VECTOR_JSON=$(python3 $MINTCAST_PATH/python/macro_mbtiles/main.py vector_json $MBTILES_FILEPATH)
	fi
	

	# TODO
	COL_HAS_TIMELINE=$COL_HAS_TIMELINE
	COL_DIRECTORY_FORMAT=$COL_DIRECTORY_FORMAT
	COL_JSON_FILENAME=$COL_JSON_FILENAME
	COL_CKAN_URL=$(python3 $MINTCAST_PATH/python/macro_upload_ckan/main.py $COL_JSON_FILENAME)

	if [[ -z "$QML_FILE" ]]; then
		------TODO-------Apply to different occassion like: netcdf??or only tiff
		MAX_VAL=$(python3 $MINTCAST_PATH/python/macro_gdal/main.py max-value $DATAFILE_PATH)
		MIN_VAL=$(python3 $MINTCAST_PATH/python/macro_gdal/main.py min-value $DATAFILE_PATH)
		COL_LEGEND_TYPE=$(python3 $MINTCAST_PATH/python/macro_extract_legend/main.py legend-type noqml $MIN_VAL $MAX_VAL)
		COL_LEGEND=$(python3 $MINTCAST_PATH/python/macro_extract_legend/main.py legend noqml $MIN_VAL $MAX_VAL)
		COL_COLORMAP=$(python3 $MINTCAST_PATH/python/macro_extract_legend/main.py colormap noqml $MIN_VAL $MAX_VAL)
	else
		COL_LEGEND_TYPE=$(python3 $MINTCAST_PATH/python/macro_extract_legend/main.py legend-type $QML_FILE)
		COL_LEGEND=$(python3 $MINTCAST_PATH/python/macro_extract_legend/main.py legend $QML_FILE)
		COL_COLORMAP=$(python3 $MINTCAST_PATH/python/macro_extract_legend/main.py colormap $QML_FILE)
	fi

	COL_ORIGINAL_DATASET_BOUNDS=$(python3 $MINTCAST_PATH/python/macro_gdal/main.py bounds-geojson-format $DATAFILE_PATH)
	


	python3 $MINTCAST_PATH/python/sqlite3_curd/main.py insert layer \
	"null, '$COL_LAYER_ID', '$COL_RASTER_OR_VECTOR_TYPE', '$COL_TILE_FORMAT', '$COL_LAYER_NAME', '$COL_SOURCE_LAYER', $COL_ORIGINIAL_ID, $COL_HAS_DATA, $COL_HAS_TIMELINE, $COL_MAXZOOM, $COL_MINZOOM, '$COL_BOUNDS', '$COL_MBTILES_FILENAME', '$COL_DIRECTORY_FORMAT', '$COL_START_TIME', '$COL_END_TIME', '$COL_JSON_FILENAME', '$COL_SERVER', '$COL_TILE_URL', '$COL_STYLE_TYPE', '$COL_LEGEND_TYPE', '$COL_LEGEND', '$COL_VALUE_ARRAY', '$COL_VECTOR_JSON', '$COL_COLORMAP', '$COL_ORIGINAL_DATASET_BOUNDS', '$COL_MAPPING', '$COL_CKAN_URL', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP"
}

	
