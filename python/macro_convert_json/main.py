#!/usr/bin/env python2.7
from xml2json import xml2json
import optparse
import json
import sys
import sqlite3
import os
import datetime
import gdal 

MINTCAST_PATH = os.environ.get('MINTCAST_PATH')
DATABASE_PATH = '/sql/database.sqlite'

def XMLtoJson(path):
    xmlstring = ""
    options = None

    options = optparse.Values({"pretty": True})

    xmlstring = open(path).read()

    strip_ns = 1

    json_string = xml2json.xml2json(xmlstring, options, strip_ns)
    json_data = json.loads(json_string)

    return json_data


def main(argv):

    #this path is the "tif" or "nc" file
    file = sys.argv[1]
    folder = os.path.dirname(file)

    '''
    file_name is "SLTPPT_M_sl1_250m", file_type is "tif"
    '''
    file_name = os.path.split(file)[-1].split('.')[0]
    file_type = os.path.split(file)[-1].split('.')[-1]

    '''
    da_name is the data folder, such as "soil", each is different, is "./Rawdata", is file.split('/')[2]
    '''
    da_name =file.split('/')[-3]

    '''
    this is the gdal_dic
    '''
    gdal_dic ={}
    ds_in = gdal.Open(file)
    gdal_dic["metadata"] = ds_in.GetMetadata()
    gdal_dic["driver"] = ds_in.GetDriver()
    gdal_dic["subdatasets"] = ds_in.GetSubDatasets()

    '''
    this is the json_dic 
    '''
    json_dic = {}

    flag = False #find the xml/qml or not

    for f in os.listdir(folder):
        if(os.path.split(f)[-1].split('.')[-1] == 'xml' and os.path.split(f)[-1].split('.')[0] == file_name):
            json_dic[os.path.split(f)[-1]] = XMLtoJson(folder+"/"+f)
            flag = True
            break
        elif(os.path.split(f)[-1].split('.')[-1] == 'qml' and os.path.split(f)[-1].split('.')[0] == file_name):
            json_dic[os.path.split(f)[-1]] = XMLtoJson(folder+"/"+f)
            flag = True
            break
    '''
    if not find, add all xml to dic
    '''
    if(flag == False):
        for f in os.listdir(folder):
            if (os.path.split(f)[-1].split('.')[-1] == 'xml' or os.path.split(f)[-1].split('.')[-1] == 'qml'):
                json_dic[os.path.split(f)[-1]] = XMLtoJson(folder + "/" + f)

    # else:
    # create connection, path should be changed later
    cn = sqlite3.connect("/Users/shiweihuang/Documents/Github/Mint-Map-Automated-Script/sql/database.sqlite")
    #create cursor
    cu = cn.cursor()

    cu.execute("INSERT INTO original VALUES (0,\""+da_name+"\",\""+file_name+"\",\""+file+"\",\""+str(gdal_dic)+"\",\""+str(json_dic)+"\", \"DEFAULT\",\"DEFAULT\")")

    #print ("INSERT INTO original VALUES (0,\""+da_name+"\",\""+file_name+"\",\""+file+"\",\"\",\"\",DEFAULT,DEFAULT)")

    cn.commit()

    for row in cu.execute('SELECT * FROM original'):
        print(row)

    cu.execute("delete from original where id = 0")

    cn.commit()

    #show all the databases here to make suer that we know which to store
    #print (cu.execute("select * from sqlite_master").fetchall())


if __name__ == '__main__':
     main(sys.argv)
