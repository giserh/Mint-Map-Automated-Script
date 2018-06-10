#!/usr/bin/env python3

import re, sys
import json
# Extract color info from QML file and write color to output text file: 
def main():
    method = sys.argv[1]
    qmlfile = sys.argv[2]
    if qmlfile == 'noqml':
        minValue = sys.argv[3]
        maxValue = sys.argv[4]
        if method == 'colormap':
            print('["interpolate", ["linear"],["get", "value"], %s, "#000", %s,"#fff"]' % (minValue, maxValue))
        elif method == 'legend':
            print('[ {"label":"%s", "value":%s, "color":"#000"}, {"label":"%s", "value": %s, "color":"#fff"}]' % (minValue, minValue, maxValue, maxValue))
        elif method == 'legend-type':
            print('linear')
    else:
        qml = open(qmlfile, "r")
        # Prepare regex strings for extracting info:
        start_str = '<item'
        alpha_str = 'alpha="(.+?)"'
        value_str = 'value="(.+?)"'
        label_str = 'label="(.+?)"'
        color_str = 'color="(.+?)"'
        label_list = []
        color_list = []
        value_list = []
        # Extract info from QML:
        for line in qml:
            if start_str in line:
                color_table_line = []
                alpha = re.search(alpha_str, line).group(1)
                value = re.search(value_str, line).group(1)
                label = re.search(label_str, line).group(1)
                color_hex = re.search(color_str, line).group(1).lstrip("#")
                color_rgb = tuple(int(color_hex[i:i+2], 16) for i in (0, 2 ,4))
                color_rgba = "rgba(%s, %s, %s, %s)" % (color_rgb[0], color_rgb[1], color_rgb[2], alpha)
                label_list.append(label)
                color_list.append(color_rgba)
                value_list.append(value)

        if method == 'colormap':
            '''
            ["match", 
                ["get", "value"], 
                0, "#BABEBE",
                1, "#14670C",
                2, "#55A859",
                3, "#7FD01F",
                4, "#73EA69",
                5, "#4FCD88",
                6, "#D37379",
                7, "#FAECA5",
                8, "#B8EA8E",
                9, "#F8EA2C",
                10, "#F5C26C",
                11, "#4287CE",
                12, "#FBFF2D",
                13, "#F0001A",
                14, "#8E9017",
                15, "#FBDCD4",
                16, "#BDBDBD",
                "#000"
            ],
            '''
            colormap = ["match", ["get", "value"]]
            for idx, val in enumerate(color_list):
                colormap.append(int(value_list[idx])) # consider all are interger
                colormap.append(val)
            colormap.append("#000")
            print(json.dumps(colormap))
        elif method == 'legend':
            '''
            [ {"label":"Water", "value":0, "color":"#BABEBE"}, 
            {"label":"Evergreen Needle leaf Forest", "value":1, "color":"#14670C"}, 
            {"label":"Evergreen Broadleaf Forest", "value":2, "color":"#55A859"}, 
            {"label":"Deciduous Needle leaf Forest", "value":3, "color":"#7FD01F"}, 
            {"label":"Deciduous Broadleaf Forest", "value":4, "color":"#73EA69"}, 
            {"label":"Mixed Forests", "value":5, "color":"#4FCD88"}, 
            {"label":"Closed Shrublands", "value":6, "color":"#D37379"}, 
            {"label":"Open Shrublands", "value":7, "color":"#FAECA5"}, 
            {"label":"Woody Savannas", "value":8, "color":"#B8EA8E"}, 
            {"label":"Savannas", "value":9, "color":"#F8EA2C"}, 
            {"label":"Grasslands", "value":10, "color":"#F5C26C"}, 
            {"label":"Permanent Wetland", "value":11, "color":"#4287CE"}, 
            {"label":"Croplands", "value":12, "color":"#FBFF2D"}, 
            {"label":"Urban and Built-Up", "value":13, "color":"#F0001A"}, 
            {"label":"Cropland/Natural Vegetation Mosaic", "value":14, "color":"#8E9017"}, 
            {"label":"Snow and Ice", "value":15, "color":"#FBDCD4"}, 
            {"label":"Barren or Sparsely Vegetated", "value":16, "color":"#BDBDBD"}
          ],
            '''
            legend = []
            for idx, val in enumerate(color_list):
                legend.append({'label':label_list[idx], 'value':int(value_list[idx]), 'color': val})
            print(json.dumps(legend))
        elif method == 'legend-type':
            print('discrete')

usage = '''
USAGE
    main.py [method] [file]
        main.py legend [qmlfile_path]
        main.py colormap [qmlfile_path]
        main.py legend-type [qmlfile_path]

    main.py [method] noqml [min-value] [max-value]
'''


if __name__ == '__main__':
    num_args = len(sys.argv)
    if num_args < 2:
        print(usage, file = sys.stderr)
        exit(0)
    main()