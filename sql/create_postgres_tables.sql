CREATE SCHEMA mintcast;

CREATE TABLE mintcast.metadata (
	k varchar(32) ,
	v text,
	primary key (k)
);

insert into mintcast.metadata values ('server','');
insert into mintcast.metadata values ('tileurl','/{z}/{x}/{y}');
insert into mintcast.metadata values ('port','');
insert into mintcast.metadata values ('config_file_location','');
insert into mintcast.metadata values ('mbtiles_location','');
insert into mintcast.metadata values ('metajson_location','');
insert into mintcast.metadata values ('border_features','{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"stroke":"#000000","stroke-width":3,"stroke-opacity":1,"fill":"#555555","fill-opacity":0.3},"geometry":{"type":"Polygon","coordinates":[]}}]}');

-- color_no_qml

CREATE SEQUENCE mintcast.original_seq;

CREATE TABLE mintcast.original (
	id int DEFAULT NEXTVAL ('mintcast.original_seq') primary key,
	dataset_name varchar(255) ,
	filename varchar(255) not null ,
	filepath varchar(255) not null ,
	gdalinfo text ,
	related_json text ,
	create_at timestamp(0) default NOW(),
	modified_at timestamp(0) default NOW() 
);

CREATE SEQUENCE mintcast.layer_seq;

CREATE TABLE mintcast.layer (
	id int DEFAULT NEXTVAL ('mintcast.layer_seq') primary key,
	layerid varchar(255) not null ,
	type varchar(8) default 'vector' ,
	tileformat varchar(8) default 'pdf' ,
	name varchar(255) not null ,
	stdname varchar(255) not null ,
	md5 varchar(255) not null ,
	sourceLayer varchar(64) not null ,
	original_id int not null ,
	hasData SMALLINT default 0 ,
	hasTimeline SMALLINT default 0 ,
	maxzoom INT default 14 ,
	minzoom INT default 3 ,
	bounds varchar(255) default null ,
	mbfilename varchar(255) default null ,
	directory_format varchar(255) default null ,
	starttime timestamp(0) default null ,
	endtime timestamp(0) default null ,
	axis varchar(32) default null ,
	stepType varchar(32) default null ,
	stepOption_type varchar(16) default null ,
	stepOption_format varchar(16) default null ,
	step varchar(255) default null ,
	json_filename varchar(255) default null ,
	server varchar(255) default null ,
	tileurl varchar(255) default null ,
	styleType varchar(32) default 'fill' ,
	legend_type varchar(16) default 'linear' ,
	legend text default null ,
	uri text default null ,
	valueArray text default null ,
	vector_json text default null ,
	colormap text default null ,
	original_dataset_bounds text default null ,
	mapping varchar(64) default null ,
	create_at timestamp(0) default NOW(),
	modified_at timestamp(0) default NOW()
	-- FOREIGN KEY (original_id) REFERENCES mintcast.original(id)
);

CREATE TABLE mintcast.tileserverconfig (
	id int DEFAULT NEXTVAL ('mintcast.tileserverconfig_seq') primary key,
	layerid varchar(255) not null ,
	mbtiles varchar(255) not null ,
	md5 varchar(255) not null
);

CREATE SEQUENCE mintcast.tileserverconfig_seq;
