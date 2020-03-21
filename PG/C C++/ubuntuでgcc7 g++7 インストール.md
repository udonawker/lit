[Ubuntuでc++17を試す。](https://qiita.com/kentaro1530/items/67ff764e3ba388c2b25e)<br/>

## gcc7の入手
[](https://askubuntu.com/questions/859256/how-to-install-gcc-7-or-clang-4-0)<br/>
の丸パクリです。要はリポジトリを足してインストール<br/>

<pre>
sudo add-apt-repository ppa:jonathonf/gcc-7.1
sudo apt update
sudo apt install gcc-7 g++-7
</pre>
小ネタですがapt-getの-getが必要なくなってます。repositoryがどうかは知りません。<br/>
-cacheも必要ありません。が、apt search "hoge" | xargs ~~~とかすると<br/>

<pre>
WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
</pre>
と安定的なCLIでないと怒られます。結果は一応出してくれます。<br/>
apt-cache search "hoge" | xargsなら大丈夫です。以上、小ネタでした。<br/>
