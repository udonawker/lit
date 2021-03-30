<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false}

<!-- code_chunk_output -->

- [1. MSYS2とMinGW-w64の関係](#1-msys2とmingw-w64の関係)
- [2. インストール](#2-インストール)
- [3. パッケージの更新](#3-パッケージの更新)
- [4. MSYS2以外からのパッケージの利用](#4-msys2以外からのパッケージの利用)
- [5. 参考](#5-参考)
- [6. プロキシ設定](#6-プロキシ設定)
- [7. msys2からcl.exeを呼び出す](#7-msys2からclexeを呼び出す)

<!-- /code_chunk_output -->

[MSYS2](https://sites.google.com/site/toriaezuzakki/msys2?tmpl=%2Fsystem%2Fapp%2Ftemplates%2Fprint%2F)<br>
[MSYS2/MinGW-w64 (64bit/32bit) インストール手順 メモ](https://gist.github.com/Hamayama/eb4b4824ada3ac71beee0c9bb5fa546d) <br>

## 1. MSYS2とMinGW-w64の関係
* MSYS2はPOSIXシェル環境を提供するもの
* MinGW-w64はWindows用のGNU開発環境を提供するもの
と全然別物です。実際、MinGW-w64単独での導入も可能です。その場合は、普通のWindowsアプリケーションと同様に、コマンドプロンプトからの利用が可能です。<br>
ただ、実際にはMSYS2とセットでMinGW-w64を利用することが多いのは、パッケージのインストールにMSYS2のパッケージ管理(pacman)を利用するのが便利だからです。<br>
<br>
MSYS2をインストールすると、(64bitの場合)下記の3つのシェルがインストールされます。<br>
* MSYS2 Shell
* MinGW-w64 Win32 Shell
* MinGW-w64 Win64 Shell

これらの違いはパスの設定です。MSYS2 Shellを基本として、MinGW-w64 Win32 Shellはそれに/mingw32/binが追加されており、MinGW-w64 Win64 Shellは/mingw64/binが追加されています。<br>
パッケージのインストールや更新等は、どのシェルで実行しても構いません。ただ、そのパッケージがインストールされるディレクトリによって、実行可能なシェルとそうでないシェルに分かれます。<br>
例えば、パッケージmingw-w64-x86_64-gccはインストールすると/mingw64/binにインストールされます。そのため、MSYS2 Shellでインストールを実施しても、実行可能なのはパスが設定されているMinGW-w64 Win64 Shellからのみ、ということになります。<br>

## 2. インストール
[公式サイト](https://sourceforge.net/projects/msys2/)からインストーラをダウンロードし、実行します。
パッケージの場所は下記の通りです。<br>

[32-bit版](http://sourceforge.net/projects/msys2/files/Base/i686/)<br>
[64-bit版](http://sourceforge.net/projects/msys2/files/Base/x86_64/)<br>

インストールが完了すると、ダイアログで「MSYS2 64bit を実行中」というチェックボックスが現れますが多分「実行する」の誤訳かと。チェックONのまま完了すればMSYS2 Shellが
起動されます。<br>
通常は引き続きMSYS2 Shellで環境の更新を実施するので、ONのまま完了します。<br>

## 3. パッケージの更新
インストーラのリリース後に更新された各種パッケージを最新にしておきます。<br>
リリースが最近なら既に最新なので、下記手順を踏んでも、更新されること無く終了します。<br>

__(1回目の更新)__ MSYS2 Shellを再起動後、コマンドpacman -Syuを実行します。<br>
これは1回目の更新で、後でもう一度実施する必要があります。<br>
完了してもプロンプトに復帰しないので、ウィンドウを閉じて終了させます。<br>
```
$ pacman -Syu

...

警告: terminate MSYS2 without returning to shell and check for updates again
警告: for example close your terminal window instead of calling exit
(完了)
```

__(2回目の更新)__ MSYS2 Shellを再起動後、コマンドpacman -Syuを実行します。<br>
```
$ pacman -Syu
```

## 4. MSYS2以外からのパッケージの利用
但し、インストール先をWindowsの環境変数PATHに設定してしまうと、同じDLLを利用する、MSYS2以外でインストールしたアプリケーション(Git for WindowsやGIMP for Windows等)が誤動作を起こす可能性があります。<br>

この辺の不安を無くすために、コマンドsetlocalを用いたバッチファイルを組んで利用するのをオススメします。<br>

Win64の場合<br>
```
@echo off
setlocal

set MSYS2_HOME=C:\msys64
set PATH=%MSYS2_HOME%\mingw64\bin;%MSYS2_HOME%\usr\local\bin;%MSYS2_HOME%\usr\bin;%MSYS2_HOME%\bin;%PATH%

(実行するコマンド)

endlocal
```

## 5. 参考
[MSYS2でMinGW環境整備(1) - 行き先なし](http://arithmeticoverflow.blog.fc2.com/blog-entry-32.html)
[MSYS2を試してみる - kashiの日記](http://verifiedby.me/adiary/055)
[MSYS2における正しいパッケージの更新方法 - Qiita](http://qiita.com/k-takata/items/373ec7f23d5d7541f982)
[MSYS2 installation - Wiki - MSYS2のIII. Updating packages]()
[Mingw-w64/MSYS2 を入れなくても Git for Windows で間に合うみたい - 檜山正幸のキマイラ飼育記](http://d.hatena.ne.jp/m-hiyama/20151013/1444704189)
[MSYS2 で PATH が引き継がれない - めもらんだむ](http://chirimenmonster.github.io/2016/05/09/msys2-path.html)

## 6. プロキシ設定
[msys2 + pacmanをproxy環境で使う](https://nantonaku-shiawase.hatenablog.com/entry/2014/10/11/163342)

`C:\msys64\etc\profile.d` 配下に `proxy.sh` を作成し以下を記述
```
export http_proxy=http://proxy.co.jp:8080
export https_proxy=http://proxy.co.jp:8080
export ftp_proxy=http://proxy.co.jp:8080
export HTTP_PROXY=http://proxy.co.jp:8080
export HTTPS_PROXY=http://proxy.co.jp:8080
export FTP_PROXY=http://proxy.co.jp:8080
export no_proxy="localhost,127.0.0.1"
export NO_PROXY="localhost,127.0.0.1"
```

## 7. msys2からcl.exeを呼び出す
[msys2からcl.exeを呼び出す(OpenH264のmake)](https://teratail.com/questions/156771)

`Developer Command Prompt for VS 201*`を起動して`set MSYS2_PATH_TYPE=inherit`を実行
msys2のフォルダに移動して、`mingw64.exe`なりを実行

