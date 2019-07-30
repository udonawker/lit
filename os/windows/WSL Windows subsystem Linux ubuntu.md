[Windows Subsystem for Linuxをインストールしてみよう！](https://qiita.com/Aruneko/items/c79810b0b015bebf30bb "Windows Subsystem for Linuxをインストールしてみよう！")<br/>

### gcc環境<br/>
<pre>
# sudo apt-get update
# sudo apt-get upgrade
# sudo apt-get install gcc
</pre>

もしくは

<pre>
# apt install build-essential
</pre>

<br/><br/>

### レポジトリを日本のサーバに切り替える
<pre>
$ sudo sed -i.org -e 's%http://.*.ubuntu.com%http://ftp.jaist.ac.jp/pub/Linux%g' /etc/apt/sources.list
</pre>

### WSL（Linux）でのマウント

mount -t drvfs ＜デバイス名＞ ＜マウントポイント＞<br/>
＜デバイス名＞ ： マウントしたいWindowsのローカルドライブ名やネットワーク共有リソースのUNCパス表記。E:やF:、\\server1\homesなど。「\」が含まれる場合は、全体をシングルクォートで囲むか、「\\」のようにエスケープする<br/>
＜マウントポイント＞ ： マウントしたボリュームを割り当てたいパス。/mnt/eや/mnt/shareなど。あらかじめ作成しておくこと<br/>
<pre>
mount -t drvfs '\\192.168.0.1\FILE_SERVER\' /mnt/share
</pre>
