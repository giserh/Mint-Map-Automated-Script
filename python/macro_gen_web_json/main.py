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
    pass

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
    metadataJson = {}
    rowJson = {}
    if row[2] == 'raster':
        # TODO
        return
    metadataJson['server'] = METADATA['server']
    metadataJson['tiles'] = METADATA['tiles']
    updateMetadata(metadataJson)




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