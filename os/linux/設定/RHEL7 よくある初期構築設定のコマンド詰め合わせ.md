## [RHEL7 よくある初期構築設定のコマンド詰め合わせ](https://dev.classmethod.jp/articles/ec2-rehl7-first-buildcmd/)

## はじめに
初期構築っていっても色々あると思いますが、私がやりたかった対象は以下です。<br>

* ホスト名
* 時刻同期
* 文字コード
* タイムゾーン

## 初期設定
### タイムゾーン
タイムゾーンは、`timedatectl` set-timezoneで設定します。<br>

<pre>
$ sudo timedatectl set-timezone  Asia/Tokyo
</pre>

設定した内容を確認してみます。localがJSTに設定されました！<br>

<pre>
$ sudo timedatectl
      Local time: Wed 2019-02-06 13:28:26 JST
  Universal time: Wed 2019-02-06 04:28:26 UTC
        RTC time: Wed 2019-02-06 04:28:25
       Time zone: Asia/Tokyo (JST, +0900)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a
</pre>

選択できるタイムゾーンの一覧を確認もしてみました。<br>

<pre>
$ sudo timedatectl list-timezones
Africa/Abidjan
Africa/Accra
Africa/Addis_Ababa
Africa/Algiers
Africa/Asmara
・・・
</pre>

ついでにdateコマンドで確認しました。JSTになってました。<br>

<pre>
$ date
2019年  2月  6日 水曜日 14:00:38 JST
</pre>

参考 : [https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/chap-Configuring_the_Date_and_Time]()<br>

### ホスト名
ホスト名は、`hostnamectlで設定します。 staticをつけると、従来のhostnameと同じ動作で、/etc/hostnameに保存されます。<br>

<pre>
$ sudo hostnamectl set-hostname --static example.com
</pre>

リブートしてもホスト名を維持するように、cloud-initの設定を変更します。<br>

<pre>
$ sudo echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg
</pre>

サーバーを再起動しても設定が維持されました。<br>

<pre>
$ sudo hostname
example.com
</pre>

参考 : [https://aws.amazon.com/jp/premiumsupport/knowledge-center/linux-static-hostname-rhel7-centos7/ - https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/networking_guide/sec_configuring_host_names_using_hostnamectl - https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/networking_guide/ch-configure_host_names]()<br>

### 時刻同期
EC2を利用する場合は、AWSが提供しているAmazon Time Sync Service を利用することが多いと思います。手順では、`chrony`を使ってTime Sync Serviceと時刻同期します。`169.254.169.123`向けに時刻同期するように設定します。<br>

<pre>
$ sudo yum erase 'ntp*'
$ sudo yum install chrony
$ sudo echo '#Add TimeSync' >> /etc/chrony.conf
$ sudo echo 'server 169.254.169.123 prefer iburst' >> /etc/chrony.conf
</pre>

サービスの起動設定もしておきましょう。<br>

<pre>
$ sudo systemctl start chrony
$ sudo systemctl enable chrony
</pre>

反映されているか確認してみました。問題なさそうです。<br>

<pre>
$ chronyc sources -v
210 Number of sources = 5

  .-- Source mode  '^' = server, '=' = peer, '#' = local clock.
 / .- Source state '*' = current synced, '+' = combined , '-' = not combined,
| /   '?' = unreachable, 'x' = time may be in error, '~' = time too variable.
||                                                 .- xxxx [ yyyy ] +/- zzzz
||      Reachability register (octal) -.           |  xxxx = adjusted offset,
||      Log2(Polling interval) --.      |          |  yyyy = measured offset,
||                                \     |          |  zzzz = estimated error.
||                                 |    |           \
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^* 169.254.169.123               3   6   377     4    -78us[  -57us] +/- 2181us
^- sv1.localdomain1.com          2   6   377     3   -199us[ -199us] +/-   35ms
^- 122x215x240x52.ap122.ftt>     2   6   377     3   +580us[ +580us] +/-   26ms
^? m.moe.cat                     2   7    40   263  -6668us[ -926ms] +/-   56ms
^- ntp-b2.nict.go.jp             1   6   377     5   +483us[ +503us] +/- 2998us
$ chronyc tracking
Reference ID    : A9FEA97B (169.254.169.123)
Stratum         : 4
Ref time (UTC)  : Wed Feb 06 04:59:45 2019
System time     : 0.000035181 seconds slow of NTP time
Last offset     : +0.000020663 seconds
RMS offset      : 0.003982427 seconds
Frequency       : 42.591 ppm fast
Residual freq   : +1.527 ppm
Skew            : 1.347 ppm
Root delay      : 0.003383718 seconds
Root dispersion : 0.000520247 seconds
Update interval : 64.8 seconds
Leap status     : Normal
</pre>

参考 : [https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sect-using_chrony#sect-Starting_chronyd]()<br>

### 文字コード
文字コードは`localectl`コマンドを使用します。<br>

<pre>
$ sudo localectl set-locale LANG=ja_JP.utf8
</pre>

設定されているか確認してみます。<br>

<pre>
$ sudo localectl status

$ localectl status
   System Locale: LANG=ja_JP.utf8
       VC Keymap: us
      X11 Layout: n/a
</pre>

ついでにdateコマンドで日本語が表示されるかもみてみました。<br>

<pre>
$ date
2019年  2月  6日 水曜日 14:00:38 JST
</pre>

参考 : [https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-keyboard_configuration]()<br>

## サーバーの再起動
さいごに設定が永続されているか確認するために再起動しておきましょう。<br>

## ユーザーデータで初期設定
EC2構築時に、ユーザーデータを利用するとログインせずに設定できますので、こちらもあわせて利用するといいでしょう。 EC2作成時に以下のユーザーデータを設定しましょう。<br>

<pre>
#!/bin/sh -ex

# timezon
timedatectl set-timezone  Asia/Tokyo

# hostname
hostnamectl set-hostname --static example.com
echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg

# time sync
yum erase 'ntp*'
yum install chrony
echo '#Add TimeSync' >> /etc/chrony.conf
echo 'server 169.254.169.123 prefer iburst' >> /etc/chrony.conf
systemctl start chrony
systemctl enable chrony

# locale
localectl set-locale LANG=ja_JP.utf8
</pre>

## さいごに
RHEL7の初期構築コマンドをまとめました。ユーザーデータ利用すると、ログインせずにできるので圧倒的楽です。ぜひご活用ください。<br>

