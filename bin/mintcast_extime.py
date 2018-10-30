#!/usr/bin/env python3

import sys, os, subprocess

from hashlib import md5

#MINTCAST_PATH = os.environ.get('MINTCAST_PATH')
#bin_path = MINTCAST_PATH + '/bin/'
#sys.path.append(bin_path)
#def parse_kwargs(**kwargs):
#	return ""

def get_timesteps(files, ntime):
	time_steps = []
	for file in files:
		file_split = file.split(".")[-2]
		time_steps.append(file_split[-ntime::])
	sorted(time_steps)
	time_steps_str = '['
	for time in time_steps:
		time_steps_str += '"2017%s",' %(time) #CHANGE THIS LATER
	time_steps_str = time_steps_str[:-1] + ']'
	print(time_steps_str)
	return(time_steps_str)

def parse_kwargs(**kwargs):
	return ""

def check_cwd():
	cwd = os.getcwd()
	if "/bin" in cwd:
		os.chdir("..") #can only run mintcast.sh from MINTCAST_PATH (1 level up)
		check_cwd()

def convert_asc_to_tif(input_dir):
	files = os.listdir(input_dir)
	if input_dir[-1] != "/": input_dir += "/"
	asc_files = [file for file in files if ".asc" in file and "._" not in file and "aux.xml" not in file]
	for file in asc_files:
		file_strip = file[:-4]
		full_input = input_dir + file
		full_output = input_dir + file_strip + ".tif"
		GDAL_command = "gdal_translate " + full_input + " " + full_output + " -a_srs EPSG:102022" # NEED TO CHANGE THIS (also make param)
		#print(GDAL_command)
		#import pdb; pdb.set_trace()
		subprocess.call(GDAL_command, shell=True)



# accept folder as input
def main(input_dir, **kwargs):
	# kwargs could include: md5 (-m asdfa314as), ?
	check_cwd()
	file_ext = ".asc" #make param
	time_format = "MM" #make param
	ntime = len(time_format)
	if file_ext == ".asc": convert_asc_to_tif(input_dir)
	files = os.listdir(input_dir)
	real_files = []
	for file in files:
		#print(file)
		if ".tif" in file and "._" not in file and "aux.xml" not in file: 
			real_files.append(file)
	real_files = sorted(real_files)
	nFiles = len(real_files)
	t_flag =  " -t tiff-time"
	timesteps_str = get_timesteps(real_files, ntime)
	timesteps_flag = " --time-steps " + timesteps_str
	for ii in range(nFiles):
		file = real_files[ii]
		file_str = " " + input_dir + "/" + file
		MINT_command = "./bin/mintcast.sh" + file_str + t_flag + timesteps_flag
		file_split = file.split(".")[-ntime]
		md5in = layerin = timeformatin = timestampin = newresin = projfirstin = noclipin = False
		if kwargs:
			for key in kwargs:
				if key == "-m": md5in = True
				if key == "-l": layerin = True
				if key == "--time-format": timeformatin = True
				if key == "--time-stamp": timestampin = True
				if key == "--new-res": newresin = True
				if key == "--force-proj-first": projfirstin = True
				if key == "--disable-clip": noclipin = True
				#op = " %s %s" %(key, kwargs[key])
				#MINT_command += op
		if not layerin:
			layer_name = "placeholder_layer_name" #CHANGE THIS
		else:
			layer_name = kwargs['-l']
		l_flag = " -l " + layer_name
		MINT_command += l_flag
		if not timeformatin:
			#timeformat = "yyyy"
			timeformat = "MM"
			timeformat_flag = " --time-format " + timeformat
			MINT_command += timeformat_flag
		if not timestampin:
			timestamp = file_split[-ntime:] #probably change this
			timestamp_flag = " --time-stamp " + str(timestamp)
			MINT_command += timestamp_flag
		if not md5in:
			md5hash = md5('vaccaro'.encode('utf-8')).hexdigest()
		else:
			md5hash = kwargs['-m']
		m_flag = " -m %s_%s" %(md5hash, timestamp)
		MINT_command += m_flag
		if not newresin:
			res_flag = " --disable-new-res"
			MINT_command += res_flag
		if projfirstin:
			projfirst_flag = " --force-proj-first"
			MINT_command += projfirst_flag
		if noclipin:
			noclip_flag = " --disable-clip"
			MINT_command += noclip_flag
		if ii == 0:
			MINT_command += " --first-file"
		print(MINT_command)
		#print(os.getcwd())
		#subprocess.call('./bin/mintcast.sh')
		subprocess.call(MINT_command, shell=True)

# in python:
# run mintcast for each file in folder
# for each file:
# need to figure timestamp
# generate a command

if __name__ == "__main__":
	nargs = len(sys.argv)
	if nargs < 2:
		print(usage)
		exit(1)
	input_dir = sys.argv[1]
	if nargs == 2:
		main(input_dir)
	elif nargs > 2:
		kwargs = {}
		#print(sys.argv[2])
		for kwarg in sys.argv[2:]:
			kwsplit = kwarg.split("=")
			k = kwsplit[0]
			v = kwsplit[1]
			kwargs[k] = v
		main(input_dir, **kwargs)


