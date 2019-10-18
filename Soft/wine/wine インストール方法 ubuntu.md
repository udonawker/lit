[Wine 3.0（安定版）インストール方法](http://moebuntu.blog48.fc2.com/blog-entry-1138.html) <br/>
[Linux上でWindowsのソフトを使う。](https://mongonta.com/f273-howto-install-wine-to-ubuntu/) <br/>
[Ubuntu 18.04にWineをインストールし、文字化け(アルファベットが豆腐)を解消する](https://symfoware.blog.fc2.com/blog-entry-2151.html) <br/>

## インストール

Ubuntu 14.04、16.04、17.10とその派生に対応です。端末（Ctrl+Alt+T）を開いて以下を入力適用すればOKです。（Terminal~$）<br/>

<pre>
wget -nc https://dl.winehq.org/wine-builds/Release.key && sudo apt-key add Release.key
sudo apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
sudo apt-get update
sudo apt-get install --install-recommends winehq-stable
</pre>

※Mint 18.x（17.x）の場合上記2行目は「sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main'」（17.xの場合はxenialをtrustyとする）にする必要があるそうです。<br/>

<br/>
もし依存関係の問題（エラーが表示されインストールに失敗した場合）が出た場合は以下のコマンドを試してみましょう。<br/>
<pre>
sudo aptitude install winehq-stable
</pre>

## winetricksインストール(make)

makeするにはbuild-essential、実行するときにcabextractが必要です。

<pre>
sudo apt-get install build-essential cabextract
</pre>

Ubuntuからインストールできるパッケージは古いためWinetricksはgithubからダウンロードします。

<pre>
wget https://github.com/Winetricks/winetricks/archive/20181203.tar.gz
tar xvf 20181203.tar.gz
cd winetricks-20181203
sudo make install
</pre>

## 設定画面

Wineの設定画面は以下のコマンドで出ます。<br/>
上記同様端末（Ctrl+Alt+T）を開いて以下を入力適用すればOKです。（Terminal~$）<br/>

<pre>
winecfg
</pre>

### ★補足 文字化けについて
winecfgを起動するとなぜか日本語は表示されるのに、英語が表示されません。<br/>
英語でいい場合は英語のインストーラーを使えば問題ありません。<br/>
winecfgを起動する時は「LANG=C winecfg」<br/>
wineを起動するときは「LANG=C wine」<br/>
という風に「LANG=C」を使えば英語表記で使えます。<br/>
フォントをインストールするとかなり大きなディスク容量を消費します。<br/>

## Windowsのインストーラーを起動

wineのインストールが終わったら、入れたいWindowsのインストーラーを起動します。<br/>
exeとmsiで起動コマンドが異なります。<br/>
<br/>

- exeのインストーラー
<pre>
wine /path/to/setup.exe
</pre>

- msiのインストーラー
<pre>
wine msiexec /i /path/to/setup.msi
</pre>

#### 補足
WineのCドライブはLinux上から見ると「~/.wine/drive_c」となる

<pre>
C:\Program Files\ → ~/.wine/drive_c/Program\ Files/
C:\Program Files (x86)\  → ~/.wine/drive_c/Program\ Files\ \(x86\)/
</pre>

## インストール後の起動方法

コマンドラインからexeを呼びます。<br/>

<pre>
wine ~/.wine/drive_c/Program\ Files\ \(x86\)/test.exe
</pre>
