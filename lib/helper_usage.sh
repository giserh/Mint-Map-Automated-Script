#!/usr/bin/env bash
helper_usage(){
    read -r -d '' USAGE  << __EOF__
    USAGE:  mintcast [OPTIONS] filename      
            filename is optional if dir is passed in.

            -t, --type
                --type nc|tiff|tiled|zip
            -q, --qml
                --qml qml_file_path
            -d, --dir
                --dir data
            -u, --structure
                --structure "{year}/{month}/{day}/*.zip"
            -s, --start-time
                -s "2018 05 01"
            -e, --end-time
                -e "2018 06 01"
            -l, --layer-name
                -l landuse
                -l "path_to_json/layers.json"
            --target-mbtiles-dir
                The directory stores *.mbtiles and config.json
            --target-json-dir
                The directory stores landuse.json
            --server
                --server "path_to_tileserver/bin/tileserver-gl"
                Use to start tileserver or TileStache
            --port
                Server port
                Default is 8082
            --bind
                Server IP
                Default is 0.0.0.0
            --without-website
                If sets, json file won't upload to CKAN
            --dev-mode-off
                Default is dev mode
                    Generate all files in dist/
                    Won't restart tileserver
                    Don't need pass --target-mbtiles-path, --target-json-path, --server, --port, --bind, --without-website
            -v,--version
__EOF__
}