```
あわせて冒頭に
set -euo pipefail
と書いておくこと、と📝
ashishb.net/all/the-first-…
setのオプションの意味は
-e : コマンドでエラーが発生したらスクリプト終了
-u : 未定義変数が使用されたらスクリプト終了
-o pipefail : パイプ実行でエラー発生時、最初に失敗したコマンドの終了ステータスを返す
```

## [The first two statements of your BASH script should be…](https://ashishb.net/all/the-first-two-statements-of-your-bash-script-should-be/)
