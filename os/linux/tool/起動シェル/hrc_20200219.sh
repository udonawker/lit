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

### After that custom settings
# Disable Ctrl + S
if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi

#export PS1='\[\e[30;47m\]\t\[\e[37;46m\]|\[\e[30m\]\W\[\e[36;49m\]$\[\e[0m\] '
export PS1='\[\e[30;47m\]\D{%F %T}\[\e[37;46m\]\[\e[30m\]|\W\[\e[36;49m\]$\[\e[0m\] '

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

    command ls --color=auto -lFh$2 $1
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

# peco install 要
# fc コマンドでカレントディレクトリ以下のディレクトリを絞り込んだ後に移動する
function find_cd() {
    found=$(find . -type d | peco)
    if [ -n "$found" ]; then
        cd ${found}
    fi
}
alias fc="find_cd"
 
# fe コマンドでカレントディレクトリ以下のファイルを絞り込んだ後に vim で開く
function find_vim() {
    found=$(find . -type d | peco)
    if [ -n "$found" ]; then
        vim ${found}
    fi
}
alias fv="find_vim"
