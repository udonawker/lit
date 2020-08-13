参照 [Visual Studio Code で UML を描こう！](https://qiita.com/couzie/items/9dedb834c5aff09ea7b2)<br/>

## PlantUML とは

[PlantUML](http://plantuml.com/) は、以下のような図をテキストで素早く描くためのオープンソースプロジェクトです。<br/>

- シーケンス図 / Sequence diagram
- ユースケース図 / Usecase diagram
- クラス図 / Class diagram
- アクティビティ図 / Activity diagram
- コンポーネント図 / Component diagram
- 状態遷移図 / State diagram
- オブジェクト図 / Object diagram

## 環境

下記の環境で動作確認しました。<br/>

- Windows 10 Pro (64bit)
- Visual Studio Code 1.11
- Java SE Runtime Environment 8 Update 121
- Graphviz 2.38
- PlantUML 1.4.0 (plugin)

## セットアップ

### Visual Studio Code のインストール

1. [Visual Studio Code を開く](https://code.visualstudio.com/)
1. [Download for Windows] を押してインストーラーをダウンロードする
1. ダウンロードしたインストーラーを実行する

    - 例）VSCodeSetup-1.11.1.exe

### PlantUML のセットアップ

#### 1. Java のインストール

PlantUML の実行には、Javaの実行環境が必要となります。<br/>

1. [java.com](https://java.com/ja/) を開く
1. [無料Javaのダウンロード]ボタンを押す
1. [同意して無料ダウンロードを開始]を押し、インストーラーをダウンロードする
1. ダウンロードしたインストーラーを実行する

    - JavaSetup8u121.exe

#### 2. Graphviz のインストール

PlantUML が UML を描画するために使用しているソフトウェアです。<br/>

1. [Graphviz - Graph Visualization Software](http://www.graphviz.org/) を開く
1. 左側のバーから [Download](http://www.graphviz.org/Download.php) を開く
1. License ページの末尾にある[Agree]を押す
1. Download ページの Windows の Stable and development Windows Install packages をクリックする
1. MSIファイルを選択してインストーラーをダウンロードする
1. ダウンロードしたインストーラーを実行する

    - graphviz-2.38.msi

> インストール先を変更した場合には、環境変数"GRAPHVIZ_DOT"でパスを指定する必要があるそうです。

#### 3. Visual Studio Marketplace で PlantUML をインストールします。

1. Visual Studio Code を起動する
1. "**Ctrl + P**" と入力して、Quick Open を開く
1. Quick Open に **ext install plantuml** と入力して、Enter キーを押す

![1](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F93531%2Ff30feab7-2d5b-ab03-fa6b-89d70ae8f5e5.png?ixlib=rb-1.2.2&auto=compress%2Cformat&gif-q=60&w=1400&fit=max&s=626ecc141e7b12be3de21f8abefca1cf) <br/>

4. 検索結果から **PlantUML** を選択し、[インストール]を押す

![2](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F93531%2Fff887377-5789-936a-a628-c33149e3b5d6.png?ixlib=rb-1.2.2&auto=compress%2Cformat&gif-q=60&w=1400&fit=max&s=159574494e320b50a82560e087c68957) <br/>

5. インストール完了後に[再度読み込む]を押して Visual Studio Code を再起動する

### 動作確認

#### 1. プレビュー表示

1. Visual Studio Code を起動する
1. 拡張子 .pu で新規ファイルを作成する
1. ファイルに以下を入力し、"Alt + D"でプレビューを表示する

test.pu<br/>
<pre>
@startuml
title シーケンス図
アリス -> ボブ: リクエスト
ボブ --> アリス: レスポンス
@enduml
</pre>

![3](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F93531%2F74a37139-ea56-e725-abc2-885a79c68ed3.png?ixlib=rb-1.2.2&auto=compress%2Cformat&gif-q=60&w=1400&fit=max&s=d5da65aa61d9cfd425acf4c0eaadb52d) <br/>

#### 2. 画像ファイルとして出力

1. "**Ctrl + Shift + P**" でコマンドパレットを開く
1. **PlantUML: Export Current Diagram** と入力する

![4](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F93531%2F5a981d89-5033-26f4-b1ad-b1feaf4a644e.png?ixlib=rb-1.2.2&auto=compress%2Cformat&gif-q=60&w=1400&fit=max&s=fbe9644b5e74100ae16489595ce4f557) <br/>

3. **png, svg, eps, pdf, vdx, xmi, scxml, html** から出力形式を選択する

![5](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F93531%2F543d1d83-7226-27cf-5864-f234b62aca26.png?ixlib=rb-1.2.2&auto=compress%2Cformat&gif-q=60&w=1400&fit=max&s=b72ca07a8d20f64ab3b377782ec80177) <br/>

PNGファイルとして出力した時のディレクトリ構成は、以下のようになります。<br/>

ディレクトリ構成
<pre>
 test.pu
 test/
     シーケンス図.png
</pre>

出力結果のPNGファイルは以下のようになります。<br/>

![6](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F93531%2F213753b8-fb0e-a5de-470e-1c95f3a1db01.png?ixlib=rb-1.2.2&auto=compress%2Cformat&gif-q=60&s=8dbaf5ff24d13173464360522380b106) <br/>

## PlantUML言語リファレンス

PlantUMLの文法は、"PlantUML Language Reference Guide"としてPDFファイルが提供されています。<br/>

1. http://plantuml.com/download を開く
1. PlantUML Language Reference Guide にある日本国旗を選択する
1. "PlantUML_Language_Reference_Guide_JA.pdf"がダウンロードされる

なお、plantuml.com でも同様の説明がありますが、広告表示が鬱陶しいため、PDFファイルの方が読みやすいです。<br/>

## 参考情報

- [PlantUML](http://plantuml.com/)
- [PlantUML - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml)
- [Visual Studio Codeで自由自在にUMLを描こう](http://blog.okazuki.jp/entry/2016/09/01/215508)
