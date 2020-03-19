[windows 実行ファイルが32ビットか64ビットか確認する方法](https://qiita.com/oyan29/items/1f0b5d227765115b24f0)<br/>

## 1. dumpbin コマンドを使用する

【制約】<br/>
Visual Studio がインストールされている環境。<br/>
【手順】<br/>
１．スタートメニューの "Visual Studio Tools" から "Visual Studio コマンドプロンプト" を起動<br/>
２．dumpbin コマンドに /headers オプションをつけて実行<br/>
※ "machine" の情報で判断。<br/>
※ パイプでfindstrかmore に渡して必要な情報だけ表示させると分かりやすい。<br/>

### 32bits バイナリの場合
<pre>
dumpbin /headers easy_install.exe | findstr machine
             14C machine (x86)
                   32 bit word machine
</pre>

### 64bits バイナリの場合
<pre>
dumpbin /headers python.exe | findstr machine
            8664 machine (x64)
</pre>

## 2. バイナリエディタで PE ヘッダを解読する。

### 32bits バイナリの場合
0x80番地前後程度の先頭付近に存在するPEヘッダを探す。<br/>
以下のデータが存在すれば32bitsバイナリ。<br/>
<pre>
50 45 00 00 4C 01
</pre>

以下のデータが存在すれば64bitsバイナリ。<br/>
<pre>
50 45 00 00 64 86
</pre>
