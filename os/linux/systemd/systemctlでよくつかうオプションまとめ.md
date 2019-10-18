引用 
[systemctlでよくつかうオプションまとめ](https://www.kabegiwablog.com/entry/2018/06/13/100000 "systemctlでよくつかうオプションまとめ")


# サービスの起動
起動しても標準出力にはなにもでない。
<pre>
$ sudo systemctl start wawawa.service
</pre>
<br/>

# サービスの停止
停止しても標準出力にはなにもでない。
<pre>
$ sudo systemctl stop wawawa.service
</pre>
<br/>

# サービスの再起動
再起動しても標準出力にはなにもでない。
<pre>
$ sudo systemctl restart wawawa.service
</pre>
<br/>

# サービスのリロード
再起動とリロードの違いは設定ファイルを再読込するかしないか。<br/>
リロードの場合は再読込が行われる(reloadに対応していれば)
<pre>
$ sudo systemctl reload wawawa.service
</pre>
<br/>

# 自動起動の有効化
<pre>
$ sudo systemctl enable wawawa.sevice
</pre>
<br/>

# 自動起動の無効化
<pre>
$ sudo systemctl diasble wawawa.service
</pre>
<br/>

# 自動起動が有効か確認する
有効であれば`enabled`<br/>
無効であれば`diasbaled`が出力される。<br/>
<pre>
$ systemctl is-enabled wawawa.service
enabled
</pre>
<br/>

# ユニットがアクティブかどうか確認する
アクティブであれば`active`<br/>
ノンアクティブであれば`failed`が出力される<br/>
<pre>
$ systemctl is-active wawawa.service
active
</pre>
<br/>

# サービスの強制終了
<pre>
$ sudo systemctl kill wawawa.service
</pre>
<br/>

# サービスにシグナルを送信する
シグナルはすきなやつを指定してあげて。<br/>
<pre>
$ sudo systemctl kill wawawa.service --signal 9
</pre>
<br/>

# ユニットの設定の詳細を確認する
<pre>
$ systemctl show wawawa.service
Type=notify
Restart=no
NotifyAccess=main
~~~省略~~~
</pre>
<br/>

# ユニットの起動状態を確認する
<pre>
$ systemctl status wawawa.service
● wawawa.service - The wawawa Server
   Loaded: loaded (/usr/lib/systemd/system/wawawa.service; disabled; vendor preset: disabled)
   Active: active (running) since 土 2018-06-02 14:12:05 UTC; 19min ago
~~~省略~~~
</pre>
<br/>

# 全ユニットをリスト表示する
`--type`オプションをつけることで結果を絞ることもできます。<br/>
たとえば`--type service`とすればサービスだけ出力されます。<br/>
<pre>
$ systemctl list-units
</pre>
<br/>

# systemdをリロードする
新規にユニットファイルを作ったときや、`/etc/systemd/system/`配下のファイルをいじったときに利用する。<br/>
<pre>
$ sudo systemctl daemon-reload
</pre>
