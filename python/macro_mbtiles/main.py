#!/usr/bin/env python3

import sys, sqlite3, json

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
    conn = sqlite3.connect(mbtiles)
    c = conn.cursor()
    hasError = False

    try:
        if method == 'tile_format':
            c.execute('SELECT value FROM metadata WHERE name = "format"')
        elif method == 'bounds':
            c.execute('SELECT value FROM metadata WHERE name = "bounds"')
        elif method =='minzoom':
            c.execute('SELECT value FROM metadata WHERE name = "minzoom"')
        elif method == 'maxzoom':
            c.execute('SELECT value FROM metadata WHERE name = "maxzoom"')
        elif method == 'vector_json':
            c.execute('SELECT value FROM metadata WHERE name = "json"')
        elif method == 'values':
            c.execute('SELECT value FROM metadata WHERE name = "json"')

        # get value
        row = c.fetchone()
        if row != None:
            if method == 'vector_json':
                print(row[0].replace('"','\\"'))
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
            print("MBTILES or paramter is invalid\n" + USAGE, file= sys.stderr)
            conn.close()
            exit(2)
        conn.close()



if __name__ == '__main__':
    if len(sys.argv) < 3:
        print(USAGE, file = sys.stderr)
        exit(0)
    main()