## [addr2lineを使ってスタックトレースから取得したアドレスをソースファイル名と行番号に変換する](https://qiita.com/nanashi/items/829beda77daab0696463)

## [addr2line - アドレスをファイル名と行番号に変換する](http://manpages.ubuntu.com/manpages/bionic/ja/man1/addr2line.1.html)

### 名前
<pre>
       addr2line - アドレスをファイル名と行番号に変換する
</pre>	 

### 書式
<pre>
       addr2line
              [-b bfdname | --target=bfdname] [-C|--demangle] [-e filename | --exe=filename]
              [-f|--functions] [-s|--basenames] [-H|--help] [-V|--version] [addraddr...]
</pre>

### 説明
<pre>
       addr2line はプログラム内のアドレスをファイル名と行番号に変換する。アドレスと実行  ファイル
       が与えられると、  addr2line は実行ファイルのデバッグ情報を用いて、アドレスに関連付けられて
       いるファ イル名と行番号を求める。

       実行ファイルは -e オプションを用いて指定できる。デフォルトは a.out である。

       addr2line には二つの実行モードがある。

       最初のモードでは、コマンドラインで 16 進数のアドレスを指定する。 addr2line  はそれぞれのア
       ドレスに対してファイル名と行番号を表示する。

       二つめのモードでは、  addr2line は 16 進数のアドレスを標準入力から読み込み、それぞれのアド
       レスに対応す るファイル名と行番号を標準出力に表示する。このモードでは addr2line は動的に選
       択されたアドレスを変換するパイプとして用いることができる。

       出力フォーマットは「ファイル名:行番号」である。各アドレスに対 応してこのペアが行ごとに表示
       される。 -f オプションが用いられると、「ファイル名:行番号」の行それぞれの前に 「関数名」行
       が置かれる。これはそのアドレスが所属する関数の名前である。

       ファイル名または関数の名前が決定できない場合は、   addr2line  は代わりに二つのクエスチョン
       マークを表示する。行番号が決定できない場合 は、 addr2line は 0 を表示する。
</pre>

### オプション
       -b bfdname

       --target=bfdname
              オブジェクトファイルのオブジェクトコードフォーマットを bfdname として取り扱う。

       -C

       --demangle
              低レベルのシンボル名をユーザーレベルのシンボル名にデコード (demangle)  する。このと
              きシステムによって前置されたアンダースコ  アも削除される。この操作によって C++ の関
              数名が可読になる。

       -e filename

       --exe=filename
              アドレスを変換したい実行ファイルの名前を指定する。デフォルトのファイル は a.out  で
              ある。

       -f

       --functions
              ファイル名や行番号の情報と共に関数の名前も表示する。

       -s

       --basenames
              それぞれのファイル名のベースのみを表示する (ディレクトリを表示しない)。
</pre>

### 関連項目
<pre>
       info の ` binutils ' エントリ、 The GNU Binary Utilities, Roland H. Pesch (October 1991)、
</pre>
