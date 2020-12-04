# [find／xargsを使った検索に便利なコマンド一覧](https://uguisu.skr.jp/Windows/find_xargs.html)

## core、#*、*~を一括削除する

Emacsを利用していると、テキストを保存する際に「ファイル名~」、ファイルを編集する際に「#ファイル名#」というバックアップファイルが作成されます。また、Unix・Linuxプロセスが異常終了すると「core」ファイルが生成されます。これらのファイルを一度に削除したい場合には、次のように指定できます。<br>

<pre>
$ find . \( -name core -o -name '#*' -o -name '*~' \) -exec rm '{}' +
</pre>

「\(」と「コマンド」、「コマンド」と「\)」の間にはスペースを空ける必要があります。<br>
<br>
　xargsコマンドを利用する場合は、次のように指定できます。<br>

<pre>
$ find . \( -name core -o -name '#*' -o -name '*~' \) -print0 | xargs -0 rm
</pre>

　findコマンドの判別式「-o」は、「-or」でも構いません。<br>
<br>
　なお、findコマンドの「-delete」アクションが利用できる場合は、次の方法が最も高速です。<br>

<pre>
$ find . \( -name core -o -name '#*' -o -name '*~' \) -delete
</pre>

## ユーザーが所有するファイルのみを検索して削除する

<pre>
$ find . -type f -user $(whoami) -exec rm '{}' +
</pre>

xargsコマンドを利用する場合は、次のように指定できます。<br>

<pre>
$ find . -type f -user $(whoami) -print0 | xargs -0 rm
</pre>

whoamiコマンドは、ユーザ名を表示します。<br>

## 検索して見つかった全ファイルを移動する

検索して見つかった全ファイルを「/var/tmp/」以下に移動します。<br>

<pre>
$ find . -type f -print0 | xargs -0 mv -t /var/tmp/
</pre>

mvコマンドの「-t」または「--target-directory」オプションで、移動先ディレクトリを指定できます。なお、この例ではディレクトリ構造を維持せず、ファイルのみ移動します。同名のファイルが存在すると上書きされるなど期待通りに動かないため、注意が必要です。<br>

<pre>
※注4
　xargsコマンドに「-i」（FreeBSDでは「-I」）オプションをつけると、パイプで渡された結果を「{}」で展開できます。このため、次の指定方法でも動作します。

$ find . -type f -print0 | xargs -0 -i mv '{}' /var/tmp/

　FreeBSDの場合、デフォルトで「{}」で展開できないため、次のように指定します。

$ find . -type f -print0 | xargs -0 -I % mv % /var/tmp/

　「-I」オプションの後の文字（例では「%」）を、findコマンドで見つかったファイル名に置換しています。

　ただしこの方法は、1ファイルづつmvコマンドを実行するため、処理が遅くなります。
</pre>

<pre>
※注5
　FreeBSDでは、xargsコマンドの「-J」オプションを利用すると、「-I」オプションより高速に処理できます。

$ find . -type f -print0 | xargs -0 -J % mv % /var/tmp/

　この例では、検索して見つかったファイル名のグループを「%」に置き換えてmvコマンドを実行しています。
</pre>

## 検索して見つかった全ファイルをディレクトリ構造ごとコピーする

検索して見つかった全ファイルを、ディレクトリ構造を保持したまま「/var/tmp/」以下にコピーします。これは、ファイル単位でバックアップを取る場合に、役に立ちます。ファイルのバックアップで利用するcpioコマンドを利用すると次のように指定できます。<br>

<pre>
$ find . -type f -print0 | cpio -pd0 /var/tmp/
</pre>

「-p」オプションは、ファイルを別のディレクトリにコピーします。「-d」オプションは、必要に応じてディレクトリを作成します。なお、cpioコマンドの「-0」オプションはGNUのcpioコマンド以外では使えません。<br>

## サイズと拡張子を条件にファイルを検索し、結果を別のファイルに書き込む
「~/public_html」以下で、拡張子が「.gif」かつサイズが100Kバイト以上のファイルを探し、結果を「result.txt」ファイルに書き込みます。<br>

<pre>
$ find ~/public_html \( -name "*.gif" -a -size +100k \) -fprint result.txt
</pre>

## findコマンドの「許可がありません」を表示しない
一般ユーザーで、ルートディレクトリや「/etc」ディレクトリなどを対象に検索すると「Permission denied」という警告メッセージが大量に表示されます。検索結果の一覧が警告メッセージに埋まってしまい、検索結果の確認が大変な場合には、次の方法で表示されなくなります。<br>

<pre>
$ find / -name user → 「user」を検索
find: /usr/src: Permission denied → 警告メッセージ
find: /usr/share/skel/MailBox: Permission denied → 警告メッセージ
find: /usr/obj: Permission denied → 警告メッセージ
(略)
/home/user

$ find / -name user 2>/dev/null
/home/user
</pre>
「2>/dev/null」を指定して、警告メッセージをヌルデバイスへ出力しています。<br>

## 複雑な条件でファイル・ディレクトリを検索する（findコマンド）

findコマンドは、ディレクトリツリーの中からファイルを探し出すことができる、大変強力で複雑なコマンドです。<br>

<pre>
$ find ［パス］[式（オプション、判別式、アクション）]
</pre>
「式」は、オプション、判別式およびアクションの組み合わせからなります。<br>

<pre>
※注1
　findコマンドは、OSによって使用可能なオプションが異なります。　例えば、SolarisなどのOSでは、以降で紹介する例の多くが使用できません
　（参考ページ：「find」SunOSリファレンスマニュアル1）
</pre>
