## [bashデバッグTips](https://qiita.com/mashumashu/items/ee436b770806e8b8176f)

### trapコマンド
|sigspec|タイミング|
|:--|:--|
|EXIT|シェルがスクリプトを終了した|
|ERR|コマンド、シェル関数から0以外の終了ステータスが返された|
|DEBUG|シェルが各コマンド、算術、シェル関数の最初のコマンドの実行前|
|RETURN|source または . で実行されたシェル関数/スクリプトが終了した|

<pre>
#!/bin/bash

on_exit() {
    echo "Exit script"
}

#trap on_exit EXIT RETURN
trap on_exit EXIT
trap 'rc=$?; trap - EXIT; on_exit; exit $?' INT PIPE TERM

echo "Script start"
exit 0
</pre>
