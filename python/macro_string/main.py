#!/usr/bin/env python3
import sys, os
import re
import random
import math

def main():
	method = sys.argv[1]
	string = sys.argv[2]

	if method == 'layer_name_to_layer_id':
		theType = sys.argv[3]
		tileFormat = sys.argv[4]
		output = "%s_%s_%s" % (string, theType, tileFormat)
		print(output.lower().replace(' ', '_'))
	elif method == 'path_to_suffix':
		print(string.lower().replace('/','_').replace(' ', '_').replace('.','_'))
	elif method == 'lowercase':
		print(string.lower())
	elif method == 'underline':
		print(string.replace(' ',  '_'))
	elif method == 'gen_layer_name':
		print('%s_%s' % (string.replace(' ', '_'), math.ceil(random.random() * 100000)))

USAGE = '''
USAGE:
	main.py layer_name_to_layer_id [layer name] [type] [tile format]
	main.py lowercase [string]
	main.py underline [string]
'''
if __name__ == '__main__':
	if len(sys.argv) < 3:
		print(USAGE, file = sys.stderr)
		exit(0)
	main()