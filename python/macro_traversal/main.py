#!/usr/bin/env python3

# argv [./main.py, 'dir','dir structure', 'start', 'end']

import sys
import os
import re
from os.path import isfile, join
from datetime import datetime, date, time, timedelta

def daterange(start_date, end_date):
    for n in range(int ((end_date - start_date).days)):
        yield start_date + timedelta(n)

def main(argv):
	_dir = sys.argv[1]
	_wildcardStructure = sys.argv[2].replace('{year}','%Y').replace('{month}', '%m').replace('{day}','%d')
	_structure = os.path.dirname(_wildcardStructure)
	__timeFormat = _structure.replace('/', '')
	_start = datetime.strptime(sys.argv[3], __timeFormat)
	_end = datetime.strptime(sys.argv[4], __timeFormat)
	_filetype = os.path.splitext(sys.argv[2])[1]

	files = []
	_oldpath = ''
	for single_date in daterange(_start, _end):
		_folder = single_date.strftime(_structure)
		_path = _dir + _folder
		if _oldpath == _path:
			continue

		for f in os.listdir(_path):
			if isfile(join(_path,f)):
				if os.path.splitext(f)[1]==_filetype:
					print(join(_path,f))
					# Then use xargs -I % cmd %
		_oldpath = _path
if __name__ == '__main__':
	main(sys.argv)