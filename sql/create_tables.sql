CREATE TABLE metadata (
	k varchar(32) COMMENT 'do not change key',
	v text,
	primary key (k)
);

insert into metadata values ('server','');
insert into metadata values ('tileurl',"/{z}/{x}/{y}");
insert into metadata values ('port','');
insert into metadata values ('config_file_location','');
insert into metadata values ('mbtiles_location','');
insert into metadata values ('metajson_location','');
insert into metadata values ('border_features','{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"stroke\":\"#000000\",\"stroke-width\":3,\"stroke-opacity\":1,\"fill\":\"#555555\",\"fill-opacity\":0.3},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[]}}]}');

-- color_no_qml

CREATE TABLE layer (
	id int(11) AUTO_INCREMENT primary key,
	layerid varchar(64) not null COMMENT 'layer id used for identifier of mbtiles',
	type varchar(8) default 'vector' COMMENT 'vector|raster',
	tileformat varchar(8) default 'pdf' COMMENT 'pdf|png',
	name varchar(64) not null COMMENT 'layer name',
	stdname varchar(255) not null COMMENT 'standard gsn name',
	md5 varchar(255) not null COMMENT 'vector mbtile md5',
	sourceLayer varchar(64) not null COMMENT 'source layer name',
	original_id int(11) not null COMMENT 'used to store data of original file',
	hasData TINYINT(1) default 0 COMMENT '0 false|1 true',
	hasTimeline TINYINT(1) default 0 COMMENT '0 false|1 true',
	maxzoom INT(3) default 14 COMMENT 'read from mbtiles metadata',
	minzoom INT(3) default 3 COMMENT 'read from mbtiles metadata',
	bounds varchar(255) COMMENT 'read from mbtiles metadata',
	mbfilename varchar(255) COMMENT 'name of mbtiles',
	directory_format varchar(255) COMMENT 'like {year}/{month}/{day}/{name}.mbtiles',
	starttime datetime default null COMMENT 'use for timeseries',
	endtime datetime default null COMMENT 'use for timeseries',
	json_filename varchar(255) COMMENT 'like soil.json|landuse.json',
	server varchar(255) COMMENT 'for test server',
	tileurl varchar(255) COMMENT 'in case different tileurl',
	styleType varchar(32) default 'fill' COMMENT 'fill|line|other',
	legend_type varchar(16) default 'linear' COMMENT 'linear|discrete',
	legend text COMMENT 'should be a json',
	uri text COMMENT 'ckan uri',
	valueArray text COMMENT 'read from mbtiles metadata',
	vector_json text COMMENT 'json for vector mbtiles',
	colormap text COMMENT 'should be a mapbox expression',
	original_dataset_bounds text COMMENT 'should be an array',
	mapping varchar(64) COMMENT 'may be not used',
	create_at timestamp default NOW(),
	modified_at timestamp default NOW(),
	FOREIGN KEY (original_id) REFERENCES original(id)
);

CREATE TABLE original (
	id int(11) AUTO_INCREMENT primary key,
	dataset_name varchar(255) COMMENT 'like forcing, elevation',
	filename varchar(255) not null COMMENT 'filename or directory name',
	filepath varchar(255) not null COMMENT 'realtive to South_Sudan, like South_Sudan/Rawdata/Soil/xxx/xx.tif',
	gdalinfo text COMMENT 'raw output from gdalinfo',
	related_json text COMMENT 'convert xml,qml to json and store here, {file1_filename:{...}}',
	create_at timestamp default NOW(),
	modified_at timestamp default NOW() 
);