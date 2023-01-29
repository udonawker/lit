```
ブラウジング機能とは、Windowsの"エクスプローラー > ネットワーク"などのファイル共有機能を持ったサーバ一覧に構築したsambaを表示させるものであり、nmbdがその役割を担っています。

nmbd以外にsambaを構成するデーモンにはsmbdとwinbinddがあり、それぞれ以下の役割を担っています。

smbd	：	ファイルやプリンタの共有、認証など
nmbd	：	ブラウジング、名前解決など
winbindd	：	NSS(ネームサービススイッチ)機能など
また、役割によって使用されるTCP/UDPのポートが異なることもSambaの特徴的なところです。

名前解決など	：	137/udp
ブラウジングなど	：	138/udp
ファイル・プリンタ共有など	：	139/tcp・445/tcp
上記のような構成で動作していることを知っておくことは、構築完了後のサービス確認やトラブル発生時の切り分け(トラブルシュート)をする際に重要ですので、しっかりと理解しておきましょう。

各デーモンやSambaの詳細は、以下で確認することが出来ます。
smbd( http://www.samba.gr.jp/project/translation/current/htmldocs/manpages/smbd.8.html )
nmbd( http://www.samba.gr.jp/project/translation/4.0/htmldocs/manpages/nmbd.8.html )
winbindd( http://www.samba.gr.jp/project/translation/current/htmldocs/manpages/winbindd.8.html )
Samba本家サイト( https://www.samba.org/ )
日本Sambaユーザー会( http://www.samba.gr.jp/ )
```

### [smbd](http://www.samba.gr.jp/project/translation/current/htmldocs/manpages/smbd.8.html)
### [nmbd](http://www.samba.gr.jp/project/translation/4.0/htmldocs/manpages/nmbd.8.html)
### [winbindd](http://www.samba.gr.jp/project/translation/current/htmldocs/manpages/winbindd.8.html)
