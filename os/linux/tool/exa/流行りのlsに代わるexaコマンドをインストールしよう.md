[流行りのlsに代わるexaコマンドをインストールしよう](https://mxier.pro/blog/VTF/post/144)<br/>

### インストール方法
<pre>
今回はUbuntuの環境へインストールします
実行環境：Ubuntu 16.04.6 LTS(64bit)

1.Rust Compilerの導入(既に導入済みの場合はスキップして下さい)
curl https://sh.rustup.rs -sSf | sh
選択肢はデフォルトの１でOKです、適正変更して下さい

2.最新Exaライブラリのダウンロードと解凍、インストール
※最新バイナリダウンロードURLはGitHubにて確認して下さい※
※各自環境に合わせてダウンロードして下さい、今回は64bit版です※
https://github.com/ogham/exa
wget -c https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip

unzip exa-linux-x86_64-0.9.0.zip

sudo mv exa-linux-x86_64 /usr/local/bin/exa
</pre>
