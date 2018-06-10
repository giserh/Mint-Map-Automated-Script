#!/usr/bin/env python3

import re, sys

# Extract color info from QML file and write color to output text file:	
def main(qmlfile, output):
	qml = open(qmlfile, "r")
	# Prepare regex strings for extracting info:
	start_str = '<item'
	alpha_str = 'alpha="(.+?)"'
	value_str = 'value="(.+?)"'
	label_str = 'label="(.+?)"'
	color_str = 'color="(.+?)"'
	color_table_list = []
	# Extract info from QML:
	for line in qml:
	    if start_str in line:
	        color_table_line = []
	        alpha = re.search(alpha_str, line).group(1)
	        value = re.search(value_str, line).group(1)
	        label = "#" + re.search(label_str, line).group(1)
	        color_hex = re.search(color_str, line).group(1).lstrip("#")


wrong_num_args_msg = '''
You have entered an invalid number of arguments.
This script takes TWO arguments:
1) QML file path, and 
'''

bad_args_msg = '''
Could not perform color extraction.
Please check that the QML and output file paths are valid.
'''

table_generated_msg = '''
Color table has been successfully generated at: %s
'''

if __name__ == '__main__':
	num_args = len(sys.argv)
	if num_args == 3:
		try:
			qmlfile = sys.argv[1]
			output = sys.argv[2]
			main(qmlfile, output)
			print(table_generated_msg % output)
		except: 
			print(bad_args_msg)
			exit()
	else:
		print(wrong_num_args_msg)
		exit()


