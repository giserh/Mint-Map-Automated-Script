#!/usr/bin/env python3
from typing import *
import requests
import sys
import os
import psycopg2

MINTCAST_PATH = os.environ.get('MINTCAST_PATH')
if not MINTCAST_PATH:
    print("Please set `MINTCAST_PATH` first")
    exit(0)
config_path = MINTCAST_PATH + "/config/"
sys.path.append(config_path)

from postgres_config import hostname, username, password, database

#from pipeline.config import config

CKAN_BASE_URL = "http://mint-demo.westus2.cloudapp.azure.com:5000/api/action/"
CKAN_API_KEY = "fe1c041e-b3b3-4194-8a0f-342dac0bbcf1"
CKAN_HEADER = {'Authorization': CKAN_API_KEY}

def get_file(filename, dataset):

    for res in dataset['resources']:
        if res['name'] == filename:
            print (res['url'])
    #print(resp.json())
def handle_metadata(data):
    result = {  "md5":data["name"], "file": data["url"], "filetype": None,
                "uri":data["notes"] }
    for ele in data["extras"]:
        if ele["key"] == "dataset":
            result["datast"] = ele["value"]
        elif ele["key"] == "standard_name":
            result["standard_name"] = ele["value"]
        elif ele["key"] == "short_name":
            result["short_name"] = ele["value"]
        elif ele["key"] == "location_bbox":
            result["location_bbox"] = ele["value"]
        elif ele["key"] == "start_time":
            result["start_time"] = ele["value"]
        elif ele["key"] == "end_time":
            result["end_time"] = ele["value"]

    header = requests.head(result["file"]).headers

    if "Content-Type" in header:
        result['filetype'] = header["Content-Type"]

    print(result)
    for x in result.keys():
        print(x)
    
    if result['filetype']:
        if result['filetype'] == 'application/x-netcdf':
            os.system("mintcast ")
        elif result['filetype'] == 'image/tiff':
            os.system("mintcast ")
    
def handle_dataset_by_md5(md5):
    resp = requests.get(CKAN_BASE_URL + "package_show", 
        headers=CKAN_HEADER, params={"id":md5}).json()
    if ('success' not in resp) or (not resp['success']) :
       return

    if ('success' in resp) and resp['success'] and ('result' in resp):
        handle_metadata(resp['result'])

def get_datasets():
    dataCatalog = []
    resp = requests.get(CKAN_BASE_URL + "package_list", 
        headers=CKAN_HEADER).json()
    if ('success' in resp) and resp['success'] and ('result' in resp):
        dataCatalog = resp['result']
    if len(dataCatalog) == 0:        
        return False
    print("Length of data catalog: %s\n" % len(dataCatalog));
    for md5 in dataCatalog:
        handle_dataset_by_md5(md5)
        break

usage = '''
USAGE:
    mintcast_exckan.py traversal
    mintcast_exckan.py handle [dataset_name]
'''

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(usage)
        exit()
    ops = sys.argv[1]
    if ops == "traversal":
        get_datasets();
    else:
        print(usage)
        exit()

