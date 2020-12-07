# Enable color support of ls and also add handy aliases
#if [ -x /usr/bin/dircolors ]; then
#    alias ls='ls --color=auto'
#    #alias dir='dir --color=auto'
#    #alias vdir='vdir --color=auto'
#
#    alias grep='grep --color=auto'
#    alias fgrep='fgrep --color=auto'
#    alias egrep='egrep --color=auto'
#fi

# some more ls aliases
#alias ll='ls -alF'
#alias la='ls -A'
#alias l='ls -CF'
#alias lh='ls -alFh'

#ENHANCD_COMMAND=ecd; export ENHANCD_COMMAND
ENHANCD_HYPHEN_ARG="-ls"
ENHANCD_HYPHEN_NUM=64
ENHANCD_DOT_ARG="-up"

### After that custom settings
# Disable Ctrl + S
if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi

# enhancd init
if [ -f ~/tools/enhancd-master/init.sh ]; then
    source ~/tools/enhancd-master/init.sh
fi


#export PATH=~/local/bin:"$PATH"
#export VIMRUNTIME="$HOME/local/src/vim/runtime"

#export PS1='\[\e[30;47m\]\t\[\e[37;46m\]|\[\e[30m\]\W\[\e[36;49m\]$\[\e[0m\] '
export PS1='\[\e[30;47m\]\D{%F %T}\[\e[37;46m\]\[\e[30m\]|\W\[\e[36;49m\]$\[\e[0m\] '

alias xp='xdg-open'
alias clip='xclip'
alias clipx='xclip -selection c'
alias gitlog='git log --oneline --pretty=format:'\''%h [%cd] %d %s <%an>'\'' --date=format:'\''%Y/%m/%d %H:%M:%S'\'''
alias lsl='ls -lFh'
alias df='df -Th'
#alias cdj='cd $(ls -lt | grep ^d | head -1 | awk  '\''{print $9}'\'' | tr -d '\''\n'\'')'
alias cdl='cd $(ls -lt | grep ^d | head -1 | awk  '\''{for(i=9;i<NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}'\'' | tr -d '\''\n'\'')'
alias pwdclip='pwd | tr -d '\''\n'\'' | xclip'
alias pwdclipx='pwd | tr -d '\''\n'\'' | xclip -selection c'
alias brc='. ~/.bashrc'
alias vihrc='vi ~/.hrc'
alias viewhrc='view ~/.hrc'
alias l1='ls -1'

function isNumericString(){
    while [ "$1" != "" ]
    do
        # 半角数字判定
        if ! expr "${1}" : '^[0-9]*$' > /dev/null ; then
           # Not numeric string
           return 1
        fi
        
        shift
    done
    
    return 0
}

function isValidLsOption1() {
    local CHAR=""
    echo $1 | grep -o . | while read CHAR; do
        if [[ ! $CHAR =~ [aAbBcfFgGhHiklLnNopqQrsStuUvXZ] ]] ;
        then
            # while内別プロセスのためexit
            exit 1
        fi
    done
    
    if [ $? -eq 1 ]; then
        return 1
    fi
    
    return 0
}

function isValidLsOption2() {
    local CHAR=""
    echo $1 | grep -o . | while read CHAR; do
        if [[ ! $CHAR =~ [aAbBcfFgGhHiklLnNopqQrsStuUvXZ] ]] ;
        then
            exit 1
        fi
    done
    
    if [ $? -eq 1 ]; then
        return 1
    fi
    
    return 0
}

function checkNumAndLsOption1() {
    case $# in
      3)
        if ! isValidLsOption1 $3 ; then
            return 1
        fi
        ;&
      2)
        if ! isNumericString $2 ; then
            return 1
        fi
        ;;
      *)
        return 1
        ;;
    esac

    return 0
}

function checkNumAndLsOption2() {
    case $# in
      3)
        if ! isValidLsOption2 $3 ; then
            return 1
        fi
        ;&
      2)
        if ! isNumericString $2 ; then
            return 1
        fi
        ;;
      *)
        return 1
        ;;
    esac

    return 0
}

function checkLsOption1() {
    case $# in
      1)
        ;;
      2)
        if ! isValidLsOption1 $2 ; then
            return 1
        fi
        ;;
      *)
        return 1
        ;;
    esac

    return 0
}
function usage_echox() {
    echo "$1 dir number [ls option(aAbBcfFhiklnNpqQrsStuUvX)]"
}

function usage_lnx() {
    echo "$1 dir [ls option(aAbBcfFgGhHiklLnNopqQrsStuUvXZ)]"
}

function lh() {
    case $# in
      0)
        ;;
      2)
        if ! isValidLsOption1 $2 ; then
            return 1
        fi
        ;&
      1)
        ;;
      *)
        return 1
        ;;
    esac

    #command ls --color=auto -lFh$2 $1
    command ls --color=auto -lh$2 $1
}

function lg() {
    if [ $# -ne 1 ]; then
        echo "lg PATTERN"
        return 1
    fi

    command ls -1 | grep ${1}
}

function echoa() {
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox echoa #${0##*/}
        return
    fi
    
    command ls -l$3 $1 | grep ^[-dl] | awk 'NR=='"$2"'' | awk '{for(i=9;i<NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}' | tr -d '\n'
    # awk '{print $9}'だとファイル名にスペースが含まれていると全部取れない
}

function echod() {
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox echoa #${0##*/}
        return
    fi

    command ls -l$3 $1 | grep ^d | awk 'NR=='"$2"'' | awk '{for(i=9;i<NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}' | tr -d '\n'
}
function echof() {
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox echof #${0##*/}
        return
    fi

    command ls -l$3 $1 | grep ^[-l] | awk 'NR=='"$2"'' | awk '{for(i=9;i<NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}' | tr -d '\n'
}

# cat -n == awk '$0 = NR OFS $0' == nl 
# command ls -lF$2 $1 | grep ^[d-l] | nl
# [d-l]だとd〜lの範囲を表してしまうため[-dl]とする
function lna() { # $1 = r,t
    if ! checkLsOption1 $@ ; then
        usage_lnx lna
        return
    fi

    command ls -lF$2 $1 | grep ^[-dl] | awk '{printf("%03d %s\t%2d\n", NR, $0, NR)}'
}

function lnd() { # $1 = r,t
    if ! checkLsOption1 $@ ; then
        usage_lnx lnd
        return
    fi

    command ls -lF$2 $1 | grep ^d | awk '{printf("%03d %s\t%2d\n", NR, $0, NR)}'
}

function lnf() { # $1 = r,t
    if ! checkLsOption1 $@ ; then
        usage_lnx lnf
        return
    fi

    command ls -lF$2 $1 | grep ^[-l] | awk '{printf("%03d %s\t%2d\n", NR, $0, NR)}'
}

function cdp() { # $1 = Number of levels
    local PARENT="../"
    local CDP=""
    local PDW=$(pwd)
    if [ $# -eq 0 ]; then
        CDP=$PARENT
    else
        if ! isNumericString $1 ; then
            echo "cdp [up directory num]"
            return
        fi
        for i in `seq $1`
        do
            CDP=${CDP}${PARENT}
        done
    fi
#    command echo "CDP=$CDP"
    command echo $PDW
    command cd $CDP; pwd
}

function mdcd() { # $1 = make directory
    if [ $# -eq 1 ]; then
        command mkdir -p "$1"
        command cd "$1"
    fi
}
function md() { # $1 = make directory
    if [ $# -eq 1 ]; then
        command mkdir -p "$1"
    fi
}

function cdn() { # $1 = ls list number $2 = r,t
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox cdn
        return
    fi

    command cd $1/$(ls -l$3 $1 | grep ^d | awk 'NR=='"$2"'' | awk '{print $9}' | tr -d '\n')
} 

function vif() {
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox cdn
        return
    fi

    command vi $1/$(ls -l$3 $1 | grep ^- | awk 'NR=='"$2"'' | awk '{print $9}' | tr -d '\n')
} 

function viewf() {
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox cdn
        return
    fi

    command view $1/$(ls -l$3 $1 | grep ^- | awk 'NR=='"$2"'' | awk '{print $9}' | tr -d '\n')
} 

function lessf() {
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox cdn
        return
    fi

    command less $1/$(ls -l$3 $1 | grep ^- | awk 'NR=='"$2"'' | awk '{print $9}' | tr -d '\n')
} 
function clipa() { # $1 = ls list number $2 = r,t
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox clipa
        return
    fi

    command ls -l$3 $1 | grep ^[d-] | awk 'NR=='"$2"'' | awk '{print $9}' | tr -d '\n' | xclip
}
function clipd() { # $1 = ls list number $2 = r,t
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox clipd
        return
    fi

    command ls -l$3 $1 | grep ^d | awk 'NR=='"$2"'' | awk '{print $9}' | tr -d '\n' | xclip
}
function clipf() { # $1 = ls list number $2 = r,t
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox clipf
        return
    fi

    command ls -l$3 $1 | grep ^- | awk 'NR=='"$2"'' | awk '{print $9}' | tr -d '\n' | xclip
} 
function clipxa() { # $1 = ls list number $2 = r,t
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox clipxa
        return
    fi

    command ls -l$3 $1 | grep ^[d-] | awk 'NR=='"$2"'' | awk '{print $9}' | tr -d '\n' | xclip -selection c
}
function clipxd() { # $1 = ls list number $2 = r,t
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox clipxd
        return
    fi

    command ls -l$3 $1 | grep ^d | awk 'NR=='"$2"'' | awk '{print $9}' | tr -d '\n' | xclip -selection c
}
function clipxf() { # $1 = ls list number $2 = r,t
    if ! checkNumAndLsOption2 $@ ; then
        usage_echox clipxf
        return
    fi

    command ls -l$3 $1 | grep ^- | awk 'NR=='"$2"'' | awk '{print $9}' | tr -d '\n' | xclip -selection c
}

function today() {
    command echo -n $(date +"%Y%m%d")
}

function current() {
    command echo -n $(date +"%Y%m%d_%H%M%S")
}

function pushp() {
    command pushd $(pwd)
}

function dirv() {
    command dirs -v
}

function treex() {
    command tree $1 --charset=C --si --du -D $2
}

function dush() {
    command du -sh $1
}

function glog() {
    command git log $@ --oneline --pretty=format:'%h [%cd] %d %s <%an>' --date=format:'%Y/%m/%d %H:%M:%S'
}

function ubar() {
    local UBAR=""
    local LENGTH=80
    for ((i = 0; i < $LENGTH; i++))
    do
        UBAR=${UBAR}"-"
    done
    echo -n $UBAR | xclip -selection c
}

function sbar() {
    local UBAR=""
    local LENGTH=40
    for ((i = 0; i < $LENGTH; i++))
    do
        UBAR=${UBAR}"■"
    done
    echo -n $UBAR | xclip -selection c
}
# ↓要peco
# カレントディレクトリ以下のディレクトリをpecoで絞り込む(1階層ずつ)
PECO_FOUND_DIR=""
PECO_FOUND_FILE=""

function peco_find_dir_n() {
    local DIR="."
    local FOUND_DIR=""

    if [ $# -ge 1 ]; then
        if [ -d "${1}" ]; then
            DIR="${1}" #DIR=ls -1pd "${1}"
        else
            return 1
        fi
    fi
    while FOUND_DIR="$(find "${DIR}" -maxdepth 1 -type d | sed -e 's;^\./;;' | grep -v "^\.$" | sort | peco)"; do
        if [ -z "${FOUND_DIR}" ]; then
            DIR=""
            break
        fi
        printf "%s (\e[1mc\e[monfirm/\e[1mp\e[mrevious/\e[1mn\e[mext/\e[1mq\e[muit)" "${FOUND_DIR}"
        IFS= read -r -n1 -s char;
        printf "\e[2K"
        echo -en "\r"
        case ${char} in
        p)          # previous
            DIR="$(dirname "${FOUND_DIR}")";;
        n)          # next
            DIR="${FOUND_DIR}";;
        c|$'\0a')   # comfirm(Enter)
            DIR="${FOUND_DIR}"
            break;;
        q|$'\e')    # quit(Escape)
            DIR=""
            break;;
        *)
        esac
    done

    PECO_FOUND_DIR="${DIR}"
}

# カレントディレクトリ以下のディレクトリをpecoで絞り込む
function peco_find_dir_all() {
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
            return
        esac
    done
    
    #DIR=$(echo "${DIR}" | sed -e 's/ /\\ /g' -e 's/(/\\(/g' -e 's/)/\\)/g' -e 's/\./\\./g')
    echo "${DIR}"
}
alias pfda="peco_find_dir_all"

# カレント(指定)ディレクトリ以下のディレクトリをpecoで絞り込んだ後に標準出力する(1階層ずつ)
function peco_find_dir() {
    peco_find_dir_n "${@}"
    if [ -n "${PECO_FOUND_DIR}" ]; then
        echo -n "${PECO_FOUND_DIR}"
    fi
    PECO_FOUND_DIR=""
}
alias pfd="peco_find_dir"

# カレント(指定)ディレクトリ以下のディレクトリをpecoで絞り込んだ後に移動する(1階層ずつ)
function peco_cd() {
    peco_find_dir_n "${@}"
    if [ -n "${PECO_FOUND_DIR}" ]; then
        cd "${PECO_FOUND_DIR}"
    fi
    PECO_FOUND_DIR=""
}
alias pcd="peco_cd"
# カレントディレクトリ以下のディレクトリをpecoで絞り込んだ後に移動する
function peco_cd_all() {
    local DIR="$(peco_find_dir_all)"
    if [ -n "${DIR}" ]; then
        cd "${DIR}"
    fi
}
alias pcda="peco_cd_all"

# カレント(指定)ディレクトリ以下のディレクトリをpecoで絞り込んだ後に ls する(1階層ずつ)
function peco_ls() {
    peco_find_dir_n "${1}"
    shift
    if [ -n "${PECO_FOUND_DIR}" ]; then
        echo "${PECO_FOUND_DIR}"
        ls "${@}" "${PECO_FOUND_DIR}"
    fi
    PECO_FOUND_DIR=""
}
alias pls="peco_ls"
# カレントディレクトリ以下のディレクトリをpecoで絞り込んだ後に ls する
function peco_ls_all() {
    local DIR="$(peco_find_dir_all)"
    if [ -n "${DIR}" ]; then
        echo "${DIR}"
        ls $@ "${DIR}"
    fi
}
alias plha="peco_ls_all"

# カレントディレクトリのPARENTディレクトリをpecoで絞り込んだ後に移動する
function peco_cd_parent() {
    local DIR="$(dirname $(pwd))"
    DIR=$(while [ "${DIR}" != "/" ]
    do
        echo "${DIR}"
        DIR="$(dirname ${DIR})"
    done | peco)
    if [ -n "${DIR}" ]; then
        cd "${DIR}"
    fi
}
alias pcdp="peco_cd_parent"

# enhancd のリストからディレクトリをpecoで絞り込んだ後に移動する
function select_enhancdlist_cd() {
    local DIR="$(cd -L | peco)"
    if [ -n "${DIR}" ]; then
        cd "${DIR}"
    fi
}
alias pcdl="select_enhancdlist_cd"

# カレントディレクトリ以下のファイルをpecoで絞り込む(1階層ずつ)
function peco_find_file_n() {
    local FILE="."
    local FOUND_FILE=""

    # 引数が1以上で引数$1がディレクトリで内場合はエラー終了
    if [ $# -ge 1 ]; then

        if [ -d "${1}" ]; then
            FILE="${1}" #DIR=ls -1pd "${1}"
        else
            return 1
        fi
    fi

    while FOUND_FILE="$(find "${FILE}" -maxdepth 1 | sed -e 's;^\./;;' | grep -v "^\.$" | sort | peco)"; do
        if [ -z "${FOUND_FILE}" ]; then
            FILE=""
            break
        fi
        printf "%s (\e[1mc\e[monfirm/\e[1mp\e[mrevious/\e[1mn\e[mext/\e[1mq\e[muit)" "${FOUND_FILE}"
        IFS= read -r -n1 -s char;
        printf "\e[2K"
        echo -en "\r"
        case ${char} in
        p)          # previous
            FILE="$(dirname "${FOUND_FILE}")";;
        n)          # next
            if [ -d "${FOUND_FILE}" ]; then
                FILE="${FOUND_FILE}"
            fi
            ;;
        c|$'\0a')   # comfirm(Enter)
            if [ -f "${FOUND_FILE}" ]; then
                FILE="${FOUND_FILE}"
                break
            fi
            ;;
        q|$'\e')    # quit(Escape)
            FILE=""
            break;;
        *)
            ;;
        esac
    done

    PECO_FOUND_FILE="${FILE}"
}

# カレントディレクトリ以下のファイルをpecoで絞り込む
function peco_find_file_all() {
    local MAXDEPTH=""

    if [ $# -eq 1 ]; then
        isNumericString $1 && {
            MAXDEPTH="-maxdepth ${1}"
        }
    fi

    local FILE="$(find . ${MAXDEPTH} -type f | sed -e 's;^\./;;' | peco)"
    echo ${FILE}
}
alias pffa="peco_find_file_all"

# カレント(指定)ディレクトリ以下のファイルをpecoで絞り込んだ後に標準出力する(1階層ずつ)
function peco_find_file() {
    peco_find_file_n "${@}"
    if [ -n "${PECO_FOUND_FILE}" ]; then
        echo -n "${PECO_FOUND_FILE}"
    fi
    PECO_FOUND_FILE=""
}
alias pff="peco_find_file"

# カレント(指定)ディレクトリ以下のファイルをpecoで絞り込んだ後に vim で開く(1階層ずつ)
function peco_vim() {
    peco_find_file_n "${@}"
    if [ -n "${PECO_FOUND_FILE}" ]; then
        vim "${PECO_FOUND_FILE}"
    fi
    PECO_FOUND_FILE=""
}
alias pvi="peco_vim"
# カレントディレクトリ以下のファイルをpecoで絞り込んだ後に vim で開く
function peco_vim_all() {
    local FILE="$(peco_find_file_all $@)"
    if [ -n "$FILE" ]; then
        vim "${FILE}"
    fi
}
alias pvia="peco_vim_all"

# カレント(指定)ディレクトリ以下のファイルをpecoで絞り込んだ後に view で開く(1階層ずつ)
function peco_view() {
    peco_find_file_n "${@}"
    if [ -n "${PECO_FOUND_FILE}" ]; then
        view "${PECO_FOUND_FILE}"
    fi
    PECO_FOUND_FILE=""
}
alias pview="peco_view"
# カレントディレクトリ以下のファイルをpecoで絞り込んだ後に view で開く
function peco_view_all() {
    local FILE="$(peco_find_file_all $@)"
    if [ -n "$FILE" ]; then
        view "${FILE}"
    fi
}
alias pviewa="peco_view_all"

# カレント(指定)ディレクトリ以下のファイルをpecoで絞り込んだ後に xdg-open で開く(1階層ずつ)
function peco_xdg_open() {
    peco_find_file_n "${@}"
    if [ -n "${PECO_FOUND_FILE}" ]; then
        xdg-open "${PECO_FOUND_FILE}"
    fi
    PECO_FOUND_FILE=""
}
alias popen="peco_xdg_open"
# カレントディレクトリ以下のファイルをpecoで絞り込んだ後に xdg-open で開く
function peco_xdg_open_all() {
    local FILE="$(peco_find_file_all $@)"
    if [ -n "$FILE" ]; then
        xdg-open "${FILE}"
    fi
}
alias popena="peco_xdg_open_all"

# HISTORY検索(Ctrl + r)をインクリメンタルサーチで行う
function peco_select_history() {
    local tac
    which gtac &> /dev/null && tac="gtac" || \
        which tac &> /dev/null && tac="tac" || \
        tac="tail -r"
    READLINE_LINE=$(HISTTIMEFORMAT= history | $tac | sed -e 's/^\s*[0-9]\+\s\+//' | awk '!a[$0]++' | peco --query "$READLINE_LINE")
    READLINE_POINT=${#READLINE_LINE}
}
bind -x '"\C-r": peco_select_history'
# ↑要peco
