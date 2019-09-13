引用<br/>
[NTP サーバーの設定 (Chrony)](https://www.server-world.info/query?os=Ubuntu_16.04&p=ntp&f=2)<br/>

### Chrony のインストールと設定
<pre>
root@dlp:~# apt-get -y install chrony
root@dlp:~# vi /etc/chrony/chrony.conf
# 20行目：コメント化
# pool 2.debian.pool.ntp.org offline iburst
# 同期をとるサーバーを指定
server ntp1.jst.mfeed.ad.jp offline iburst
server ntp2.jst.mfeed.ad.jp offline iburst
server ntp3.jst.mfeed.ad.jp offline iburst

...
# ハードウェアクロックの設定
rtcsync

# ステップ調整の指定
makestep 0.1 10
</pre>

### Stepによる同期を行う
<pre>
$ chronyc -a makestep
</pre>
