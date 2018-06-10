#!/usr/bin/env python3

import sys, os
import sqlite3
import json

MINTCAST_PATH = os.environ.get('MINTCAST_PATH')
DATABASE_PATH = '/sql/database.sqlite'

METADATA = {}

def getConn():
    conn = sqlite3.connect(MINTCAST_PATH + DATABASE_PATH)
    return conn

def getMetadata():
    conn = getConn()
    c = conn.cursor()
    try:
        for row in c.execute('SELECT * FROM metadata'):
            METADATA['%s' % row[0]] = row[1]
        print(METADATA)
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

    metadataJson['layerNames'] = []
    metadataJson['layerIds'] = []
    metadataJson['sourceLayers'] = []
    metadataJson['hasData'] = []
    metadataJson['hasTimeline'] = []
    metadataJson['layers'] = []
    try:
        for row in c.execute('SELECT * FROM layer'):
            metadataJson['layerNames'].append(row[4])
            metadataJson['layerIds'].append(row[1])
            metadataJson['sourceLayers'].append(row[5])
            metadataJson['hasData'].append(False if row[7] == 0 else True)
            metadataJson['hasTimeline'].append(False if row[8] == 0 else True)
            if row[7] == 1:
                metadataJson['layers'].append({'id':row[1], 'minzoom': row[10], 'maxzoom':row[9], 'type':row[2], 'mapping':'', 'startTime': row[14], 'endtime':row[15], 'directory_format':row[13]})
            else:
                metadataJson['layers'].append({'id':row[1], 'minzoom': row[10], 'maxzoom':row[9], 'type':row[2], 'mapping':''})
    except Exception as e:
        raise e
    finally:
        conn.close()
    return metadataJson

def update(identifier):
    conn = getConn()
    c = conn.cursor()
    try:
        for row in c.execute('SELECT * FROM layer WHERE layerid = %s' % identifier):
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
    layerJson['source-layer'] = row[5]
    layerJson['propertyName'] = 'value'
    layerJson['minzoom'] = row[10]
    layerJson['maxzoom'] = row[9]
    layerJson['bounds'] = row[11]
    layerJson['originalDatasetCoordinate'] = row[24]
    layerJson['values'] = row[22]
    layerJson['colormap'] = row[23]
    layerJson['legend-type'] = row[20]
    layerJson['legend'] = row[21]

    layerJsonStr = json.dumps(layerJson)
    print(layerJsonStr)


def updateAll():
    conn = getConn()
    c = conn.cursor()
    try:
        for row in c.execute('SELECT * FROM layer'):
            toJson(row)
    except Exception as e:
        raise e
    finally:
        conn.close()
    metadataJson = updateMetadata()
    metaJsonStr = json.dumps(metadataJson, indent=4)
    print(metaJsonStr)


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
    num_args = len(sys.argv)
    if num_args < 2:
        print(usage)
        exit(1)
    main()