## [C++標準ライブラリのヘッダ一覧](https://qiita.com/yohhoy/items/9e2b14ed9f25e1fc62c1?utm_campaign=email&utm_content=link&utm_medium=email&utm_source=update_stocked_article)

See also: https://cppmap.github.io/standardization/header/<br>


## C++標準ライブラリ

---

|C++ヘッダ|Since|概要|
|:--|:--|:--|
|&lt;algorithm&gt;|-|汎用アルゴリズム各種|
|&lt;any&gt;|C++17|any型|
|&lt;array&gt;|C++11|固定長配列array&lt;T,N&gt;|
|&lt;atomic&gt;|C++11|atomic変数|
|&lt;barrier&gt;|C++20|スレッド同期バリア|
|&lt;bit&gt;|C++20|ビット操作各種|
|&lt;bitset&gt;|-|ビット集合bitset&lt;N&gt;|
|&lt;charconv&gt;|C++17|文字⇄数値変換|
|&lt;chrono&gt;|C++11|時間・日付ライブラリ|
|&lt;compare&gt;|C++20|三方比較演算(&lt;=&gt;)サポート|
|&lt;complex&gt;|-|複素数complex&lt;T&gt;|
|&lt;concepts&gt;|C++20|コンセプトライブラリ|
|&lt;condition_variable&gt;|C++11|スレッド条件変数|
|&lt;coroutine&gt;|C++20|低レイヤなコルーチンサポート|
|&lt;deque&gt;|-|両端キューdeque&lt;T&gt;|
|&lt;exception&gt;|-|例外ハンドリング|
|&lt;execution&gt;|C++17|アルゴリズム並列実行指定|
|&lt;expected&gt;|C++23|expected&lt;T,E&gt;型|
|&lt;filesystem&gt;|C++17|ファイルシステム|
|&lt;flat_map&gt;|C++23|フラットマップflat_map&lt;K,V&gt;|
|&lt;flat_set&gt;|C++23|フラット集合flat_set&lt;T&gt;|
|&lt;format&gt;|C++20|文字列フォーマット|
|&lt;forward_list&gt;|C++11|単方向リストforward_list&lt;T&gt;|
|&lt;fstream&gt;|-|ファイルストリーム|
|&lt;functional&gt;|-|関数アダプタ各種|
|&lt;future&gt;|C++11|スレッド同期Future/Promise|
|&lt;generator&gt;|C++23|ジェネレータコルーチン|
|&lt;initializer_list&gt;|C++11|初期化子リストサポート|
|&lt;iomanip&gt;|-|I/Oマニピュレータ|
|&lt;ios&gt;|-|I/Oストリーム基底クラス|
|&lt;iosfwd&gt;|-|I/Oストリーム前方宣言ヘッダ|
|&lt;iostream&gt;|-|I/O入出力ストリーム|
|&lt;istream&gt;|-|I/O入力ストリーム|
|&lt;iterator&gt;|-|イテレータサポート|
|&lt;latch&gt;|C++20|スレッド同期ラッチ|
|&lt;limits&gt;|-|数値型特性|
|&lt;list&gt;|-|双方向リストlist&lt;T&gt;|
|&lt;locale&gt;|-|ロケールサポート|
|&lt;map&gt;|-|マップmap&lt;K,V&gt;|
|&lt;mdspan&gt;|C++23|多次元区間ビューmdspan&lt;E&gt;|
|&lt;memory&gt;|-|高レイヤなメモリ動的管理サポート|
|&lt;memory_resource&gt;|C++17|多相アロケータ|
|&lt;mutex&gt;|C++11|スレッド排他制御|
|&lt;new&gt;|-|低レイヤなメモリ動的管理サポート|
|&lt;numbers&gt;|C++20|数学定数|
|&lt;numeric&gt;|-|数値アルゴリズム各種|
|&lt;optional&gt;|C++17|optional&lt;T&gt;型|
|&lt;ostream&gt;|-|I/O出力ストリーム|
|&lt;print&gt;|C++23|print,println関数|
|&lt;queue&gt;|-|FIFOキューqueue&lt;T&gt;|
|&lt;random&gt;|C++11|乱数ライブラリ|
|&lt;ranges&gt;|C++20|範囲(Ranges)ライブラリ|
|&lt;ratio&gt;|C++11|コンパイル時有理数型|
|&lt;regex&gt;|C++11|正規表現ライブラリ|
|&lt;scoped_allocator&gt;|C++11|ネストメモリアロケータ|
|&lt;semaphore&gt;|C++20|スレッド同期セマフォ|
|&lt;set&gt;|-|集合set&lt;T&gt;|
|&lt;shared_mutex&gt;|C++14|スレッド共有/排他制御|
|&lt;source_location&gt;|C++20|ソースコード位置情報アクセス|
|&lt;span&gt;|C++20|区間ビューspan&lt;E&gt;|
|&lt;spanstream&gt;|C++23|I/Oメモリ区間ストリーム|
|&lt;sstream&gt;|-|I/O文字列ストリーム|
|&lt;stack&gt;|-|LIFOスタックstack&lt;T&gt;|
|&lt;stacktrace&gt;|C++23|スタックトレース|
|&lt;stdexcept&gt;|-|標準例外クラス|
|&lt;stdfloat&gt;|C++23|拡張浮動小数点数型|
|&lt;stop_token&gt;|C++20|スレッド停止トークン|
|&lt;streambuf&gt;|-|I/Oストリームバッファ|
|&lt;string&gt;|-|文字列string|
|&lt;string_view&gt;|C++17|文字列ビューstring_view|
|&lt;syncstream&gt;|C++20|スレッド同期ストリーム|
|&lt;system_error&gt;|C++11|システム例外|
|&lt;thread&gt;|C++11|スレッドサポート|
|&lt;tuple&gt;|C++11|タプルtuple&lt;Ts..&gt;|
|&lt;typeindex&gt;|C++11|型情報インデクスtype_index|
|&lt;typeinfo&gt;|-|RTTIサポート|
|&lt;type_traits&gt;|C++11|型特性メタ関数群|
|&lt;unordered_map&gt;|C++11|ハッシュマップunordered_map&lt;K,V&gt;|
|&lt;unordered_set&gt;|C++11|ハッシュ集合unordered_set&lt;K&gt;|
|&lt;utility&gt;|-|雑多な関数群|
|&lt;valarray&gt;|-|数値配列valarray&lt;T&gt;|
|&lt;variant&gt;|C++17|variant&lt;Ts...&gt;型|
|&lt;vector&gt;|-|可変長配列vector&lt;T&gt;|
|&lt;version&gt;|C++20|処理系定義のライブラリ情報|


非推奨(deprecated)なC++ヘッダ<br>

|C++ヘッダ|追加／削除時期|
|:--|:--|
|&lt;codecvt&gt;|C++11追加/C++17非推奨|
|&lt;strstream&gt;|C++03非推奨|

<br>
<br>

## Cライブラリ互換ヘッダ


|C++ヘッダ|概要|Since|
|:--|:--|:--|
|&lt;cassert&gt;|assertマクロ||
|&lt;cctype&gt;|文字クラス判定||
|&lt;cerrno&gt;|エラーコード定義||
|&lt;cfenv&gt;|浮動小数点数環境操作||
|&lt;cfloat&gt;|浮動小数点数型境界マクロ||
|&lt;climits&gt;|整数型境界マクロ||
|&lt;clocale&gt;|ロケール操作||
|&lt;cmath&gt;|数学関数||
|&lt;csetjmp&gt;|setjmp/longjmp||
|&lt;csignal&gt;|シグナル操作||
|&lt;cstdarg&gt;|可変長リスト操作||
|&lt;cstddef&gt;|標準マクロ／標準型||
|&lt;cstdio&gt;|入出力操作||
|&lt;cstdlib&gt;|雑多な関数群||
|&lt;cstring&gt;|C文字列操作||
|&lt;ctime&gt;|時刻操作||
|&lt;cwchar&gt;|ワイド文字・マルチバイト文字操作||
|&lt;cwctype&gt;|ワイド文字クラス判定||
|&lt;cstdint&gt;|幅指定整数型|C++11|
|&lt;cinttypes&gt;|幅指定整数型用の書式マクロなど|C++11|
|&lt;cuchar&gt;|Unicode文字コード変換|C++11|

非推奨／削除済みのC++ヘッダ<br>

|C++ヘッダ|追加／削除時期|
|:--|:--|
|&lt;ciso646&gt;|C++20削除|
|&lt;ccomplex&gt;|C++11追加/C++17非推奨/C++20削除|
|&lt;cstdalign&gt;|C++11追加/C++17非推奨/C++20削除|
|&lt;cstdbool&gt;|C++11追加/C++17非推奨/C++20削除|
|&lt;ctgmath&gt;|C++11追加/C++17非推奨/C++20削除|
