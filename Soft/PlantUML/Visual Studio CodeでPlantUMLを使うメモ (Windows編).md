## [Visual Studio CodeでPlantUMLを使うメモ (Windows編).md](https://gist.github.com/yoggy/bd68b3f1f55dbd742bea71424ca66564)

# Visual Studio CodeでPlantUMLを使うメモ (Windows編).md

## PlantUMLとは？
テキストベースの独自の記述言語を使って、UML図を描くことができるツール。

  - http://plantuml.com/ja/

ユースケース図、クラス図、シーケンス図、アクティビティ図などを描くことが可能。

## Graphvizのインストール
PlantUMLはdotを使って図を作成するので、あらかじめGraphvizをインストールしておく必要がある。

以下URLから、stable版のインストーラをダウンロード＆インストールする。

  - https://www.graphviz.org/download/

## Javaのインストール
OpenJDKを使う場合はこちらからダウンロード。

  - http://jdk.java.net/

## 環境変数の設定
まず、dotコマンドが使えるように環境変数PATHに以下のパスを追加しておく。(デフォルトインストールの場合)

  - C:\Program Files (x86)\Graphviz2.38\bin

また、PlantUMLはJavaを使うため、java.exeのパスも通しておくこと。

あと、環境変数PLANTUML_LIMIT_SIZE=8192を設定しておく。([参考URL](http://plantuml.com/ja/faq))
これはPlantUMLで大きな図を描くと途切れてしまう対策。

## Visual Studio Code用PlantUMLのインストール
Visual Studio Codeで以下の機能拡張をインストールする。

  - PlantUML
  - https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml

メモ : PlantUMLの公式サイトではplantuml.jarが配布されているが、この機能拡張にはplantuml.jarが同梱されているため、Visual Studio CodeからPlantUMLを使う場合は、PlantUMLを別途インストールする必要はない。

## Visual Studio Code用PlantUMLの使い方
Visual Studio Codeファイルの拡張子が、.wsd, .pu, .puml, .plantuml, .iuml のファイルを開いているときに、PlantUMLの機能を使うことができる。

### ライブプレビュー
以下の内容を記述して、ファイル名test.plantmlで保存する。

    @startuml
    title テスト用クラス図
    skinparam dpi 150
    
    ' クラスAの定義
    class A {
      +string field1
      +void method1()
    }
    note right of A {
      これが基本のクラス
    }
    
    ' クラス間の関係
    A <|-- B : 継承
    A <|-- C : 継承
    @enduml

次にctrl+shift+Pを押してコマンドパレットを表示し、" PlantUML: Preview Current Diagram"を選ぶと、test.plantumlのプレビューが表示される。

  - <img src="https://i.gyazo.com/55abe69a6d3cada05bb28194be2525a2.png" width="50%">
  - <img src="https://i.gyazo.com/397abe8a255198b4da30c6b2b415f422.png"  width="50%">

プレビューはファイルをセーブしたときに更新される。

### エクスポート
ctrl+shift+Pを押してコマンドパレットを表示し、" PlantUML: Export Current Diagram"を選ぶ。

  - <img src="https://i.gyazo.com/3b502dc4d176e374e03cf5396283bab7.png" width="50%">

次に、ファイルフォーマットを選択する。今回はpngを指定する。

  - <img src="https://i.gyazo.com/a5efcc655fdb2fe37596f01d319e2e40.png" width="50%">

エクスポートが完了すると、次のポップアップが表示される。

  - <img src="https://i.gyazo.com/344bfc31ba4aa5e21113388b751e200d.png" width="50%">

"View Report"のボタンを押すと、OUTPUTビューが表示され、ファイルの出力先を確認することができる。
(test.plantumlと同じディレクトリにtestディレクトリが作成され、その中に出力ファイルが格納される)
