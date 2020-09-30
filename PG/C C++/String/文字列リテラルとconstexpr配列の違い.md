## [文字列リテラルとconstexpr配列の違い]

私は、次の例でptrToArrayとptrToLiteralによって指摘されているものに違いがあるかどうか疑問に思っています。<br>
<pre>
constexpr char constExprArray[] = "hello";
const char* ptrToArray = constExprArray;

const char* ptrToLiteral = "hello";
</pre>

- constExprArrayと2つの"hello"リテラルがすべてコンパイル時定数lvaluesであることを理解していますか?
- もしそうなら、それらが実行可能ファイルにどのように格納されているかに違いはありますか、それとも純粋にコンパイラの実装やプラットフォーム固有のものですか?
- 彼らは実行時に異なった扱いを受けていますか?
- 他に何か知ってることは?

<br><br>
文字列リテラルとcharのconstexpr配列はほぼ同じです。どちらへのポインタもアドレス定数式です。定数式の要素では、lvalue-to-rvalue変換が許可されています。どちらも静的ストレージの持続時間があります。私が知っている唯一の違いは、文字列リテラルが配列を初期化できるのに対し、constexpr配列は初期化できないということです。<br>
<pre>
constexpr char a[] = "hello";

constexpr char b[] = a; // ill-formed
constexpr char b[] = "hello"; // ok
</pre>
これを回避するには、配列をリテラル型のクラスにラップすることができます。現在、std::string_literalなどと呼ばれるラッパーを標準化していますが、今のところ手作業でこれを行う必要があります。<br>
