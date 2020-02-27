#!/bin/bash

function peco_find_dir() {
    local DIR="."
    
    while DIR="$(find ${DIR} -maxdepth 1 -type d | sed -e 's;^\./;;' | grep -v "^\.$" | sort | peco)"; do
        if [ -z "${DIR}" ]; then
            break;
        fi  
        #echo -n "${DIR} (n/c)"; IFS= read -r -n1 -s char;
        #echo -en "\r"
        IFS= read -r -n1 -s char;
        case ${char} in
        n)  
            ;;  
        c|$'\0a') 
            break;;
        *)  
            echo ""
            return
        esac
    done
    
    echo ${DIR}
}
GET_DIR="$(peco_find_dir)"
echo "GET_DIR=${GET_DIR}"
