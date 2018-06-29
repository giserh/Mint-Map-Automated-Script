#!/usr/bin/env python3

import sys, os, psycopg2

MINTCAST_PATH = os.environ.get('MINTCAST_PATH')

hostname = 'jonsnow.usc.edu'
username = 'vaccaro'
password = 'm\\tC7;cc'
database = 'mintcast'

#conn = psycopg2.connect( host=hostname, user=username, password=password, dbname=database )
