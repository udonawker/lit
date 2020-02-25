<pre>
$ echo -n "aaa"; sleep 2; echo -en "\r"
$ 
</pre>
<pre>
function peco_find_dir() {
    local DIR="."
    
    while DIR="$(find ${DIR} -maxdepth 1 -type d | sed -e 's;^\./;;' | grep -v "^\.$" | sort | peco); echo -n "${DIR} (n/c)"; IFS= read -r -n1 -s char; do
        echo -en "\r"
        case ${char} in
        n) 
            ;;
        c) 
            break;;
        *) 
            exit 0
        esac
    done
    
    cd ${DIR}
}
</pre>
