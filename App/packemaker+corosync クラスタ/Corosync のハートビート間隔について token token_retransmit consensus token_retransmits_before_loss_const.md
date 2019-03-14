引用
[超私的 Undocumented Pacemaker and Corosync Vol.3 〜Corosync のハートビート間隔について調…](https://cloudpack.media/6575 "超私的 Undocumented Pacemaker and Corosync Vol.3 〜Corosync のハートビート間隔について調…")

参考
[09. Pacemakerで簡単・手軽にクラスタリングしてみよう！](http://sourceforge.jp/projects/linux-ha/docs/Pacemaker_OSC2010Hokkaido_20100626/ja/1/Pacemaker_OSC2010Hokkaido_20100626.pdf "09. Pacemakerで簡単・手軽にクラスタリングしてみよう！")
<br/><br/>
# Corosync の役割
自分の認識を軽くまとめる。

- Pacemaker と連携してクラスタ構成を担う
- Pacemaker はクラスタ構成のノード上で稼働しているリソースを監視する
- Corosync はノード間にてハートビート通信を行いノードの死活を監視する
- Pacemaker と Corosync を合わせて Pacemaker と呼ぶ→わかりづらい…
<br/><br/>
# 今回の疑問
1.のハートビート通信。この通信の中身や間隔をちょっと知りたい
<br/><br/>
# ハートビート通信の中身
tcpdump でとりあえず…
<pre>
# tcpdump udp port 5405 -X
</pre>
実行すると以下のように出力されました。
<pre>
15:51:01.590542 IP ip-xx-x-x-1.ap-northeast-1.compute.internal.netsupport > ip-xx-x-x-2.ap-northeast-1.compute.internal.netsupport: UDP, length 70
        0x0000:  4500 0062 7283 4000 4011 b0d7 0a00 013e  E..br.@.@......>
        0x0010:  0a00 01f3 151d 151d 004e 1790 0000 22ff  .........N....".
        0x0020:  0a00 013e 4600 0000 a801 0000 4600 0000  ...>F.......F...
        0x0030:  0000 0000 0a00 013e 0200 0a00 013e 0800  .......>.....>..
        0x0040:  0400 0a00 017f 0900 0300 9800 0000 0000  ................
        0x0050:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0060:  0000                                     ..
15:51:01.592533 IP ip-xx-x-x-2.ap-northeast-1.compute.internal.netsupport > ip-xx-x-x-1.ap-northeast-1.compute.internal.netsupport: UDP, length 70
        0x0000:  4500 0062 5e0e 4000 4011 c54c 0a00 01f3  E..b^.@.@..L....
        0x0010:  0a00 013e 151d 151d 004e 85f7 0000 22ff  ...>.....N....".
        0x0020:  0a00 01f3 4600 0000 a901 0000 4600 0000  ....F.......F...
        0x0030:  0000 0000 0a00 013e 0200 0a00 013e 0800  .......>.....>..
        0x0040:  0400 0a00 017f 0900 0300 9800 0000 0000  ................
        0x0050:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0060:  0000                                     ..
15:51:01.801664 IP ip-xx-x-x-1.ap-northeast-1.compute.internal.52981 > ip-xx-x-x-2.ap-northeast-1.compute.internal.netsupport: UDP, length 82
        0x0000:  4500 006e 7287 4000 4011 b0c7 0a00 013e  E..nr.@.@......>
        0x0010:  0a00 01f3 cef5 151d 005a 179c 0200 22ff  .........Z....".
        0x0020:  0a00 013e 0a00 013e 0200 0a00 013e 0800  ...>...>.....>..
        0x0030:  0400 0a00 017f 0900 0300 0000 0000 0000  ................
        0x0040:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0050:  0a00 013e 0200 0a00 013e 0800 0400 0a00  ...>.....>......
        0x0060:  017f 0900 0300 9800 0000 0000 0000       ..............
</pre>
実際の通信の中身は 70 バイトから 82 バイトまでのランダムな文字列（トークン）のやりとりが行われているようです。
<br/>
# ハートビート通信の間隔
## 説（1）
では、このハートビート通信はどんな間隔で行っているんでしょうか…。「corosync heartbeat interval」でググってみてもあまり有用な情報は得られませんでしたが…「corosync token interval」でググると…
[[corosync] The heartbeat interval of corosync](http://lists.corosync.org/pipermail/discuss/2011-December/000295.html "[corosync] The heartbeat interval of corosync")
- ヘルスチェックのパラメータは token にて指定
- token は UDP 通信で信頼性が無いので数回の再送を行う(token_retransmit 毎に？)
- ハートビートの間隔は自動的に計算（token / token_retransmits_before_loss_const * 0.9）される
<br/><br/>
なにやら幾つかのパラメータの計算式よって得られる結果がハートビート通信の間隔となるようです。そして、この間隔は **token_retransmit** となるようですので、
<pre>
man corosync.conf
</pre>
で **token** と **token_retransmits_before_loss_const** パラメータを確認してみます。
<pre>
token
       This  timeout specifies in milliseconds until a token loss is declared after not receiving a
       token.  This is the time spent detecting a failure of a processor in the current  configura‐
       tion.   Reforming  a new configuration takes about 50 milliseconds in addition to this time‐
       out.
 
       The default is 1000 milliseconds.
 
token_retransmit
       This timeout specifies in milliseconds after how long before receiving a token the  token  is
       retransmitted.  This will be automatically calculated if token is modified.  It is not recom‐
       mended to alter this value without guidance from the corosync community.
 
       The default is 238 milliseconds.
 
token_retransmits_before_loss_const
       This value identifies how many token retransmits should be attempted  before  forming  a  new
       configuration.   If  this  value is set, retransmit and hold will be automatically calculated
       from retransmits_before_loss and token.
 
       The default is 4 retransmissions.
</pre>
それぞれのパラメータについてはちゃんと訳しておきたいところですが、簡単に纏めると以下のような意味があるようです。
<br/>

|パラメータ | ざっくり意味 |
|--- |--- |
|token|ノードの故障を検出するまでの時間|
|token_retransmit|ハートビートメッセージ（トークン）が再送信される時間を設定（自動計算されるので変更は非推奨）|
|token_retransmits_before_loss_const|ハートビートメッセージを送信する間隔（超怪しい訳）|

<br/>
ということで、ハートビート通信の間隔については下記の通りとなるようです。
<br/>

- token_retransmit にて定義される
- token_retransmit は token と token_retransmits_before_loss_const の値で自動計算されるの個別に設定するのは非推奨
- 自動計算の計算式は token / token_retransmits_before_loss_const * 0.9 となる
例えば
- token を 100000 msec（token: 100000）
- token_retransmits_before_loss_const が 1（token_retransmits_before_loss_const: 1）
というような極端な設定の環境であれば 90000 msec（90 秒）がハートビート通信の間隔となるようですが…
<br/><br/>
## 説（2）
ハートビート通信間隔について token_retransmit が怪しいところまでは解ってきました。で、最終的に辿り着いたのはソースコード。
<br/>
[corosync/corosync](https://github.com/corosync/corosync "corosync/corosync")
ソースコードの exec/totemconfig.c に以下のように計算式っぽい記述がありました。
exec/totemconfig.c
<pre>
totem_volatile_config_set_value(totem_config, "totem.token_retransmit", deleted_key,
   (int)(totem_config->token_timeout / (totem_config->token_retransmits_before_loss_const + 0.2)), 0);
</pre>
ん、さっきのメーリングリストとはちょっと違った計算式のようですが、 token_timeout は token パラメータの値が入る以外は計算に利用する値は同じです。この計算式をそれぞれのデフォルト値を用いて計算すると…
<pre>
token token_retransmits_before_loss_const
1000 / 4                                   + 0.2
</pre>
で token_retransmit のデフォルト値（238 msec）と一致します。おお。
# 最後に
ちょっと知りたいって感じで始めましたが、最終的にはソースコードを見て納得って感じになりました。改めて Corosync のハートビート通信についてまとめると以下の通りになりました。
- 泣く子もだまる UDP 通信です
- 70 バイトから 82 バイトのトークンメッセージをやりとりしています
- トークメッセージの通信間隔は token_retransmit で定義しています
- token_retransmit は token と token_retransmits_before_loss_const から自動計算されるので個別に定義は非推奨
- token_retransmit のデフォルトは 238 msec
実際に tcpdump を取ってみても 238 msec に近い値ではありますが、きっちり 238 msec になっていないようなので、も少し他の要因もあるかもしれません…（これは引き続き調べます）がちょっとスッキリしました。
