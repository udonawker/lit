## [bash/zshでhistoryファイル以外のファイルに実行コマンドやPWD、タイムスタンプを記録する](https://orebibou.com/ja/home/202001/20200101_001/)

### 2. accept-lineを置き換えて処理してみる(成功)
#### 2-1. bashの場合
以下の内容をbashrcに記述することで、~/bash_history_$$.logに実行コマンドと時刻、カレントディレクトリが記録される。<br>

```
function __accept-line() {
  if [ ! ${#READLINE_LINE} -eq 0 ]; then
    local log_file=~/bash_history_$$.log

    # mkdir
    mkdir -p ${log_dir}

    # logファイルへコマンドの出力
    date "+TimeStamp: %Y-%m-%d %H:%M:%S" >>${log_file}
    echo "CurrentDir: ${PWD}" >>${log_file}
    echo "Command: $READLINE_LINE" >>${log_file}
    echo "==========" >>${log_file}
  fi
}

# \C-mのキーバインドを変更する
bind -x '"\1299": __accept-line'
bind '"\1298": accept-line'
bind '"\C-m": "\1299\1298"'
```

#### 2-2. zshの場合
zshの場合はこちら。 こちらも同様にzshrcに記載することで~/zsh_history_$$.logにその内容が記録される。<br>
```
__accept-line() {
    # BUFFERのサイズに応じて処理を切り替える
    if [ ! ${#BUFFER} -eq 0 ];then
        local log_file="zsh_history$$.log"

        # mkdir
        mkdir -p ${log_dir}

        # logファイルへコマンドの出力
        date "+TimeStamp: %Y-%m-%d %H:%M:%S" >>${log_file}
        echo "CurrentDir: ${PWD}" >>${log_file}
        echo "Command: $READLINE_LINE" >>${log_file}
        echo "==========" >>${log_file}
    fi

    # accept-lineを実行
    zle .accept-line
}
zle -N accept-line __accept-line
```
