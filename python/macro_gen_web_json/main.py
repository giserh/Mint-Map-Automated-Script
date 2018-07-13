#!/usr/bin/env python3

import sys, os
#import sqlite3
import psycopg2
import json

MINTCAST_PATH = os.environ.get('MINTCAST_PATH')
config_path = MINTCAST_PATH + "/config/"
sys.path.append(config_path)

RASTER_LAYER_ID_MD5 = os.environ.get('RASTER_LAYER_ID_MD5')
VECTOR_LAYER_ID_MD5 = os.environ.get('VECTOR_LAYER_ID_MD5')

from hashlib import md5

from postgres_config import hostname, username, password, database


#DATABASE_PATH = '/sql/database.sqlite'
#hostname = 'localhost'
#username = 'ADV'
#password = 'password'
#database = 'minttestdb'

JSON_FILEPATH = os.environ.get('TARGET_JSON_PATH')

METADATA = {}

def decode(string):
    return bytes(string, "utf-8").decode("unicode_escape")

def getConn():
    #conn = sqlite3.connect(MINTCAST_PATH + DATABASE_PATH)
    conn = psycopg2.connect( host=hostname, user=username, password=password, dbname=database )
    #from postgres_config import conn
    return conn

def getMetadata():
    conn = getConn()
    c = conn.cursor()
    try:
        #import pdb; pdb.set_trace()
        c.execute('SELECT * FROM mintcast.metadata')
        for row in c.fetchall():
            METADATA['%s' % row[0]] = row[1]
        # print(METADATA)
    except Exception as e:
        raise e
    finally:
        conn.close()

def updateMetadata():
    conn = getConn()
    c = conn.cursor()
    metadataJson = {}
    metadataJson['server'] = METADATA['server']
    metadataJson['tiles'] = METADATA['tileurl']
    metadataJson['originalDataset'] = METADATA['border_features']
    metadataJson['md5raster'] = []
    metadataJson['md5vector'] = []
    metadataJson['layerNames'] = []
    metadataJson['layerIds'] = []
    metadataJson['sourceLayers'] = []
    metadataJson['hasData'] = []
    metadataJson['hasTimeline'] = []
    metadataJson['layers'] = []
    try:
        c.execute('SELECT * FROM mintcast.layer')
        for row in c.fetchall():
            if row[2] == 'raster':
                #metadataJson['md5raster'].append(row[6])

                continue
            metadataJson['layerNames'].append(row[4])
            metadataJson['layerIds'].append(row[1])
            metadataJson['sourceLayers'].append(row[7])
            metadataJson['hasData'].append(False if row[9] == 0 else True)
            metadataJson['hasTimeline'].append(False if row[10] == 0 else True)
            metadataJson['md5vector'].append(row[6])
            metadataJson['md5raster'].append(md5(row[6].encode('utf-8')).hexdigest())
            if row[10] == 1:
                metadataJson['layers'].append({'id':row[1], 'source-layer': row[5], 'minzoom': row[11], 'maxzoom':row[12], 'type':row[2], 'mapping':'', 'startTime': row[14], 'endtime':row[15], 'directory_format':row[13]})
            if row[10] == 0:
                metadataJson['layers'].append({'id':row[1], 'source-layer': row[5], 'minzoom': row[11], 'maxzoom':row[12], 'type':row[2], 'mapping':''})
    except Exception as e:
        raise e
    finally:
        conn.close()
    return metadataJson

def update(identifier):
    conn = getConn()
    c = conn.cursor()
    try:
        c.execute("SELECT * FROM mintcast.layer WHERE layerid = '%s'" % identifier)
        for row in c.fetchall():
            toJson(row)
    except Exception as e:
        raise e
    finally:
        conn.close()

def toJson(row):

    layerJson = {}
    if row[2] == 'raster':
        # TODO
        return

    layerJson['id'] = row[1]
    layerJson['incre'] = row[0]
    layerJson['source-layer'] = row[7]
    layerJson['propertyName'] = 'value'
    layerJson['minzoom'] = row[11]
    layerJson['maxzoom'] = row[12]
    layerJson['bounds'] = row[13] #not being inserted
    layerJson['originalDatasetCoordinate'] = row[28]
    layerJson['values'] = row[25] #not being inserted
    layerJson['colormap'] = row[27]
    layerJson['legend-type'] = row[22]
    layerJson['legend'] = row[23]

    layerJsonStr = json.dumps(layerJson, indent=4)
    # print(layerJsonStr)
    f = open(JSON_FILEPATH + "/%s.json" % row[1],'w')
    f.write(layerJsonStr)
    f.close()
    print(JSON_FILEPATH + "/%s.json" % row[1])

def updateAll():
    conn = getConn()
    c = conn.cursor()
    try:
        c.execute('SELECT * FROM mintcast.layer')
        for row in c.fetchall():
            toJson(row)
    except Exception as e:
        raise e
    finally:
        conn.close()
    metadataJson = updateMetadata()
    metaJsonStr = json.dumps(metadataJson, indent=4)
    # print(metaJsonStr)
    f = open(JSON_FILEPATH + "/metadata.json",'w')
    f.write(metaJsonStr)
    f.close()

def updateTileserver():
    pass

def restartTileserver():
    pass

def main():
    method = sys.argv[1]
    getMetadata()
    if method == 'update-all':
        updateAll()
    elif method == 'update':
        identifier = sys.argv[2]
        update(identifier)
    elif method == 'update-config':
        metadataJson = updateMetadata()
        metaJsonStr = json.dumps(metadataJson, indent=4)
        # print(metaJsonStr)
        f = open(JSON_FILEPATH + "/metadata.json",'w')
        f.write(metaJsonStr)
        f.close()
    elif method == 'reload':
        updateTileserver()
        restartTileserver()
usage = '''
USAGE:
    main.py update-all
        update all layers' json and config.json 
        update tileserver's config json
    main.py update identifier 
        update a specific layer
        update all config files
    main.py reload
        update tileserver's config json
        restart tilesever
'''
if __name__ == '__main__':
    if JSON_FILEPATH == None:
        print('Please set up TARGET_JSON_PATH environment variable')
        exit(1)
    num_args = len(sys.argv)
    if num_args < 2:
        print(usage)
        exit(1)
    main()