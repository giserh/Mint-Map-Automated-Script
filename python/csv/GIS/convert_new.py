import pygeoj as gj
import csv

#create geojson
dic = {}
with open("C:\\Users\\George\\Desktop\\Weather\\bySite\\X3045Y525.csv") as f:
    reader = csv.reader(f)
    data = [r for r in reader]
    print len(data)
    print len(data[0][0].split())
    for i in range(1, len(data)):
        for j in range(1,len(data[0][0].split())):
            key = data[i][0].split()[0]+" "+data[0][0].split()[j]
            newfile = gj.new()
            newfile.define_crs(type = "name", name = "urn:ogc:def:crs:EPSG::3857")
            dic[key] = newfile

with open("C:\\Users\\George\\Desktop\\Weather\\FLDAS_grids.csv") as f:
    read = csv.reader(f)
    polygon = [r for r in read]
    for i in range(1, len(polygon)):
        CSV = "X"+polygon[i][6][:-3]+polygon[i][6][-2:]+"Y"+polygon[i][5][:-3]+polygon[i][5][-2:]+".csv"
        coor = [[(float(polygon[i][3]), float(polygon[i][1])), (float(polygon[i][4]), float(polygon[i][1])), (float(polygon[i][4]), float(polygon[i][2])), (float(polygon[i][3]), float(polygon[i][2])),(float(polygon[i][3]), float(polygon[i][1]))]]
        filename = "C:\\Users\\George\\Desktop\\Weather\\bySite\\"+CSV
        with open(filename) as file:
            data = csv.reader(file)
            values = [r for r in data]
            for m in range(1, len(values)):
                for n in range(1, 26):
                   key = values[m][0].split()[0]+" "+values[0][0].split()[n]
                   dic[key].add_feature(properties={"value":values[m][0].split()[n]}, geometry={"type":"Polygon", "coordinates":coor})

for key in dic:
    loc = key.split()
    geopath = "C:\\Users\\George\\Desktop\\output\\"+loc[0][0:4]+"\\"+loc[0][4:6]+"\\"+loc[0][6:8]+"\\"+loc[1]+".geojson"
    dic[key].save(geopath)
