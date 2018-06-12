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

def create_file(filepath, dataset):

    filename = os.path.split(filepath)[-1]
    resp = requests.post(ckan_base_url + '/action/resource_create', headers=headers, data={'package_id': dataset['id'], 'name': filename}, files=[('upload', open(filepath, "rb"))])
    print(resp.json()['result']['url'])
    #print(resp.json())

def update_file(resource_id, filepath, dataset):

    filename = os.path.split(filepath)[-1]
    resp = requests.post(ckan_base_url + '/action/resource_update', headers=headers, data={'package_id': dataset['id'], 'name': filename, "id": resource_id}, files=[('upload', open(filepath, "rb"))])
    print(resp.json()['result']['url'])
    #print(resp.json())

def delete_file(resource_id, dataset):

    resp = requests.post(ckan_base_url + '/action/resource_delete', headers=headers, data={'package_id': dataset['id'], "id": resource_id})
    #print(resp.json()['result'])
    #print(resp.json())

def get_file(filename, dataset):

    for res in dataset['resources']:
        if res['name'] == filename:
            print (res['url'])
    #print(resp.json())


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
    dataset_name = "mintjson"
    resp = requests.get(ckan_base_url + "/action/package_show", headers=headers, params={'id': dataset_name}).json()
    print(resp)
    if resp['success'] and resp['result'] and resp['result']['name'] == dataset_name:
        return resp['result']
    else:
        result = create_dataset(dataset_name)
        return result

usage = '''
USAGE:
    main.py create upload_file_path
    main.py update old_file_url new_file_path
    main.py delete old_file_url
    main.py get filename
'''

if __name__ == "__main__":
    if len(sys.argv) != 3 and len(sys.argv) != 4:
        print(usage)
        exit()
    ops = sys.argv[1]
    dataset = get_dataset()
    if ops == "create":
        filepath = sys.argv[2]
        create_file(filepath, dataset)
    elif ops == "update":
        url = sys.argv[2]
        resource_id = url.split("/")[-3]
        filepath = sys.argv[3]
        update_file(resource_id, filepath, dataset)
    elif ops == "delete":
        url = sys.argv[2]
        resource_id = url.split("/")[-3]
        delete_file(resource_id, dataset)
    elif ops == "get":
        filename = sys.argv[2]
        get_file(filename, dataset)
    else:
        print(usage)
        exit()




