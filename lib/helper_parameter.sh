#!/usr/bin/env bash
helper_parameter(){
    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"
    case $key in
        -t|--type)
        DATASET_TYPE="$2"
        shift 
        shift 
        ;;
        -q|--qml)
        QML_FILE="$2"
        shift # past argument
        shift # past value
        ;;
        -d|--dir)
        DATASET_DIR="$2"
        shift 
        shift 
        ;;
        -u|--structure)
        DATASET_DIR_STRUCTURE="$2"
        shift 
        shift 
        ;;
        -s|--start-time)
        START_TIME="$2"
        shift 
        shift 
        ;;
        -e|--end-time)
        END_TIME="$2"
        shift 
        shift 
        ;;
        -l|--layer-name)
        LAYER_NAME="$2"
        shift
        shift
        ;;
        -o|--output)
        DATASET_NAME="$2"
        shift
        shift
        ;;
        --target-mbtiles-path)
        TARGET_MBTILES_PATH="$2"
        shift
        shift
        ;;
        --target-json-path)
        TARGET_JSON_PATH="$2"
        shift
        shift
        ;;
        --server)
        TILESEVER_PROG="$2"
        shift
        shift
        ;;
        --port)
        TILESEVER_PORT="$2"
        shift
        shift
        ;;
        --bind)
        TILESEVER_BIND="$2"
        shift
        shift
        ;;
        --dev-mode-off)
        DEV_MODE=NO
        shift
        ;;
        --without-website)
        NO_WEBSITE_UPDATE=YES
        shift 
        ;;
        --with-quality-assessment)
        WITH_QUALITIY_ASSESSMENT=YES
        shift
        ;;
        -v|--version)
        echo "$VERSION"
        exit 0
        ;;
        -h|--help)
        echo "$USAGE"
        exit 0
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift 
        ;;
    esac
    done

    set -- "${POSITIONAL[@]}" # restore positional parameters
    DATAFILE_PATH="$1"
    # -- for no more flags, [@] reset all parameters
}
