[Linuxカーネルのコンフィグレーション手順](https://www.atmarkit.co.jp/ait/articles/0808/28/news129_2.html)<br/>

### make mrproper
現在のコンフィグレーションファイル.configと、前回のカーネルコンフィグレーションで生成されたすべてのファイルを削除して初期状態に戻します。<br/>
<br/>
**make cleanとの違い**:<br/>
cleanの場合はmrproperでは削除される現在のコンフィグレーションファイル.config やローダブルモジュールの生成に必要なファイルは削除されません。<br/>
**mrproperの由来**:<br/>
トーバルス氏が、欧州で知られているMr.Properというクリーニング製品の名前にちなんで付けたとのこと。米国では同じ製品がMr.Cleanとして知られていて、製品のマスコットイメージはsailor（船乗り）だそうです。<br/>
<br/>

make config make menuconfig	make xconfig<br/>
make gconfig	make oldconfig	make defconfig<br/>
