## [Guest Additonsのインストール](https://linux.just4fun.biz/?%E4%BB%AE%E6%83%B3%E5%8C%96%E9%96%A2%E9%80%A3/Ubuntu14.04%E3%81%ABVirtualBox+guest+additions%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B)
## [VirtualBox：Ubuntu16の共有フォルダ設定](https://web-dev.hatenablog.com/entry/etc/virtualbox/ubuntu16-shared-folder)

### 1. 仮想マシンの共有フォルダ設定
VirtualBox マネージャーの設定で「共有フォルダ」を選択して、右側のアイコンをクリックします。クリックすると、下の画面が表示されるので、Windows 上のパスを指定します。<br>
(自動マウントにチェックを入れる)<br>
![共有フォルダ設定](https://cdn-ak.f.st-hatena.com/images/fotolife/m/mamorums/20171224/20171224130652.png)<br>

<br>
### 2. Ubuntu に Guest Addisions をインストール

#### Guest Addtionsのイメージ挿入
- デバイスメニュー → Guest Additions CD イメージの挿入...<br>
![Guest Addtionsのイメージ挿入](https://linux.just4fun.biz/?plugin=ref&page=%E4%BB%AE%E6%83%B3%E5%8C%96%E9%96%A2%E9%80%A3%2FUbuntu14.04%E3%81%ABVirtualBox%20guest%20additions%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B&src=01.gif)<br>

- Ubuntu側に以下の自動実行するかのメッセージが表示されるので、キャンセルを押します。<br>
![ダイアログ](https://linux.just4fun.biz/?plugin=ref&page=%E4%BB%AE%E6%83%B3%E5%8C%96%E9%96%A2%E9%80%A3%2FUbuntu14.04%E3%81%ABVirtualBox%20guest%20additions%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B&src=02.png)<br>

- ターミナル(端末)を起動します。<br>
- 以下に記すディレクトリに移動します。<br>
<pre>
cd /media/<ユーザ名>/VBOXADDITIONS_[バージョン]
</pre>
 
- 移動が完了したら以下のコマンドでGuest Addtionsをインストールします。<br>
<pre>
sudo ./VBoxLinuxAdditions.run 
</pre>
 
- vboxguestがインストールされたかを以下のコマンドで確認します。<br>
<pre>
lsmod | grep -io vboxguest
</pre>
vboxguestが表示されれば正常にインストールされています。<br>
 
- 再起動します。<br>
<pre>
sudo reboot
</pre>
