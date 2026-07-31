`PLANTUML_LIMIT_SIZE`は、PlantUMLで大きな図を出力する際の画像サイズ制限（デフォルト4096ピクセル）を拡張するためのJavaシステムプロパティ、または環境変数です。VSCodeの拡張機能（PlantUML）で大きな図が途切れる・表示されない問題を解消できます。<br>

## 設定方法
VSCodeの設定（settings.json）にJavaの起動引数として追加します。<br>
#### plantuml.commandArgs に -DPLANTUML_LIMIT_SIZE=16384 のように指定します。
```
"plantuml.commandArgs": [
    "-DPLANTUML_LIMIT_SIZE=16384"
]
```


## Windowsで設定
PlantUMLでは画像サイズが4096に制限されます（詳細）。この制限によって、少し大きなシーケンス図なんかを書こうとすると、画像が途中で切れてしまうことがある。<br>

この制限を回避するには、環境変数PLANTUML_LIMIT_SIZEを設定する必要がある。<br>
[コントロール パネル] > [システムとセキュリティ] > [システム] > [システムの詳細設定] > [詳細設定]タブ > [環境変数(N)...] > [新規(W)...]<br>
```
変数名:PLANTUML_LIMIT_SIZE
変数値:8192
```
※変数値は作成するUMLサイズに合わせて、適当な値を指定。<br>
