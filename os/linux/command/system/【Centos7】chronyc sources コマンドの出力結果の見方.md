## [【Centos7】chronyc sources コマンドの出力結果の見方](https://rurukblog.com/post/chronycsources/)

## Chronyとは
NTPクライアントとNTPサーバーの実装のひとつ。<br>
ntpdより効率良く正確な時刻同期を提供します。<br>

* システムクロックを、NTP サーバーと同期する
* システムクロックを、GPS レシーバーなどの基準クロックと同期する
* システムクロックを、手動で入力した時間と同期する
* ネットワーク内の他のコンピューターにタイムサービスを提供する

## [Chrony公式](https://chrony.tuxfamily.org/)

## chronyc sources コマンドとは
chrony が自身の時刻同期先(NTPサーバなど)と同期が取れているかを確認できるコマンドのひとつ。<br>
chronyc sourcesコマンドは、chronyd が時刻同期している(または時刻同期可能な)サーバー等の情報を表示します。<br>
chronyc trackingコマンドが自分自身の状態を表示しするのに対し、chronyc sourcesコマンドは接続先の情報を表示します。<br>

## chronyc sources の見方
オプションなしでコマンドを実行すると、以下のような出力結果が得られますが、<br>

```
$ chronyc sources
210 Number of sources = 4
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
========================================================
^? ntp-b2.nict.go.jp             1   6   375    24  -4891us[ -100ms] +/-   13ms
^* sh03.paina.net                3   6   357    20   -993us[  -96ms] +/-   51ms
^? time.ooonet.ru                2   6   143    23   -437us[  -96ms] +/-  235ms
^+ 185.137.97.5                  2   6   377    20    -17ms[  -17ms] +/-  183ms
```

-v オプションを使用すると詳細説明も表示できます。<br>

```
$ chronyc sources -v
210 Number of sources = 4

  .-- Source mode  '^' = server, '=' = peer, '#' = local clock.
 / .- Source state '*' = current synced, '+' = combined , '-' = not combined,
| /   '?' = unreachable, 'x' = time may be in error, '~' = time too variable.
||                                                 .- xxxx [ yyyy ] +/- zzzz
||      Reachability register (octal) -.           |  xxxx = adjusted offset,
||      Log2(Polling interval) --.      |          |  yyyy = measured offset,
||                                \     |          |  zzzz = estimated error.
||                                 |    |           \
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
==========================================================
^* ntp-b2.nict.go.jp             1   6   353   125   +440us[+3285us] +/- 7560us
^- time-b.as43289.net            3   6   377    61    -35ms[  -35ms] +/-  306ms
^- time.ooonet.ru                2   6   377   124    +38ms[  +38ms] +/-  241ms
^- 185.137.97.5                  2   6   377   126    +12ms[  +12ms] +/-  194ms
```

### M (Mode)
ソースのモードを示す。記号ごとにそれぞれ以下の意味がある。<br>
```
^ はサーバー
= はピア
# はローカル
```

### S (State)
この列は、ソースの状態を示します。<br>
```
「*」は、chronyd が現在同期しているソースを表す。
「+」は、選択したソースと結合する、受け入れ可能なソースを表す。
「-」は、受け入れ可能なソースで、結合アルゴリズムにより除外されたものを表す。
「?」は、接続が切断されたソース、またはパケットがすべてのテストをパスしないソースを表す。
「x」は、chronyd が falseticker と考える (つまり、その時間が他の大半のソースと一致しない) クロックを表す。
「~」は、時間の変動性が大きすぎるように見えるソースを表します。
「?」条件は、少なくとも 3 つのサンプルが収集されるまで開始時にも表示されます。
```

### Name/IP address
ソースの名前または IP アドレス、もしくは基準クロックの参照 ID を表示する。<br>

### Stratum (ストラタム)
直近で受け取ったサンプルでレポートされているソースの stratum(NTPサーバーの階層) を表示します。<br>
Stratum 1 は、ローカルで基準クロック(最上位のstratum 0)に接続しているコンピューターを示します。<br>
Stratum 1 のコンピューターに同期しているコンピューターは、stratum 2 となります。<br>
同じく、Stratum 2 のコンピューターに同期しているコンピューターは stratum 3 となり、それ以後も同様に続きます。<br>

### Poll
ソースがポーリングされるレートで、2 の乗数秒 で示される。<br>
例えば、値が 6 の場合は、64 秒ごとに測定が行われる。<br>
chronyd は、一般的な条件に応じて、ポーリングレートを自動的に変更します。<br>

### Reach
ソースの到達可能性のレジスターで、8 進法で表示されます。<br>
レジスターは 8 ビットで、ソースからパケットを受信するたびに、またはミスするたびに更新されます。<br>
値が 377 の場合は、最近の 8 回の通信全体で、有効な返信を受け取ったことを表します。<br>

### LastRx
何秒前に最後のパケットを受信したかを示す。<br>

### Last sample
この列は、ローカルクロックと、最後に測定されたソースの間のオフセットを表示します。<br>
角括弧内の数字は、実際に測定されたオフセットを表示します。<br>
つまり、NTPサーバーとローカル環境の時間の乖離値を確認するにはこの箇所を見れば良い。<br>
これには ns (ナノ秒)、us (マイクロ秒)、ms (ミリ秒)、または s (秒) の各接尾辞が付く場合がある。<br>
角括弧の左側は元の測定を示し、slew がそれ以降にローカルクロックに適用可能になるように調整されています。<br>
+/- に続く数字は、測定におけるエラーのマージンを示します。オフセットの値がプラスの場合は、ローカルクロックがソースよりも進んでいることを意味します。<br>
<br>

また、-vオプションの説明を見ると、Last sampleの各数値の最大桁数は4桁となるようだ。<br>

__各単位の1秒の桁数__<br>
```
1s(秒) = 1,000 ms
1s(秒) = 1,00,000 us
1s(秒) = 1,000,000,000 ns
```

## 関連記事
[【Centos7】chronyc tracking コマンドの出力結果の見方](https://rurukblog.com/post/chronyc-tracking/)
[【Centos7】chronyc sourcestatsコマンドの出力結果の見方](https://rurukblog.com/post/chronyc-sourcestats/)
[【Centos7】chronyc ntpdata コマンドの出力結果の見方](https://rurukblog.com/post/chronyc-ntpdata/)

## Red Hat7マニュアル
https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-configuring_ntp_using_the_chrony_suite<br>
