#!/bin/bash
#!/bin/bash

function peco_find_dir() {
    local DIR="."

    while DIR="$(find ${DIR} -maxdepth 1 -type d | sed -e 's;^\./;;' | grep -v "^\.$" | sort | peco)"; do
        if [ -z "${DIR}" ]; then
            break;
        fi
        echo -n "${DIR} (n/c)"; IFS= read -r -n1 -s char;
        echo -en "\r"
        printf "\e[2K" # ANSIエスケープシーケンス チートシート
        #IFS= read -r -n1 -s char;
        case ${char} in
        n)
            ;;
        c|$'\0a')
            break;;
        *)
            return
        esac
    done

    #DIR=$(echo "${DIR}" | sed -e 's/ /\\ /g' -e 's/(/\\(/g' -e 's/)/\\)/g' -e 's/\./\\./g')
    echo "${DIR}"
}

function peco_find_dir_x() {
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
GET_DIR="$(peco_find_dir_x)"
echo "GET_DIR=${GET_DIR}"
