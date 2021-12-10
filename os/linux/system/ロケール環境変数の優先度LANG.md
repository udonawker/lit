```
$ locale
LANG=ja_JP.UTF-8
LC_CTYPE="ja_JP.UTF-8"
LC_NUMERIC="ja_JP.UTF-8"
LC_TIME="ja_JP.UTF-8"
LC_COLLATE="ja_JP.UTF-8"
LC_MONETARY="ja_JP.UTF-8"
LC_MESSAGES="ja_JP.UTF-8"
LC_PAPER="ja_JP.UTF-8"
LC_NAME="ja_JP.UTF-8"
LC_ADDRESS="ja_JP.UTF-8"
LC_TELEPHONE="ja_JP.UTF-8"
LC_MEASUREMENT="ja_JP.UTF-8"
LC_IDENTIFICATION="ja_JP.UTF-8"
LC_ALL=
```

* LANG	：	システム全体のロケール
* LC_CTYPE	：	文字の種別および大文字/小文字の変換を指定
* LC_NUMERIC	：	1000単位の区切り文字など金額に関係しない数値で使用される表示方法を指定
* LC_TIME	：	日付や時刻の書式を指定
* LC_COLLATE	：	並び換えや正規表現で使われる照合順序を指定
* LC_MONETARY	：	通貨の書式を指定
* LC_MESSAGES	：	肯定/否定の応答の表示と通知やメニューの言語を指定
* LC_PAPER	：	標準的な用紙サイズを指定
* LC_NAME	：	名前を呼ぶ際のフォーマット(Mr.やMs.など）を指定
* LC_ADDRESS	：	住所に使用するフォーマットおよびロケーション情報を指定
* LC_TELEPHONE	：	電話番号の書式を指定
* LC_MEASUREMENT	：	メートルなど計算単位を指定
* LC_IDENTIFICATION	：	ロケール情報に関するメタデータを指定
* LC_ALL	：	全LC_*環境変数を設定

実行例の末尾にある LC_ALL は、他のすべてのロケール環境変数の値よりも優先されます。<br>
そのため、LC_ALLを設定した場合、LC_ALLを除くLC_から始まる環境変数(以降：LC_*)もすべて上書きされ、他の値に変更できなくなります。<br>

LC_ALLが未定義の場合、ロケールはLANGとLC_*が適用されます。 LANGの環境変数には、デフォルトのロケールを設定することができ、LC_*の環境変数には、カテゴリー情報に使用するロケールを設定できます。<br>
LANGに設定したロケールは、LC_ALLを除くLC_*すべてに反映されますが、LC_*ごとに別のロケール設定を変更することが可能です。<br>
そのため、ロケールの設定は、LANGよりもLC_*が優先されます。<br>

以下は、時刻表記だけを英語表記にする例です。<br>
ロケール設定が「ja_JP.UTF-8」の場合、日本語環境となります。この場合、時刻表示も日本語で表示されます。<br>

### ▼ロケール設定を確認
```
$ locale
LANG=ja_JP.UTF-8
(省略)
LC_TIME="ja_JP.UTF-8"
(省略)
LC_ALL=
```

### ▼dateコマンドで時刻表示
```
$ date
2021年 11月 10日 水曜日 10:13:23 JST
```
時刻表示だけを英語表記にしたい場合、LC_TIMEを変更します。<br>
LC_TIME=Cを設定すると、出力結果を日本語翻訳せず、デフォルトの英語表記で出力します。<br>

### ▼LC_TIMEのみ英語表記に変更
```
$ export LC_TIME=C

$ locale
LANG=ja_JP.UTF-8
(省略)
LC_TIME=C
(省略)
LC_ALL=
```

### ▼dateコマンドで時刻表示
```
$ date
Wed Nov 10 10:14:41 JST 2021
```

なお、時刻表示以外のviなどは日本語を表示することができます。<br>

### ▼viコマンドで日本語を表示
```
$ vi test
テスト
```

LC_ALLを設定した場合は、他のすべてのロケール環境変数の値よりも優先されます。<br>
そのため、LC_ALL=Cを設定した場合、すべて英語表記となります。<br>

### ▼LC_ALLを英語表記に変更
```
$ export LC_ALL=C

$ locale
LANG=ja_JP.UTF-8
(省略)
LC_TIME="C"
(省略)
LC_ALL=C
```

### ▼dateコマンドで時刻表示
```
$ date
Wed Nov 10 10:14:41 JST 2021
```
また、英語表記の環境では日本語が表示できないため、以下のように文字化けします。<br>

### ▼viコマンドで日本語を表示
```
$ vi test
筐C~F筐B鴻[8;5;81m~C~H
```

このように、LC_ALLを含むロケールの優先順位としては、LC_ALL → LC_* → LANG という順になります。<br>
よって「3. LC_ALL → LC_* → LANG」が正解となります。<br>

日本語が文字化けしてしまったときなど、ロケール設定が影響していることもあります。問題の切り分けを行うためにも、現在使用しているシステムのロケール設定を確認できるようにしておきましょう。<br>


###

