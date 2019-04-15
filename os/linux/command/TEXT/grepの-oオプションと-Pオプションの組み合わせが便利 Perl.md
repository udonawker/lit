引用 
[grepの-oオプションと-Pオプションの組み合わせが便利](http://greymd.hatenablog.com/entry/2014/09/27/154305 "grepの-oオプションと-Pオプションの組み合わせが便利")

<pre>
$ paste <(cat score | grep -oP '[^\d]+') <(cat score | grep -oP '\d+') | xargs -n 2
</pre>
上記のようにgrepコマンドを叩いていたら「-oPってオプションなに？」と言われたので。<br/>
<br/>

# grep -oPって？

**-oオプションとは**

--only-matchingの略。マッチした部分のみを抽出するというオプションのこと。

<pre>
$ echo "123abc456dfg" | grep -o [a-z]
a
b
c
d
f
g
</pre>

**-Pオプションとは**

マッチさせる文字列にPerlで使われているものと同じ正規表現(Perl正規表現)をつかえるようにする。PerlのP。

**普通の正規表現とPerl正規表現の違いって？**

- 一部のメタ文字が使える [参照](http://www.kent-web.com/perl/chap7.html "参照")

  - \d、\D、\w、\W、などなど

- 最長一致、最短一致 [参照](http://www.megasoft.co.jp/mifes/seiki/about.html "参照")

  - A+ だけじゃなく A+?

- 先読み、後読み [参照](http://d.hatena.ne.jp/a_bicky/20100530/1275195072 "参照")

  - (?<=hoge), (?=hoge)、など

これらの特徴はPerl正規表現のみであり、 拡張正規表現オプション（-E）をつけたとしても 使うことはできない。

**つまり-oPとすれば**

Perl正規表現でマッチした部分のみを抽出できる

<pre>
$ echo "123abc456dfg" | grep -oP '\d'
1
2
3
4
5
6
</pre>

# どんな時に使える？

grepだけでテキストの「行の抽出」と「切り出し」が同時に行える。

**具体例**

たとえばこんなexample.xmlという名前のXMLファイルがあったとする。<br/>
こいつからname要素内のテキスト、それも鍵カッコがついているもののみで、かつ（「」）で囲まれている中身だけを取り出したい。<br/>

<pre>


  
    「Cure Lovely」
  
  
    「Cure Princess」
  
  
    「Cure Honey」
  
  
    「Cure Fortune」
  
  
    Cure Gorilla
  
</pre>

"Cure Gorilla"以外の下のような出力を得たい。さあ、どうする？

<pre>
Cure Lovely
Cure Princess
Cure Honey
Cure Fortune
</pre>

- 安直に思いつく方法。

<pre>
$ cat example.xml |
  grep '「' |
  sed 's/.*「//' |
  sed 's/」.*//g'
</pre>

- XMLだからと言ってxpathを使うと逆に手間がかかる。

<pre>
$ cat example.xml |
  xmllint --xpath '//name[contains(./text(),"「")]/text()' - |
  nkf --numchar-input |
  sed -r 's/(「|」)/\n/g'
</pre>

- AWK先生

<pre>
$ cat example.xml |
  awk -F'[「」]' 'NF>2{print $2}'
</pre>

- sed先生

<pre>
$ cat example.xml |
  sed -nr '/「/{s/.*「//g;s/」.*//gp}'
</pre>

**実はgrepだけでいける**

<pre>
$ cat example.xml |
  grep -oP '(?<=「).+(?=」)'
</pre>

# しくみ

Perl正規表現の「先読み・後読み」のパターンで文字列をマッチさせたとしても、 (?～)の中の文字列に関しては、grepの出力時にはマッチした文字列としてみなされない。試しに--colorオプションをつけても、「先読み・後読み」でマッチした部分は色は変化しない。

- grep -oP '(?<=「).+(?=」)'

  - 先読みのマッチ部分 → 「
  - grepでマッチしたとみなされる部分 → .+
  - 後読みのマッチ部分 → 」

おそらくUNIXコマンド類の初学段階だと、awkやsedは文字列の「切り出し」、grepは「行の抽出」に使えるという認識になると思う。<br/>
そして、学んでいくにつれてawkやsedもまた、「切り出し」のみならず「行の抽出」も同時にできるということがわかってくる。<br/>
<br/>
しかし行の抽出にしか使えないと思われていたgrepも、実は-oPをつければ、文字列の「切り出し」にも使えますよというお話でした。
