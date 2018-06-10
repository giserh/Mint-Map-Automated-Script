#!/usr/bin/python
# -*- coding: utf-8 -*-
from typing import *
import requests
import csv
import sys
import os
#from pipeline.config import config

ckan_base_url = "http://mint-demo.westus2.cloudapp.azure.com:5000/api"
api_key = "fe1c041e-b3b3-4194-8a0f-342dac0bbcf1"
headers = {'Authorization': api_key}

def process_file(filepath, dataset):

    filename = os.path.split(filepath)[-1]
    resp = requests.post(ckan_base_url + '/action/resource_create', headers=headers, data={'package_id': dataset['id'], 'name': filename}, files=[('upload', open(filepath, "rb"))])

    print(resp.json()['result']['url'])


def create_dataset(dataset_name):

    print(f"dataset {dataset_name} doesn't exist on CKAN. Creating...")
    payload = {
        'name': dataset_name,
        'owner_org': 'mint',
        'url': "https://github.com/GeorgeKid/test/tree/master/json"
    }

    resp = requests.post(ckan_base_url + '/action/package_create', headers=headers, data=payload).json()

    print(f"CKAN responded with {resp}")

    return resp['result']

def get_dataset():
    dataset_name = "traynor_iowa_30m"

    resp = requests.get(ckan_base_url + "/action/package_show", headers=headers, params={'id': dataset_name}).json()

    if resp['success'] and resp['result'] and resp['result']['name'] == dataset_name:
        return resp['result']
    else:
        result = create_dataset(dataset_name)
        return result

usage = '''
USAGE:
    main.py upload_file_path
    will return the url for the uploaded file
'''

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(usage)
        exit()
    filepath = sys.argv[1]
    dataset = get_dataset()

    process_file(filepath, dataset)