## [wgetは保存せずに、直接展開できるんだよ。](https://takuya-1st.hatenablog.jp/entry/20120205/1328464011)

wget でファイルを保存して展開する。いつものパターンだけど。<br>
ファイル保存が、面倒くさいじゃん？<br>

### いつものパターンだけど、
```
wget http://example.com/hoge.tgz
tar zxvf hoge.tgz
```

面倒くさいじゃん。っていうか何も考えずに、いつものパラメータを書いてるだけでした。<br>

### 直接展開すればいいじゃん？
```
wget -O - 'http://sourceforge.jp/frs/redir.php?m=jaist&f=%2Fnkf%2F53171%2Fnkf-2.1.2.tar.gz' | tar zxvf -
```
標準出入力を経由して、直接展開すればいいじゃん。このほうが楽だよね。<br>
だって、ファイル保存して展開するの面倒くさいじゃん。<br>
これなら一行で終わるし。<br>

### 解説
```
wget -O - 
```
wget のオプションに -O を指定して、出力を - に指定した。<br>

```
-O
    wgetのファイル保存先
- （ハイフン）
    標準出力にする。
```
ということになる。

```
tar zxvf -
```
```
zxvf
    gzip を extractしながらverbose して
- （ハイフン）
    標準入力からファイルを受け取る
```
