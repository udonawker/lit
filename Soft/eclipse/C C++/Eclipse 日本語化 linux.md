## 日本語化プラグイン「Pleiades」をインストールする

### 1. Mardocプロジェクトの[ダウンロードページ](http://mergedoc.osdn.jp/)より Pleiades プラグイン（pleiades.zip）をダウンロードする。
- pleiades.zipをダウンロードし、解凍する

![1](Pleiades プラグイン・ダウンロード.png)<br/>

### 2.「Pleiades」の設定ファイルを上書きコピーする
- 解凍した「Pleiades」フォルダー内の「plugins」と「features」フォルダーと「eclipse.exe -clean.cmd」ファイルを、インストールしたEclipseのホームフォルダーにコピーする
- この操作をすべてのファイルとフォルダーに適用するにチェックをいれ、マージするをクリックする

![2](Pleiades プラグイン・内容.png)<br/>
![3](Pleiades プラグイン・コピーマージ.png)<br/>

### 3. 「eclipse.ini」ファイルを編集する

-Eclipseのホームフォルダー内のeclipse.iniを編集する
-最終行に以下の２行を追加する

<pre>
-Xverify:none
-javaagent:plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar
</pre>

![4](Pleiades eclipse_ini 編集.png)<br/>


## コマンドライン
<pre>
$ wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/build/stable/pleiades.zip
$ unzip pleiades.zip -d pleiades
$ cp -ru pleiades/*/ <eclipseの実行ファイルのあるディレクトリ>
$ cd <eclipseの実行ファイルのあるディレクトリ>
$ vim eclipse.ini
</pre>
