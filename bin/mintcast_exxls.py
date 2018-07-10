#!/usr/bin/env python3
from typing import *
import requests
import sys
import os
import xlrd
import pandas as pd

# needed headers: location (loc), value (val), unit (unit)
needed_col_keys = ['loc', 'val', 'unit', 'time', 'item']
#metadata_headers = ['title', 'name']

invalid_col_msg = '''
You have entered an invalid column key.
Options: 'loc', 'val', 'unit', 'time', 'item'
'''

invalid_term_msg = '''
You have entered an invalid search term.
Options: 'loc', 'item', 'starttime', 'endtime'
'''

def open_xls(datafile):
	sheets_dict = pd.read_excel(datafile, sheet_name=None)
	full_table = pd.DataFrame()
	for name, sheet in sheets_dict.items():
	    sheet['sheet'] = name
	    sheet = sheet.rename(columns=lambda x: x.split('\n')[-1])
	    full_table = full_table.append(sheet)
	full_table.reset_index(inplace=True, drop=True)
	return(full_table)

def get_headers(table):
	headers = table.keys()
	return(headers)

def parse_columns(**columns):
	input_col_keys = columns.keys()
	for col in input_cols:
		if col not in needed_col_keys:
			print(invalid_col_msg)
			exit(1)
	if 'loc' not in input_col_keys:
		loc_col = 'Area'
	else:
		loc_col = columns['loc']
	if 'val' not in input_col_keys:
		val_col = 'Value'
	else:
		val_col = columns['val']
	if 'unit' not in input_col_keys:
		unit_col = 'Unit'
	else:
		unit_col = columns['unit']
	if 'time' not in input_col_keys:
		time_col = 'Year'
	else:
		time_col = columns['unit']
	if 'item' not in input_col_keys:
		item_col = 'Item'
	else:
		item_col = columns['item']
	input_col_vals = columns.vals()

	return([loc_col, val_col, unit_col, time_col, item_col])

def parse_terms(headers, **terms):
	input_terms = terms.keys()
	for term in input_terms:
		if term not in needed_terms:
			print(invalid_term_msg)
	if 'loc' not in input_terms:
		loc = 'South Sudan'
	else:
		loc = terms['loc']
	if 'item' not in input_terms:
		item = 'Maize'
	else:
		item = terms['item']
	if 'starttime' not in input_terms:
		start_time = 0
	else:
		start_time = terms['starttime']
	if 'endtime' not in input_terms:
		end_time = 9999999
	else:
		end_time = terms['endtime']
	return([loc, item, start_time, end_time])

def get_data(table, **columns, **terms):
	data_dict = {}
	[loc_col, val_col, unit_col, time_col, item_col] = parse_inputs(columns)
	[loc, item, start_time, end_time] = parse_terms(headers, terms)
	#data_dict['loc_col'] = table['loc_col']
	dt = table
	inds = dt.index[dt['loc_col'] == loc & dt['item_col'] == item & start_time <= dt['time_col'] <= end_time]





usage = '''
USAGE:
	You failed.
	Goodbye.
'''

if __name__ == "__main__":
	nargs = len(sys.argv)
	if nargs < 2:
		print(usage)
		exit()
	datafile = sys.argv[1]
	if nargs == 3:
		ops = sys.argv[2]
	elif nargs > 3:
		print(usage)
		exit()
