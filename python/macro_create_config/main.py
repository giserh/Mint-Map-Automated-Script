#!/usr/bin/env python3

import sys, os, sqlite3

MINTCAST_PATH = os.environ.get('MINTCAST_PATH')
DATABASE_PATH = '/sql/database.sqlite'

def main():
	num_args = len(sys.argv)

	conn = sqlite3.connect(MINTCAST_PATH + DATABASE_PATH)
	c = conn.cursor()

