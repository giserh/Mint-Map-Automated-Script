#!/usr/bin/env python3
import sys
from hashlib import md5

def main(s, encoding='utf-8'):
	print(md5(s.encode(encoding)).hexdigest())

usage = '''
USAGE:
	main.py string
'''
if __name__ == '__main__':
	if len(sys.argv) < 2:
		print(usage)
		exit(1)
	main(sys.argv[1])