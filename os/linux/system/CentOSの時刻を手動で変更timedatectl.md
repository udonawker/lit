## [CentOSの時刻を手動で変更](https://www.suzu6.net/posts/168-centos-timedatectl/)

### 時刻確認
<pre>
$ date
2019年  6月 10日 月曜日 08:39:39 JST

$ timedatectl status
      Local time: 月 2019-06-10 08:39:46 JST
  Universal time: 日 2019-06-09 23:39:46 UTC
        RTC time: 日 2019-06-09 13:41:45
       Time zone: Asia/Tokyo (JST, +0900)
     NTP enabled: yes
NTP synchronized: no
 RTC in local TZ: no
      DST active: n/a
</pre>

`timedatectl set-time 日付時刻`でローカルタイムを修正できる。 この時、ntpが有効になっていると下のようなエラーが出る。<br>

<pre>
$ timedatectl set-time "2019-06-10 13:00:00"
Failed to set time: Automatic time synchronization is enabled
</pre>

そのため、`timedatectl set-ntp no`でntpを無効にしてから再度時刻を修正する。

<pre>
# ntp無効
$ sudo  timedatectl set-ntp no

$ sudo timedatectl set-time "2019-06-10 13:01:00"
$ timedatectl status
      Local time: 月 2019-06-10 13:01:17 JST
  Universal time: 月 2019-06-10 04:01:17 UTC
        RTC time: 月 2019-06-10 04:01:17
       Time zone: Asia/Tokyo (JST, +0900)
     NTP enabled: no
NTP synchronized: no
 RTC in local TZ: no
      DST active: n/a
</pre>

ntpを有効に戻す。<br>

<pre>
$ sudo timedatectl set
</pre>
