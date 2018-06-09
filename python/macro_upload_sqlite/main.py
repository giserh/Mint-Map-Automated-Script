#!/usr/bin/env python3
import sqlite3
import sys
import os


def main(argv):

    #create connection
    filepath = os.path.realpath("database.sqlite")
    cx = sqlite3.connect(filepath)

    #create cursor
    cu = cx.cursor()

    #show all the databases here to make suer that we know which to store
    #print (cu.execute("select * from sqlite_master").fetchall())

    


if __name__ == '__main__':
     main(sys.argv)