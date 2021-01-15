## [LinuxのLANG変数](https://eng-entrance.com/linux-localization-lang)

### ローカライゼーション系の環境変数を表示する「locale」コマンド
<pre>
# locale
</pre>

### 指定出来るロケールの表示
<pre>
# locale -a
</pre>

### localectl
#### 現在のロケールの確認
<pre>
# localectl status
</pre>

#### 使用可能なロケールを確認
<pre>
# localectl list-locales
</pre>

#### 標準英語環境を指定したい場合
<pre>
# localectl set-locale LANG=C
</pre>

#### 日本語を表示したい場合
<pre>
# localectl set-locale LANG=ja_JP.utf8
</pre>

とする。コマンドを実行したら一度ログアウトすると確実に設定が反映される。<br>
<pre>
# less  /etc/locale.conf
</pre>
