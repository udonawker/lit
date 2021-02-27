## [並列でpingを実行するbash function](https://orebibou.com/ja/home/202010/20201015_001/)

たまに、雑にパラレルにpingを打ちたいということがあったので、そういうbash funcionを作った(だいぶ前に)。 pingの行頭にtimestampを付けて、かつ雑にブレース展開などで複数のipアドレスにpingを打ったりできるようにしている。<br>

```
# color code
export COLOR_RED=$'\E[0;31m'
export COLOR_GREEN=$'\E[0;32m'
export COLOR_ORANGE=$'\E[0;33m'
export COLOR_BLUE=$'\E[0;34m'
export COLOR_PURPLE=$'\E[0;35m'
export COLOR_CYAN=$'\E[0;36m'
export COLOR_LGRAY=$'\E[0;37m'
export COLOR_DGRAY=$'\E[1;30m'
export COLOR_LRED=$'\E[1;31m'
export COLOR_LGREEN=$'\E[1;32m'
export COLOR_YELLOW=$'\E[1;33m'
export COLOR_LBLUE=$'\E[1;34m'
export COLOR_LPURPLE=$'\E[1;35m'
export COLOR_LCYAN=$'\E[1;36m'
export COLOR_WHITE=$'\E[1;37m'
export COLOR_NONE=$'\E[0m'

# 標準入力で受け付けた行頭にタイムスタンプ(YYYY-MM-DD HH:MM:SS: )を付与する
ts() {
  # カラーコードの設定
  local COLOR_START
  local COLOR_END
  if [ -t 1 ]; then
    COLOR_START="${COLOR_YELLOW}"
    COLOR_END="${COLOR_NONE}"
  fi

  # perlで処理
  perl -lne '
      use POSIX "strftime";
      $t = strftime "'${COLOR_START}'%Y-%m-%d %H:%M:%S: '${COLOR_END}'", localtime;
      print($t,$_);
    '
}

# pingでタイムスタンプを頭につけるためのfunction
__pingfunc() {
  \ping ${*} | ts
}

# pingをaliasに置き換え
alias ping='__pingfunc'

# パラレルでpingを実行するためのfunction
pping() {
  # ローカル変数を宣言
  local port
  local num
  local timeout
  local sed
  local options

  # オプションの取得(p,n,m)
  while getopts p:n:m: OPT; do
    case $OPT in
    p)
      port="${OPTARG}"
      ;;
    n)
      num="${OPTARG}"
      ;;
    m)
      timeout="${OPTARG}"
      ;;
    esac
  done
  shift $((OPTIND - 1))

  # osに応じて変数の値を切り替える
  # ※ optionについても同様
  case ${OSTYPE} in
  darwin*)
    # 利用するsedを指定
    sed='gsed'
    ;;
  linux*)
    # 利用するsedを指定
    sed='sed'
    ;;
  esac

  # port指定の有無で処理を切り替え
  if [ -z "${port}" ]; then
    # port指定が無い場合、通常のping(icmp)を実行
    # optionの指定
    if [ -z "${port}" ]; then
      # timeoutの有無でタイムアウトの秒数を指定
      [ -n "${timeout}" ] && options="-W ${timeout} "

      # numの有無でカウント数を指定
      [ -n "${num}" ] && options=${options}"-c ${num} "
    fi

    echo "${@}" | fmt -1 |
      xargs -P "${#@}" -I@ -n 1 bash -c "
        ping ${options} @ | \
        ${sed} -u 's/^/@ :/;s/@/\x1b[32m&\x1b[0m/g'
      " 2>&1 |
      ts
  else
    # portが指定されている場合、curlなどを使って指定されたportへ疎通確認する
    # timeoutが指定されていない場合、2秒をデフォルトとして指定する
    [ -z "${timeout}" ] && timeout=2
    [ -z "${num}" ] && num=0

    echo "${@}" | fmt -1 |
      xargs -P "${#@}" -n1 -I@ bash -c "
        H=\$0;i=0;while :;do
          echo | curl -s -m ${timeout} telnet://\${H}:${port} 2>&1 >/dev/null \
            && echo \"\${H}:${port} ${COLOR_LGREEN}PING OK${COLOR_NONE}\" \
            || echo \"\${H}:${port} ${COLOR_RED}PING NG${COLOR_NONE}\";
          i=\$((i+1));
          [[ \$i -eq ${num} ]] && break;
          sleep 1;
        done
      " @ |
      ts
  fi
}
```
