引用<br/>
[shoptコマンドで設定できるbashの便利設定まとめ](https://orebibou.com/2017/04/shopt%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%81%A7%E8%A8%AD%E5%AE%9A%E3%81%A7%E3%81%8D%E3%82%8Bbash%E3%81%AE%E4%BE%BF%E5%88%A9%E8%A8%AD%E5%AE%9A%E3%81%BE%E3%81%A8%E3%82%81/ "shoptコマンドで設定できるbashの便利設定まとめ")<br/>

bashの組み込みコマンドでshoptというコマンドがあるのだが、これを使うことによりbashのオプションの動作を制御する変数の値を変更してやることができる。<br/>
色々と便利なオプションも多いので、まとめてみることにする。<br/>
確認に使用したのは4.2.46(1)-releaseを用いている。<br/>
shoptコマンドで設定可能な項目は、以下のコマンドで確認可能だ。<br/>

*shopt*

<pre>
[root@BS-PUB-CENT7-01 ~]# shopt
autocd          off
cdable_vars     off
cdspell         off
checkhash       off
checkjobs       off
checkwinsize    on
cmdhist         on
compat31        off
compat32        off
compat40        off
compat41        off
direxpand       off
dirspell        off
dotglob         off
execfail        off
expand_aliases  on
extdebug        off
extglob         off
extquote        on
failglob        off
force_fignore   on
globstar        off
gnu_errfmt      off
histappend      on
histreedit      off
histverify      off
hostcomplete    on
huponexit       off
interactive_comments    on
lastpipe        off
lithist         off
login_shell     on
mailwarn        off
no_empty_cmd_completion off
nocaseglob      off
nocasematch     off
nullglob        off
progcomp        on
promptvars      on
restricted_shell        off
shift_verbose   off
sourcepath      on
xpg_echo        off
</pre>

各項目のon/offは以下のようにコマンドを実行することで切り替える。<br/>

*shopt -s オプション名 # 有効化*
*shopt -u オプション名 # 無効化*

各オプションの簡単な概要については以下。<br/>
(参考:[Man page of BASH](https://linuxjm.osdn.jp/html/GNU_bash/man1/bash.1.html "Man page of BASH") より抜粋)

- autocd … 有効になっている場合、ディレクトリPATHのみを指定すると、cdの引数として指定されたものとみなす(対話型シェルのときのみ)
- cdable_vars … 有効になっている場合、 cdの引数としてディレクトリPATHでない値が指定された場合、その値は変数名として扱われる(変数に代入された値にcdしようとする)
- cdspell … 有効になっている場合、cdの引数でスペルミスがあっても1文字の文字の入れ替わり・欠け・スペルミスであれば自動的に補正してcdをしてくれる(対話型シェルのときのみ)
- checkhash … 有効になっている場合、bashはハッシュ表からコマンドを見つけた際、指定されたコマンドが実際に存在するかどうかを確認する
- checkjobs … 有効になっている場合、対話型シェル終了時に停止中・実行中のジョブを 一覧で表示する(対話型シェルのときのみ)
- checkwinsize … 有効になっている場合、bashはコマンド実行のたびにターミナルのウィンドウサイズを確認して、必要に応じてLINEとCOLUMNの値を更新する
- cmdhist … 有効になっている場合、複数行に分かれているコマンドのすべての行を同一の履歴エントリに登録してくれる(デフォルトで有効)
- compat31 … 有効になっている場合、[[ の =~ 演算子のクォートされた引き数に関してbash 3.1の動作に変更する
- compat32 … 有効になっている場合、[[ の<演算子と>演算子によるロケール固有の文字列比較に関してbash 3.2 の動作に変更する
- compat40 … 有効になっている場合、[[ の < 演算子と > 演算子によるロケール固有の文字列比較とコマンドリストの解釈の効果に関して、bash 4.0 の動作に変更する
- compat41 … 有効になっている場合、bashがposixモードのときにダブルクォートの中のパラメータ展開時にシングルクォートを特殊文字として扱う
- direxpand … 有効になっている場合、bashは変数指定時に、ディレクトリ名が存在する場合はtab補完する際に変数を展開するようになる
- dirspell … 有効になっている場合、bashは指定されたディレクトリ名が存在しない場合、補完する際にスペルの修正を試みる
- dotglob … 有効になっている場合、.(ドット)ではじまるファイルもワイルドカードでマッチするようにする
- execfail … 有効になっている場合、組み込みコマンドであるexecの引数として渡されたコマンドが実行できない場合でも、非対話的なシェルが終了せず次の処理にを開始するようになる
- expand_aliases … 有効になっている場合、エイリアスが展開されるようになる(対話型シェルであればデフォルトで有効)
- extdebug … 有効になっている場合、デバックのための動作が有効になる
- extglob … 有効になっている場合、拡張されたパターンマッチング機能が利用できるようになる
- extquote … 有効になっている場合、ダブルクォート中の${変数}の展開で、$’string’と$”string”のクォートが機能するようになる(デフォルトで有効)
- failglob … 有効になっている場合、パス名展開でパターンがファイル名のマッチに失敗すると展開エラーになる
- force_fignore … 有効になっている場合、単語補完時にシェル変数FIGNOREで指定されたサフィックスの単語は無視される(デフォルトで有効)
- globstar … 有効になっている場合、** というパターンがパス名展開で使われる場合、深さ0以上のディレクトリやサブディレクトリの全てのファイルにマッチする。直後に/が続く場合には、ディレクトリとサブディレクトリのみにマッチする
- gnu_errfmt … 有効になっている場合、bashのエラーメッセージはGNU標準フォーマットで出力されるようになる
- histappend … 有効になっている場合、の終了時に変数 HISTFILE の値で指定しているファイルに履歴が追加され、ファイルへの上書きは行われなくなる
- histreedit … この設定が有効時にreadlineが使われている場合、ユーザは失敗した履歴置換を再編集できる
- histverify … この設定が有効時にreadlineが使われている場合、履歴置換の結果が即座にシェルのパーザに渡されないようなり、結果として得られた行はreadline の編集バッファに読み込まれさらに修正できるようになる
- hostcomplete … この設定が有効時にreadlineが使われている場合、bashは@を含む単語を補完するときにホスト名補完を行おうとする(デフォルトで有効)
- huponexit … 有効になっている場合、対話的なログインシェル終了時にすべてのジョブに対してSIGHUPシグナルを送信する
- interactive_comments … 有効になっている場合、#で始まる行については、その行の#以降の内容を無視させることができる(デフォルトで有効)
- lastpipe … この設定が有効時にジョブ設定も有効出ない場合なら、bashはバックグラウンドでの実行ではないパイプラインの最後のコマンドを現在のシェル環境で実行する
- lithist … この設定とcmdhistが有効の場合、複数行に別れている履歴はセミコロンではなく改行区切りで履歴に保存される
- login_shell … シェルがログインシェルとして使用された場合に有効になる。変更不可。
- mailwarn … この設定が有効、かつbashがメールのチェックに使うファイルが 前回のチェック以降にアクセスされている場合、メッセージ 「The mail in mailfile has been read」が表示される
- no_empty_cmd_completion … この設定が有効時にreadlineが使われている場合、bashは空行に対してコマンド補完を行った際に補完候補をPATHから検索しない
- nocaseglob … 有効になっている場合、glob展開時にファイルの大文字・小文字を区別せずにマッチさせる
- nocasematch … 有効になっている場合、caseや[[での パターンマッチで大文字・小文字を区別せずにマッチさせる
- nullglob … 有効になっている場合、どのファイルにもマッチしないパターンを空文字列に展開する
- progcomp … 有効になっている場合、プログラム補完機能が利用できるようになる(デフォルトで有効)
- promptvars … 有効になっている場合、プロンプト文字列に対してパラメータ展開、コマンド置換、算術式展開、クォート削除が行われる(デフォルトで有効)
- restricted_shell … シェルが制限付きモード(rbashや-rオプションでの起動)で起動した場合に有効になる。変更不可。
- shift_verbose … 有効になっている場合、組み込みコマンドshiftでシフトの回数が位置パラメータの数を超えた場合、エラーメッセージを出力する
- sourcepath … 有効になっている場合、組み込みコマンドsource(.)はPATHの値を利用して引数に与えられたファイルやディレクトリを探す(デフォルトで有効)
- xpg_echo … 有効になっている場合、組み込みコマンドechoはデフォルトでバックスラッシュによるエスケープシーケンスを展開する

<br/>

目次<br/>
[autocd](#autocd)<br/>
[cdable_vars](#cdable_vars)<br/>
[cdspell](#cdspell)<br/>
[direxpand](#direxpand)<br/>
[dirspell](#dirspell)<br/>
[dotglob](#dotglob)<br/>
[execfail](#execfail)<br/>
[extglob](#extglob)<br/>
[failglob](#failglob)<br/>
[globstar](#globstar)<br/>
[nocaseglob](#nocaseglob)<br/>
[nocasematch](#nocasematch)<br/>
[nullglob](#nullglob)<br/>
[xpg_echo](#xpg_echo)<br/>

### autocd
この設定が有効になっていると、対話モードの時にディレクトリのpathだけを渡せばcdコマンドに渡されたもとのして扱ってくれる。<br/>
大体、以下の様な感じ。<br/>

<pre>
[root@BS-PUB-CENT7-01 ~]# shopt -u autocd
[root@BS-PUB-CENT7-01 ~]# /var/log
-bash: /var/log: ディレクトリです
[root@BS-PUB-CENT7-01 ~]#
[root@BS-PUB-CENT7-01 ~]# shopt -s autocd
[root@BS-PUB-CENT7-01 ~]# /var/log
cd /var/log
[root@BS-PUB-CENT7-01 log]# pwd
/var/log
</pre>
<br/>

### cdable_vars
この設定を有効にすると、ディレクトリPATHではない値をcdで渡された場合、その値を変数とみなして扱ってくれる。<br/>
以下、実行例。<br/>

<pre>
[root@BS-PUB-CENT7-01 ~]# OPTDIR=/opt
[root@BS-PUB-CENT7-01 ~]# echo $OPTDIR
/opt
[root@BS-PUB-CENT7-01 ~]#
[root@BS-PUB-CENT7-01 ~]# shopt -u cdable_vars
[root@BS-PUB-CENT7-01 ~]# cd OPTDIR
-bash: cd: OPTDIR: そのようなファイルやディレクトリはありません
[root@BS-PUB-CENT7-01 ~]#
[root@BS-PUB-CENT7-01 ~]# shopt -s cdable_vars
[root@BS-PUB-CENT7-01 ~]# cd OPTDIR
/opt
[root@BS-PUB-CENT7-01 opt]# pwd
/opt
</pre>
<br/>

### cdspell
この設定を有効にすると、cd時にスペルミスをしたディレクトリを指定しても、存在するディレクトリを推測してよしなにディレクトリを移動してくれる。<br/>
以下が実行例。<br/>

<pre>
[root@BS-PUB-CENT7-01 ~]# shopt -u cdspell
[root@BS-PUB-CENT7-01 ~]# cd /var/lgo/
-bash: cd: /var/lgo/: そのようなファイルやディレクトリはありません
[root@BS-PUB-CENT7-01 ~]#
[root@BS-PUB-CENT7-01 ~]# shopt -s cdspell
[root@BS-PUB-CENT7-01 ~]# cd /var/lgo/
/var/log/
[root@BS-PUB-CENT7-01 log]# cd /op
/opt
[root@BS-PUB-CENT7-01 opt]# cd /tmpw
/tmp
</pre>
<br/>

### direxpand
この設定が有効になっている場合、指定された変数の中身がもしディレクトリ(たとえば、「$PWD/」のように末尾にディレクトリがあるなど)だった場合、tabキー押下時に変数を展開してくれる。<br/>

<pre>
[root@BS-PUB-CENT7-01 ~]# OPTDIR=/opt
[root@BS-PUB-CENT7-01 ~]# echo $OPTDIR
/opt
[root@BS-PUB-CENT7-01 ~]# ls -la $OPTDIR/
合計 4
drwxr-xr-x.  5 root root   42  4月  9 00:01 .
dr-xr-xr-x. 17 root root 4096  1月 20 00:01 ..
drwxr-xr-x.  2 root root   21  4月  9 00:01 test1
drwxr-xr-x.  2 root root    6  4月  9 00:01 test2
drwxr-xr-x.  2 root root    6  4月  9 00:01 test3
[root@BS-PUB-CENT7-01 ~]# ls -la $OPTDIR/
                          ↓tabキー押下
[root@BS-PUB-CENT7-01 ~]# ls -la $OPTDIR/test
ls: /opt/test にアクセスできません: そのようなファイルやディレクトリはありません
[root@BS-PUB-CENT7-01 ~]#
[root@BS-PUB-CENT7-01 ~]# shopt -s direxpand
[root@BS-PUB-CENT7-01 ~]# ls -la $OPTDIR/
                          ↓tabキー押下
[root@BS-PUB-CENT7-01 ~]# ls -la /opt/
</pre>
<br/>

### dirspell
このオプションを有効にすると、間違ったスペルに対してtab補完を行っても補正して推測した値で補完を行ってくれる。<br/>
ただ、中間ディレクトリが間違っててもそこを補正してくれないので使いどころによるかも。。。<br/>
実際に実行した際の結果が以下。<br/>

<pre>
[root@BS-PUB-CENT7-01 ~]# shopt -u dirspell
[root@BS-PUB-CENT7-01 ~]# ls -la /var/lag/aud
                          ↓tabキー押下
[root@BS-PUB-CENT7-01 ~]# ls -la /var/lag/aud
[root@BS-PUB-CENT7-01 ~]# 
[root@BS-PUB-CENT7-01 ~]# shopt -s dirspell
[root@BS-PUB-CENT7-01 ~]# ls -la /var/lag/aud
                          ↓tabキー押下
[root@BS-PUB-CENT7-01 ~]# ls -la /var/lag/audit
</pre>
<br/>

### dotglob
このオプションを有効にすると、ドット(.)で始まる隠しファイルについてもglobのワイルドカードなどのマッチに含めるようにできる。<br/>
以下、実行例。<br/>

<pre>
[root@BS-PUB-CENT7-01 ~]# ls -la /opt/
合計 12
drwxr-xr-x.  5 root root   65  4月  9 20:00 .
dr-xr-xr-x. 17 root root 4096  1月 20 00:01 ..
-rw-r--r--.  1 root root    9  4月  9 20:01 .test
-rw-r--r--.  1 root root    5  4月  9 20:01 test
drwxr-xr-x.  2 root root   21  4月  9 00:01 test1
drwxr-xr-x.  2 root root    6  4月  9 00:01 test2
drwxr-xr-x.  2 root root    6  4月  9 00:01 test3
[root@BS-PUB-CENT7-01 ~]# cat /opt/.test
dot.test
[root@BS-PUB-CENT7-01 ~]# cat /opt/test
test
[root@BS-PUB-CENT7-01 ~]#
[root@BS-PUB-CENT7-01 ~]# ls /opt/*
/opt/test

/opt/test1:
test.txt

/opt/test2:

/opt/test3:
[root@BS-PUB-CENT7-01 ~]#
[root@BS-PUB-CENT7-01 ~]# shopt -s dotglob
[root@BS-PUB-CENT7-01 ~]# ls /opt/*
/opt/.test  /opt/test

/opt/test1:
test.txt

/opt/test2:

/opt/test3:
</pre>
<br/>

### execfail
execfailを有効にすると、非対話でexecコマンドを実行した際に、execコマンドで指定したコマンドが実行できなかった場合でも次の処理が行えるようになる。<br/>

<pre>
[root@BS-PUB-CENT7-01 ~]# bash -c 'shopt -s execfail;exec ech a;echo b'
bash: 0 行: exec: ech: 見つかりません
b
[root@BS-PUB-CENT7-01 ~]# bash -c 'shopt -u execfail;exec ech a;echo b'
bash: 0 行: exec: ech: 見つかりません
</pre>
<br/>

### extglob
このオプションを有効にすることで、bashで拡張globが利用できるようになる。<br/>
使い方については前にここに記述しているので、そちらを参照してもらいたい。<br/>
通常のglobでは利用できない否定でのファイル指定なども扱えるので、結構便利に使えると思う。<br/>
以下、実行例。<br/>

<pre>
[root@BS-PUB-CENT7-01 ~]# ls -la
合計 44
dr-xr-x---.  4 root root 4096  4月  8 23:52 .
dr-xr-xr-x. 18 root root 4096  4月  9 20:24 ..
-rw-------.  1 root root 6704  4月  9 19:27 .bash_history
-rw-r--r--.  1 root root   18 12月 29  2013 .bash_logout
-rw-r--r--.  1 root root  176 12月 29  2013 .bash_profile
-rw-r--r--.  1 root root  176 12月 29  2013 .bashrc
drwx------.  3 root root   16  4月  8 23:52 .cache
-rw-r--r--.  1 root root  100 12月 29  2013 .cshrc
drwxr-----.  3 root root   18  4月  8 23:52 .pki
-rw-r--r--.  1 root root  129 12月 29  2013 .tcshrc
-rw-------.  1 root root  847  1月 19 23:59 .viminfo
-rw-------.  1 root root  986  1月  1  2016 anaconda-ks.cfg
[root@BS-PUB-CENT7-01 ~]#
[root@BS-PUB-CENT7-01 ~]# shopt -s extglob
[root@BS-PUB-CENT7-01 ~]# ls -la /work/!(test*)
-rw-r--r--. 1 root root 0  4月  9 20:25 /work/tea
[root@BS-PUB-CENT7-01 ~]# ls -la /work/!(*10)
-rw-r--r--. 1 root root 0  4月  9 20:25 /work/tea
-rw-r--r--. 1 root root 0  4月  9 20:24 /work/test1
-rw-r--r--. 1 root root 0  4月  9 20:24 /work/test2
-rw-r--r--. 1 root root 0  4月  9 20:24 /work/test3
-rw-r--r--. 1 root root 0  4月  9 20:24 /work/test4
-rw-r--r--. 1 root root 0  4月  9 20:24 /work/test5
-rw-r--r--. 1 root root 0  4月  9 20:24 /work/test6
-rw-r--r--. 1 root root 0  4月  9 20:24 /work/test7
-rw-r--r--. 1 root root 0  4月  9 20:24 /work/test8
-rw-r--r--. 1 root root 0  4月  9 20:24 /work/test9
</pre>
<br/>

### failglob
この設定を有効にすると、globで該当するファイルが存在しない場合はその時点でNo matchでエラーを返してくれるようになる。<br/>
以下、実行例。<br/>

<pre>
[root@BS-PUB-CENT7-01 work]# ls -la /work
合計 8
drwxr-xr-x.  2 root root 4096  4月  9 20:34 .
dr-xr-xr-x. 18 root root 4096  4月  9 20:24 ..
-rw-r--r--.  1 root root    0  4月  9 20:25 tea.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test1.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test10.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test2.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test3.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test4.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test5.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test6.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test7.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test8.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test9.txt
[root@BS-PUB-CENT7-01 work]#
[root@BS-PUB-CENT7-01 work]# shopt -u failglob
[root@BS-PUB-CENT7-01 work]# ls -la /work/*.bk
ls: /work/*.bk にアクセスできません: そのようなファイルやディレクトリはありません
[root@BS-PUB-CENT7-01 work]#
[root@BS-PUB-CENT7-01 work]# shopt -s failglob
[root@BS-PUB-CENT7-01 work]# ls -la /work/*.bk
-bash: 一致しません: /work/*.bk
</pre>
<br/>

### globstar
この設定を有効にすると、**というワイルドカード指定で対象ディレクトリ配下のすべてのサブディレクトリ、ファイルを再帰的に指定することができる。<br/>

<pre>
[root@BS-PUB-CENT7-01 work]# shopt -u globstar
[root@BS-PUB-CENT7-01 work]# ls /opt/**
/opt/.test  /opt/test

/opt/test1:
test  test.txt

/opt/test2:
test

/opt/test3:
test
[root@BS-PUB-CENT7-01 work]#
[root@BS-PUB-CENT7-01 work]# shopt -s globstar
[root@BS-PUB-CENT7-01 work]# ls /opt/**
/opt/.test  /opt/test1/test.txt   /opt/test2/test/test
/opt/test   /opt/test1/test/test  /opt/test3/test/test

/opt/:
test  test1  test2  test3

/opt/test1:
test  test.txt

/opt/test1/test:
test

/opt/test2:
test

/opt/test2/test:
test

/opt/test3:
test

/opt/test3/test:
test
</pre>
<br/>


### nocaseglob
この設定を有効にすると、globの展開時に大文字・小文字を区別せずに処理を行ってくれるようになる。<br/>

<pre>
[root@BS-PUB-CENT7-01 work]# ls -la
合計 8
drwxr-xr-x.  2 root root 4096  4月  9 20:51 .
dr-xr-xr-x. 18 root root 4096  4月  9 20:24 ..
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST01.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST02.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST03.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST04.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST05.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST06.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST07.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST08.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST09.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST10.txt
-rw-r--r--.  1 root root    0  4月  9 20:25 tea.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test1.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test10.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test2.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test3.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test4.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test5.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test6.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test7.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test8.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test9.txt
[root@BS-PUB-CENT7-01 work]#
[root@BS-PUB-CENT7-01 work]# shopt -u nocaseglob
[root@BS-PUB-CENT7-01 work]# ls -la TEST*
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST01.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST02.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST03.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST04.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST05.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST06.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST07.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST08.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST09.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST10.txt
[root@BS-PUB-CENT7-01 work]#
[root@BS-PUB-CENT7-01 work]# shopt -s nocaseglob
[root@BS-PUB-CENT7-01 work]# ls -la TEST*
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST01.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST02.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST03.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST04.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST05.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST06.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST07.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST08.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST09.txt
-rw-r--r--. 1 root root 0  4月  9 20:51 TEST10.txt
-rw-r--r--. 1 root root 0  4月  9 20:24 test1.txt
-rw-r--r--. 1 root root 0  4月  9 20:24 test10.txt
-rw-r--r--. 1 root root 0  4月  9 20:24 test2.txt
-rw-r--r--. 1 root root 0  4月  9 20:24 test3.txt
-rw-r--r--. 1 root root 0  4月  9 20:24 test4.txt
-rw-r--r--. 1 root root 0  4月  9 20:24 test5.txt
-rw-r--r--. 1 root root 0  4月  9 20:24 test6.txt
-rw-r--r--. 1 root root 0  4月  9 20:24 test7.txt
-rw-r--r--. 1 root root 0  4月  9 20:24 test8.txt
-rw-r--r--. 1 root root 0  4月  9 20:24 test9.txt
</pre>
<br/>

### nocasematch
このオプションを有効にすると、caseや[[でのパターンマッチ時に大文字・小文字を区別しないで比較してくれるようになる。<br/>

<pre>
[root@BS-PUB-CENT7-01 work]# shopt -u nocasematch
[root@BS-PUB-CENT7-01 work]# if [[ "test" = "TEST" ]]; then echo ok; else echo ng; fi
ng
[root@BS-PUB-CENT7-01 work]#
[root@BS-PUB-CENT7-01 work]# shopt -s nocasematch
[root@BS-PUB-CENT7-01 work]# if [[ "test" = "TEST" ]]; then echo ok; else echo ng; fi
ok
</pre>
<br/>

### nullglob
この設定を有効にすると、glob展開時に該当するものがなかった場合に、エラーではなく0個の文字列として返してくれるようになる。<br/>
以下に実行例を記載。<br/>

<pre>
[root@BS-PUB-CENT7-01 ~]# cd /work
[root@BS-PUB-CENT7-01 work]# ls -la
合計 8
drwxr-xr-x.  2 root root 4096  4月  9 20:51 .
dr-xr-xr-x. 18 root root 4096  4月  9 20:24 ..
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST01.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST02.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST03.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST04.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST05.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST06.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST07.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST08.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST09.txt
-rw-r--r--.  1 root root    0  4月  9 20:51 TEST10.txt
-rw-r--r--.  1 root root    0  4月  9 20:25 tea.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test1.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test10.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test2.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test3.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test4.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test5.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test6.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test7.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test8.txt
-rw-r--r--.  1 root root    0  4月  9 20:24 test9.txt
[root@BS-PUB-CENT7-01 work]# shopt -u nullglob
[root@BS-PUB-CENT7-01 work]# echo *.bk
*.bk
[root@BS-PUB-CENT7-01 work]# shopt -s nullglob
[root@BS-PUB-CENT7-01 work]# echo *.bk
[root@BS-PUB-CENT7-01 work]#
</pre>
<br/>

### xpg_echo
この設定を有効にしておくと、echoの動作が-eを付与した際と同様(制御文字をechoした際にそれを展開してくれるようになる)の動きになる。<br/>

<pre>
[root@BS-PUB-CENT7-01 work]# shopt -u xpg_echo
[root@BS-PUB-CENT7-01 work]# echo "Hello\nworld"
Hello\nworld
[root@BS-PUB-CENT7-01 work]# echo -e "Hello\nworld"
Hello
world
[root@BS-PUB-CENT7-01 work]#
[root@BS-PUB-CENT7-01 work]# shopt -s xpg_echo
[root@BS-PUB-CENT7-01 work]# echo "Hello\nworld"
Hello
world
</pre>
<br/>
