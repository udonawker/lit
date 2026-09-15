1. VSCodeの設定画面を開きます（Ctrl + , またはメニューの歯車アイコン）。
1. 右上のドキュメントアイコン（JSONファイルを開く）をクリックして settings.json を開きます。
1. 以下のコードを追加します。

```
"plantuml.commandArgs": [
    "-DPLANTUML_LIMIT_SIZE=8192"
]
```
