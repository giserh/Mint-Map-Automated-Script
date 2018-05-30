import pygeoj as gj
import csv

newfile = gj.new()
dic = {}
dic[1] = newfile

newfile.define_crs(type="name", name="urn:ogc:def:crs:EPSG::3857")
#coor = [[(1.0,1.0),(1.0,1.0),(1.0,1.0),(1.0,1.0),(1.0,1.0)]]
coor=[[[4.5, 31.0], [4.6, 31.0], [4.6, 31.1], [4.5, 31.1], [4.5, 31.0]]]
dic[1].add_feature(properties={"value":0}, geometry={"type":"Polygon", "coordinates":coor})
# newfile.add_feature(properties={"country":"Norway"}, geometry={"type":"Polygon", "coordinates":[[(21,3),(33,11),(44,22)]]} )
#newfile.save("./test.geojson")
dic[1].save("./test.geojson")