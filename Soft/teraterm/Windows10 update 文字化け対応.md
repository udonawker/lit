## [Windows10のTera Term文字化け](https://blog.dksg.jp/2021/05/windows10tera-term.html)

```
Windows10のTera Term文字化け
windows 技術ネタ投稿日： 5月 03, 2021
Windows10を再インストールしたときの覚書。
Tera Termをインストールしたら文字化けしていた。

環境： Windows 10 pro 20H2, Tera Term 4.105

メニューのSetup（左から3番目） → General（TCP/IPの下）
Language: UTF-8
LanguageUI: Default.lng

Setup（左から3番目） → Terminal
locale: japanese

Setup（左から3番目） → Font
MSゴシック／標準／11
文字セット： 日本語


Setup（左から3番目） → Save SetupでTERATERM.INIを上書きして次回起動時も反映されるようにしておく。

サーバー側の設定を確認するコマンド（CentOS）
# env
```
