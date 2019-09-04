引用<br/>
[sudo 後の環境変数を設定する方法](https://nogiro.hatenablog.com/entry/2018/03/16/204843 "https://nogiro.hatenablog.com/entry/2018/03/16/204843")<br/>

### 調べた結果 4 つの方法でできました。

- 環境変数を引き継ぐ
<pre>
export ENV=VAL
sudo -E command
</pre>

- sudoers に evn_keep を指定する
<pre>
$ sudo cp /etc/sudoers sudoers.bac
$ sudo visudo
$ sudo diff -u sudoers.bac /etc/sudoers
--- sudoers.bac        2018-03-16 20:28:53.668295300 +0900
+++ /etc/sudoers   2018-03-16 20:29:29.756458100 +0900
@@ -9,6 +9,7 @@
 Defaults       env_reset
 Defaults       mail_badpass
 Defaults       secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
+Defaults       env_keep += "ENV"

 # Host alias specification

$ export ENV=VAL
$ sudo command
</pre>

- 一時環境変数を使う
<pre>
sudo bash -c 'ENV=VAL command'
</pre>

- sudo 先のユーザーの .bashrc などに設定後、 `-i` オプションを付けて sudo を実行する。
<pre>
echo 'export ENV=VAL'  | sudo tee /root/.bashrc
sudo -i command
</pre>
