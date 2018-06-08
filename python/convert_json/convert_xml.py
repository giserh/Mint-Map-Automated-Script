#!/usr/bin/env python3.6
from xml2json import xml2json
import optparse
import json
import sys

xmlstring = ""
options = None

options = optparse.Values({"pretty": False})

filename = sys.argv[1]
xmlstring = open(filename).read()

strip_ns = 1

json_string = xml2json.xml2json(xmlstring,options,strip_ns)
json_data = json.loads(json_string)

output = sys.argv[2]
with open(output, 'w') as f:
  json.dump(json_data, f, ensure_ascii=False)

