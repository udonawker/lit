引用<br/>
[C++配列の参照、その書き方](https://onihusube.hatenablog.com/entry/2018/12/14/013900 "C++配列の参照、その書き方")<br/>
<br/>

### 変数宣言
<pre>
int array[]{ 1,2,3,4,5 };

//配列の参照宣言
int(&r2)[5] = array;

//decltype(r1) = int(&)[5]
auto& r1 = array;
</pre>

この様に、配列の参照を変数として書くときはT(&name)[N]のように書き、Tに型名、nameに変数名、Nに要素数、となります。<br/>
ただし、配列の型Tと要素数Nは参照先の配列と一致している必要があります（Nはコンパイル時に確定する必要があります）。<br/>
しかし、これは書き辛いし見辛いので、auto&を使ってコンパイラさんに推論してもらうのをお勧めします。<br/>
<br/>

### 引数宣言

<pre>
//int型の5要素の配列を受け取る
void f(int(&array)[5]) {
    for(auto n : array) {
        std::cout << n << std::endl;
    }
}
</pre>

関数の引数として配列を取るときは、変数宣言時と同じ書き方で書いてあげます。<br/>
見辛いのでテンプレート使いたくなりますが、その場合はポインタに推論されるため、配列への参照にはなりません（ほぼ同じ意味にはなりますが）。<br/>
<br/>

### 配列への参照を返す関数

一体いつこれを使うことになるのかは定かではありませんが、もちろん書くことが出来ます。<br/>
しかし、奇妙さが倍増しになります・・・<br/>

<pre>
//int型5要素の配列への参照を返すretarray関数
int (&retarray())[5] {
    static int array[]{ 1,2,3,4,5 };
    return array;
}

//cv、参照修飾、noexcept指定などは引数宣言の閉じかっこ後
int (&retarray2(int n) noexcept)[5] {
    static int array[]{ n,n+1,n+2,n+3,n+4 };
    return array;
}

//auto&を使って簡便に
auto& retarray3() {
    static int array[]{ 1,2,3,4,5 };
    return array;
}
</pre>

この様に、配列の参照を返す関数を書くときはT(&name(args...) const noexcept...)[N] {...}のように書き、Tに型名、nameに関数名、args...に引数列、Nに要素数、となり、変数宣言の時と同じように、TとNは参照先のものと一致していなければなりません。<br/>
CV、参照修飾や例外指定は普通の関数と同じ位置、つまりは引数宣言の閉じかっこの後に置きます。<br/>
こちらもauto&を使えるのでこちらで書くと少し見やすくなります（が、型が分かり辛くなります）。<br/>
<br/>
しかし、戻り値型の後置き構文を使う事でかなり見やすく書くことが出来ます。<br/>

<pre>
auto retarray() -> int(&)[5] {
    static int array[]{ 1,2,3,4,5 };
    return array;
}
</pre>

後置きの書式は変数宣言時と同じ書き方です（名前はいりません）。<br/>
これが一番見やすいのでこの書き方で書くといいでしょう。<br/>
関係ない注意点ですが、関数ローカルの配列への参照を返してしまわないように気を付けてください。<br/>
<br/>

### 配列の参照のメリット

一見すると構文の奇妙さが目立ち、使いどころも分からない配列への参照ですが、その要素数をコンパイル時に確定できるというメリットがあります。<br/>
どういう事でしょうか？<br/>

<pre>
void func(int array[5]);
//decltype(func) = void (int *)

int array[2]{};
func(array);
</pre>

関数の引数に配列を取るときはこのように書き、呼び出し側では配列の名前を渡します。<br/>
引数宣言では要素数を書かなくてもいいのにあえて書くことで配列の要素数に制限を加えている気分になります。<br/>
なりますが、実際はこれは単なるポインタ渡しになっており、配列でなくてもint*となる物なら何でも渡すことが出来てしまいます。<br/>
<br/>
しかし、配列の参照を受け取るようにすると<br/>

<pre>
void func(int(&array)[5]);
//decltype(func) = void (int (&)[5])

int array[2]{};
func(array);   //コンパイルエラー
</pre>

引数の型名に要素数がしっかりと入り、その要素数以外の配列を渡そうとするとコンパイルエラーとなります。<br/>
もちろん、int*を渡すこともできません。<br/>
しかも、関数の中でその要素数を超えてアクセスしている場合に警告を出してくれます（clangの場合）。<br/>
ある意味Conceptの様な制約を加えることが出来ているわけです。<br/>
しかも、参照は実質ポインタなので実行時にはポインタ渡しと同じコードになっているはずです。<br/>
<br/>
また、これを利用して静的配列の要素数を得るテクニックがあります。<br/>

<pre>
template<typename T, size_t N>
constexpr auto size(const T(&)[N]) noexcept -> size_t {
   return N;
}

int array[5] = {5, 4, 3, 2, 1};
auto N = size(array); // N = 5
</pre>

C言語由来のマクロで書く方法もありますが、C++ならばこちらを使うべきでしょう。<br/>
ちなみにC++17でこれはstd::size関数として標準ライブラリ入りしています（iteratorヘッダ）。<br/>
<br/>

### 多次元配列の場合
配列は別に1次元だけでなく、多次元配列を宣言できます。<br/>
そして多次元配列の参照も当然あります。<br/>
さらに複雑な構文を要求されることはなく、普通に次元を書き足してやるだけです。<br/>

<pre>
//int型3行4列の配列への参照を返す、retarray関数
int(&retarray() noexcept)[3][4] {
    static int array[3][4] = {{4, 3, 2, 1}, {8, 7, 6, 5}, {12, 11, 10, 9}};
    return array;
}

//int型3行4列の配列への参照を宣言
int(&array2)[3][4] = retarray();

//二次元配列の要素数を取得するsize関数
template<typename T, size_t N, size_t M>
constexpr auto size(const T(&)[N][M]) noexcept -> std::tuple<size_t, size_t> {
    return {N, M};
}
</pre>
<br/>
<br/>

**参考文献** <br/>
[「要素数 4 の配列を渡してください」ではなく「要素数 4 の配列を渡さなければならない」にする - Qiita](https://qiita.com/go_astrayer/items/b0fd2e5cd89412eb65bf "「要素数 4 の配列を渡してください」ではなく「要素数 4 の配列を渡さなければならない」にする - Qiita")<br/>
[size - cpprefjp C++日本語リファレンス](https://cpprefjp.github.io/reference/iterator/size.html "size - cpprefjp C++日本語リファレンス")<br/>
