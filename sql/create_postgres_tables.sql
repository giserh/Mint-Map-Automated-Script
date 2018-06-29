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
	name varchar(64) not null ,
	stdname varchar(255) not null ,
	md5 varchar(255) not null ,
	sourceLayer varchar(64) not null ,
	original_id int not null ,
	hasData SMALLINT default 0 ,
	hasTimeline SMALLINT default 0 ,
	maxzoom INT default 14 ,
	minzoom INT default 3 ,
	bounds varchar(255) ,
	mbfilename varchar(255) ,
	directory_format varchar(255) ,
	starttime timestamp(0) default null ,
	endtime timestamp(0) default null ,
	json_filename varchar(255) ,
	server varchar(255) ,
	tileurl varchar(255) ,
	styleType varchar(32) default 'fill' ,
	legend_type varchar(16) default 'linear' ,
	legend text ,
	uri text ,
	valueArray text ,
	vector_json text ,
	colormap text ,
	original_dataset_bounds text ,
	mapping varchar(64) ,
	create_at timestamp(0) default NOW(),
	modified_at timestamp(0) default NOW()
	-- FOREIGN KEY (original_id) REFERENCES mintcast.original(id)
);

