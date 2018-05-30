# Automated Script

## MySQL

```
# mysql -umint -pyOuaReAgeNius -h 13.57.22.75 mintmap
```

## Shell

### If there is error, stop the shell

### Library

- lib/
    - shell function
- python/
    - python script to handle 

### Handle parameters

- -qml

- -type

	- nc

	- tiff

	- tiled

- -dir

	- Use for time series

	- Use for tiled

		- -dir aaa/\*.zip

- -start-time

- -end-time

- -layer-name

### Extract file info 

- Store to MySQL

- Use as condition to run procedure

### Decide which type file it is

- Tiff

- Tiff with QML

	- Detect whether dataset is Byte format/if not convert

	- Clip use shapefile

	- Detect/To EPSG 3857

	- Python to handle QML

		- Generate color.txt

		- Write to database

	- Generate Raster Tile

		- -tr 10 10 (Resolution to keep the cell)

		- Render color.txt on tiff

			- Question: How to render linear gradient to tif ?(0% #000. 100% #fff)?

		- Translate tif to mbtiles

		- gdaladdo mbtiles generate different levels

		- Read mbtiles’ metadata table, store data to database

	- Generate Vector Tile

		- Polygonize to geojson

		- Get the layer name from parameter

			- Layer name from parameter

			- If there are multiple file(like netcdf), use the name of subdataset

			- Property name would be always `value`

		- Tippecanoe geojson to mbtiles

		- Read mbtiles’ metadata table, store data to database

		- Generate dataset.json file for vector tile

	- Update website’s config.json

	- Copy all mbtiles files to a location

		- Mbtile To dist/

		- Json to dist/json

		- Intermediate file to tmp/

		- All in .gitignore

	- Delete all mediate files

- NetCDF

	- Timeseries

		- Pass dir name

		- Start time and end time

	- Read NetCDF get all subdatasets

	- Proceed as Tiff with QML

	- When generate vector mbtiles, try to merge all layer in one for oneday

	- Store the time series in database

- Tiled

	- Detect & unzip all files

	- Merge files to tif

	- Proceed as Tiff (with QML)

### Use Python to handle String/Text/Calculation

- QML

	- To colormap

	- To database

- Handle the result of gdal_info

	- To database

	- return value

## TODO

### Use TileStache

### Time series

### Two layer (raster and vector)

### BugToFix

- Multiple legend

- Show all

- csv

- Click after remove layers

## Database

### Design of database

- metadata

	- key

		- server

		- Tile format

		- Config file location

		- Mbtile location

		- metajson file location

		- borderFeatures

			- {  
			        "type": "FeatureCollection",  
			        "features": [  
			          {  
			            "type": "Feature",  
			            "properties": {  
			              "stroke": "#000000",  
			              "stroke-width": 3,  
			              "stroke-opacity": 1,  
			              "fill": "#555555",  
			              "fill-opacity": 0.3  
			            },  
			            "geometry": {  
			              "type": "Polygon",  
			              "coordinates": []  
			            }  
			          }  
			        ]  
			      }

	- value

- layer

	- layerid

	- type

	- name

	- sourceLayer

	- hasData

	- originalDatasetBounds

	- maxzoom

	- minzoom

	- Bounds

	- hasTimeline

	- mbfilename

	- DirectoryFormat:string

		- like {year}/{month}/{day}/{name}.mbtiles

	- starttime

	- endtime

	- jsonfile

	- server

	- styleType

	- original_id

	- Colormap

	- legendType

	- legend

	- valuesArray

	- originalDatasetCoordinate

	- mapping

	- defaultColor

- original

	- Dataset name

	- Filename

	- Filepath

		-  realtive to South_Sudan

			- Like South_Sudan/Rawdata/Soil/xxx/xx.tif

	- gdalinfo:text

	- Related Json

		- convert from xml or other to json

### Use Python to read

- Generate metadata.json (will update the website)

- Generate *.json for each dataset 

	- Legend

	- Map render

- Generate configuration(tileserver-gl and TileStache)

### Store json in filesystem (in case can is failed)

### Write to ckan

## Website

### Metadata.json

### Dataset.json

### New function: Two layer (raster and vector)

### New function: Time series

