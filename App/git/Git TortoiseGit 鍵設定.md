1．sshの鍵を作成（GitHubで設定する鍵）
- gitbashを起動
    - 「スタートメニュー」＞「全てのプログラム」＞「Git」＞「Git Bash」
- 鍵を作成
<pre>
Generating public/private rsa key pair.
Enter file in which to save the key (/c/Users/<ユーザ>/.ssh/id_rsa):
※enter押下
Created directory '/c/Users/<ユーザ>/.ssh'.
Enter passphrase (empty for no passphrase):
※enter押下
Enter same passphrase again:
※enter押下
</pre>

- 鍵確認
<pre>
$ ls -ltr .ssh/
-rw-r--r-- id_rsa.pub　←公開鍵
-rw-r--r-- id_rsa　　　←秘密鍵
</pre>
<br/><br/>

2．GitHubでの公開鍵指定
- 公開鍵コピー
<pre>
$ Clip.exe < .ssh/id_rsa.pub
</pre>

- GitHub鍵設定
    - 以下にアクセス
    - <https://github.hpe.com/settings/keys>
    
    - SSH keysの「New SSH key」を押下
        - 「Title」に適当な名前を設定
        - 「Key」にクリップボードを貼り付ける
        - 「Add SSH key」を押下する。
<br/><br/>

3．PuTTY形式の鍵を作成（TortoiseGitに設定）
- PuTTY Key Generator起動
    - 「スタートメニュー」＞「全てのプログラム」＞「PuTTY」＞「PuTTYgen」＞「ツールバーのConversions」＞「Import Key」
    - 「1．」で作成した、秘密鍵をインポートする。
    - 「Save private key」を押下し、任意のパスに.ppkファイルを保存する。
<br/><br/>

4．TortoiseGitでの秘密鍵指定
- Clone実行時に秘密鍵指定
    - 「マウス右クリック」＞「Git Clone...」
    - 「Load Putty Key」のチェックボックスにチェックを入れ、「3．」で作成した、.ppkファイルのパスを指定する。
<br/><br/>
