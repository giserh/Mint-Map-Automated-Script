#!/usr/bin/env python3

import sys, os, sqlite3

MINTCAST_PATH = os.environ.get('MINTCAST_PATH')
DATABASE_PATH = '/sql/database.sqlite'


def main():
    num_args = len(sys.argv)

    method = sys.argv[1]
    tableName = sys.argv[2]
    conn = sqlite3.connect(MINTCAST_PATH + DATABASE_PATH)
    c = conn.cursor()
    try:
        if method == 'select':
            if num_args == 3:
                for row in c.execute('SELECT * FROM ' + tableName):
                    print(row)
            elif num_args == 4:
                for row in c.execute('SELECT * FROM %s WHERE %s ' % (tableName, sys.argv[3]) ):
                    print(row)
            elif num_args == 5:
                for row in c.execute('SELECT %s FROM %s WHERE %s' % (sys.argv[3], tableName, sys.argv[4])):
                    print(row)
        elif method == 'insert':
            if num_args == 4:
                c.execute("INSERT INTO %s VALUES (%s)" % (tableName, sys.argv[3]))
            elif num_args == 5:
                c.execute("INSERT INTO %s (%s) VALUES (%s)" % (tableName, sys.argv[3], sys.argv[4]))
        elif method == 'update':
            c.execute("UPDATE %s SET %s WHERE %s" % (tableName, sys.argv[3], sys.argv[4]))
        elif method == 'delete':
            c.execute("DELETE FROM %s WHERE %s" % (tableName, sys.argv[3], sys.argv[4]))
        elif method == 'has_layer':
            c.execute("SELECT id FROM layer WHERE layerid = %s" % sys.argv[2])
            row = c.fetchone()
            if row == None:
                print("None")
            else:
                print(row[0])
    except Exception as e:
        print(e,file=sys.stderr)
    finally:
        conn.commit()
        conn.close()


wrong_num_args_msg = '''
You have entered an invalid number of arguments.
USAGE:
    ./python/macro_sqlite_curd/main.py [method] [table name] [variable names] [values]|[where condition]
EXAMPLE:

select
    ./python/macro_sqlite_curd/main.py select metadata
        (return all data from the table)
    ./python/macro_sqlite_curd/main.py select metadata [where]
        (select * from metadata where [where])
    ./python/macro_sqlite_curd/main.py select metadata [field] [where]
        ./python/macro_sqlite_curd/main.py select metadata "k,v" "k=''"

insert
    ./python/macro_sqlite_curd/main.py insert metadata [columns] [values]
        ./python/macro_sqlite_curd/main.py insert metadata "k,v" "'foo','bar'"
    ./python/macro_sqlite_curd/main.py insert metadata [all values]
        ./python/macro_sqlite_curd/main.py insert metadata "'foo','bar'"

update
    ./python/macro_sqlite_curd/main.py update metadata "v='bar2'" "k='foo'"
        ./python/macro_sqlite_curd/main.py update metadata "v='bar2'" "k='foo'"

delete
    ./python/macro_sqlite_curd/main.py delete metadata [where]
        ./python/macro_sqlite_curd/main.py delete metadata "v='bar2'"


@RETURN
    if return are data it will be made by tab
'''

if __name__ == '__main__':
    num_args = len(sys.argv)
    if num_args > 2:
        pass
    else:
        print(wrong_num_args_msg)
        exit()

    if os.path.isfile( MINTCAST_PATH + DATABASE_PATH):
        main()
    else:
        print("DATABASE doesn't exist, please check MINTCAST_PATH and MINTCAST_PATH/sql/database.sqlite")
        exit()
