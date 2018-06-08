#!/usr/bin/env python2.7
import pygeoj as gj
import sys
import csv
import os

def main(argv):
    fin = sys.argv[1]  #the path of Weather/Forcing folder
    output = sys.argv[2] # the path of output folder
    # print file
    # print output
    #create directory C:\\Users\\George\\Desktop\\Weather
    with open(fin+"\\bySite\X3045Y525.csv") as f:
        reader = csv.reader(f)
        data = [r for r in reader]
        # print len(data)
        # print len(data[0][0].split())
        for i in range(1, len(data)):
            year = output+"\\"+data[i][0].split()[0][0:4]
            if not os.path.exists(year):
                os.makedirs(year)

            month = year+"\\"+ data[i][0].split()[0][4:6]
            if not os.path.exists(month):
                os.makedirs(month)

            day = month+ "\\"+ data[i][0].split()[0][6:8]
            if not os.path.exists(day):
                os.makedirs(day)

    with open(fin+"\\bySite\X3045Y525.csv") as f:
        reader = csv.reader(f)
        data = [r for r in reader]
        time = []
        vars = data[0][0].split()
        for i in range(len(data)):
            time.append(data[i][0].split()[0])
        # print time
        # print vars

    with open(fin+"\\FLDAS_grids.csv") as f:
        read = csv.reader(f)
        polygon = [r for r in read]
        for m in range(1, 6208):
            for n in range(1, 26):
                newfile = gj.new()
                newfile.define_crs(type="name", name="urn:ogc:def:crs:EPSG::3857")
                for i in range(1, len(polygon)):
                    CSV = "X"+polygon[i][6][:-3]+polygon[i][6][-2:]+"Y"+polygon[i][5][:-3]+polygon[i][5][-2:]+".csv"
                    coor = [[(float(polygon[i][1]), float(polygon[i][3])), (float(polygon[i][2]), float(polygon[i][3])), (float(polygon[i][2]), float(polygon[i][4])), (float(polygon[i][1]), float(polygon[i][4])),(float(polygon[i][1]), float(polygon[i][3]))]]
                    filename = fin+"\\bySite\\"+CSV
                    with open(filename) as file:
                        data = csv.reader(file)
                        values = [r for r in data]
                        newfile.add_feature(properties={"value":float(values[m][0].split()[n])}, geometry={"type":"Polygon", "coordinates":coor})
                #C:\\Users\\George\\Desktop\\output
                geopath = output+"\\"+time[m][0:4]+"\\"+time[m][4:6]+"\\"+time[m][6:8]+"\\"+vars[n]+".geojson"
                newfile.save(geopath)

if __name__ == '__main__':
	main(sys.argv)








