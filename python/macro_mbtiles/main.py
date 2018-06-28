#!/usr/bin/env python3

import sys, psycopg2, json

USAGE='''
USAGE:
    main.py tile_format [mbtiles_file] 
    main.py bounds      [mbtiles_file]
    main.py minzoom     [mbtiles_file]
    main.py maxzoom     [mbtiles_file]
    main.py vector_json [mbtiles_file]
    main.py values      [mbtiles_file]

'''

def main():
    method = sys.argv[1]
    mbtiles = sys.argv[2]

    hostname = 'localhost'
    username = 'ADV'
    password = 'password'
    database = 'minttestdb'

    conn = psycopg2.connect( host=hostname, user=username, password=password, dbname=database )
    c = conn.cursor()
    hasError = False

    try:
        if method == 'tile_format':
            c.execute("SELECT v FROM mintcast.metadata WHERE k = 'format'")
        elif method == 'bounds':
            c.execute("SELECT v FROM mintcast.metadata WHERE k = 'bounds'")
        elif method =='minzoom':
            c.execute("SELECT v FROM mintcast.metadata WHERE k = 'minzoom'")
        elif method == 'maxzoom':
            c.execute("SELECT v FROM mintcast.metadata WHERE k = 'maxzoom'")
        elif method == 'vector_json':
            c.execute("SELECT v FROM mintcast.metadata WHERE k = 'json'")
        elif method == 'values':
            c.execute("SELECT v FROM mintcast.metadata WHERE k = 'json'")

        # get value
        row = c.fetchone()
        if row != None:
            if method == 'vector_json':
                print(row[0])
            elif method == 'values':
                jd = json.loads(row[0])
                print(jd["tilestats"]["layers"][0]['attributes'][0]['values'])
            else:
                print(row[0])
        else:
            hasError = True
    except Exception as e:
        raise e
    finally:
        if hasError:
            print("MBTILES or parameter is invalid\n" + USAGE, file= sys.stderr)
            conn.close()
            exit(2)
        conn.close()



if __name__ == '__main__':
    if len(sys.argv) < 3:
        print(USAGE, file = sys.stderr)
        exit(0)
    main()