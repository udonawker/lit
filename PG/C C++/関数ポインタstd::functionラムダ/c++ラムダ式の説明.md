## [C++のラムダ式の説明](https://qiita.com/YukiMiyatake/items/8d10bca26246f4f7a9c8)

# C++のラムダ式の説明

## 関数オブジェクト(function object)
ラムダを使うまえに基礎知識として関数オブジェクトのおさらい<br>
ラムダ式は関数オブジェクトの文法糖衣（Syntax sugar）であり、関数オブジェクトを簡略化して表記しているにすぎない<br>
<br>
まずC++のClassには演算子のオーバーロード(operator overload)が出来る<br>
演算子() をオーバーロードすると、見た目は関数のようにオブジェクトを扱える<br>

<pre>
#include&lt;iostream&gt;

// operator() を実装し、あたかも関数のようにふるまうオブジェクト
class Mul{
private:
    int i_;
public:
    Mul(int i): i_(i) {}
    int operator()(int j){return i_*j;}     // operator()
};


int main(){
    auto doubler = Mul(2);

    std::cout << doubler(3) << std::endl;
    std::cout << doubler(4) << std::endl;

    return 1;
}


6
8
</pre>
ラムダ式は基本的には上記の関数オブジェクトを作っているだけだが関数オブジェクトと比較して、非常に簡潔に分かりやすく表記できる<br>

## ラムダとは
- ラムダ式(lambda expression)は無名関数(nameless function)あるいは匿名関数(anonymous function)の表現法の1つ関数型言語でよく使われる
- コールバックを簡単に書くことが可能
- C++98では関数オブジェクトの形で表現が可能
- C++11からは、ラムダ構文が追加された（中身は関数オブジェクトのシンタックスシュガー）
- 基本的にはC++11で実装されているが、C++14、C++17などで、初期化ラムダキャプチャ、ジェネリックラムダ等追加されている

## 基本構文

<pre>
[キャプチャリスト](パラメータリスト) mutable 例外仕様 属性 -> 戻り値の型 { 関数の本体 }
</pre>

不要な部分は省略可能で、最小構文は下記（何もしないラムダ）<br>
<pre>
[]{}
</pre>

## 簡単な例
int型の引数を渡し表示するだけの簡単な例<br>

<pre>
#include&lt;iostream&gt;

int main(){

    [](int n){ std::cout << "lambda " << n << std::endl; }(0);     // 関数なので()で実行可能

    auto hoge = [](int x) {
        std::cout << "hoge " << x << std::endl;
    };

    hoge(1);
    hoge(10);

    return 1;
}


lambda 0
hoge 1
hoge 10
</pre>

## 戻り値の型
指定しなければ自動的に型を推論してくれるが、明示的に返り値の型を指定可能<br>

<pre>
#include&lt;iostream&gt;

int main(){
    std::cout << []() -> int{ return 1.5f; }() << std::endl;　　　// float型でreturnしているが 戻り値を明示的にintに

    return 1;
}

1
</pre>

## キャプチャリスト
他の多くの言語とは違い、C++ではキャプチャ（外部ブロックの変数の束縛）を明示的に指定する必要があります。<br>
キャプチャには、参照キャプチャ、コピーキャプチャ、初期化ラムダキャプチャ等がある。<br>
また、キャプチャはデフォルト（スコープ内の変数全てに適用）と個別変数に対して別々に指定可能。<br>
thisもキャプチャ可能である。<br>
可能な限りデフォルトキャプチャではなく、明示的に変数を指定してキャプチャしたい。<br>

|キャプチャ|内容|
|:--|:--|
|[&]|デフォルト参照キャプチャ（全ての変数を参照キャプチャ）|
|[=]|デフォルトコピーキャプチャ（全ての変数をコピーキャプチャ）|
|[&x]|変数xのみを参照キャプチャする|
|[x]|変数xのみをコピーキャプチャする|
|[&x, y]|xを参照、yをコピーキャプチャ|
|[&, x]|xはコピー、その他は参照キャプチャ|
|[=, &x]|xは参照、その他はコピーキャプチャ|

<pre>
#include&lt;iostream&gt;

int main(){
    int x = 0;
    int y = 10;

    auto cc = [=](){ std::cout << x << ", " << y << std::endl;};　　　　　　// 全てをコピーキャプチャ
    auto cr = [=, &y](){ std::cout << x << ", " << y << std::endl;};　　　 // デフォルトコピー、yを参照キャプチャ
    auto rr = [&](){ std::cout << x << ", " << y << std::endl;};　　　　　　// 全てを参照キャプチャ

    x = 1;
    y = 11;
    cc();
    cr();
    rr();

    [&x](){ x+=1; }();          // 参照キャプチャは変数の変更が可能
    //[y](){ y+=1; }();         // Copyキャプチャは変数を変更不可能（Const)
    [y]() mutable{ y+=1; }();   // mutableにすると変数の変更が可能（だがコピーなので元の変数は不変）
    rr();

    return 1;
}
</pre>

0, 10
0, 11
1, 11
2, 11
</per>

コピーキャプチャ変数は暗黙的にconst修飾されているので、値を変更しようとするとコンパイルエラーになる。<br>
mutableをつけると変更可能になるが、元の変数には反映されない（コピーなので）。<br>

## ラムダ式をCの関数ポインタへ変換

キャプチャ変数がない場合のみ、同じ引数と戻り値の関数ポインタと互換性がある。<br>

<pre>
#include&lt;iostream&gt;

typedef int(*Func)(int);

int main(){

    Func fn = [](int n){ return n; };　　　　　// キャプチャをしていないので関数ポインタに変換可能
    //Func fn2 = [x](int n){ return n+x; };  // キャプチャすると関数ポインタに変換できない
    //Func fn3 = [=](int n){ return n; };    // 使用していなくてもNG

    std::cout << fn(1) << std::endl;

    return 1;
}
</pre>

また、デフォルト引数も上記と同じ制約、キャプチャ変数がない時のみラムダ関数を指定できる。<br>
（ただし、デフォルト引数の場合は、キャプチャしても使用してなければOKである）。<br>

## std::function

std::functionを使えば、キャプチャー可能<br>

<pre>
#include&lt;functional&gt;
#include&lt;iostream&gt;

typedef std::function<int(int)> Func;        // std::functionの事は今回は説明しない

int main(){
    int x = 10;
    Func fn = [x](int n){ return n+x; };
    std::cout << fn(1) << std::endl;

    return 1;
}
</pre>

## 寿命切れ変数の参照キャプチャ

未定義動作(undefined behavior 略称UB)となる（いわゆる、鼻から悪魔）。<br>

<pre>
#include&lt;functional&gt;
#include&lt;iostream&gt;


std::function<int(int)>  func(int v){
    int x = v;
    return[&x](int i){ return(i+x); };    // 実行時には寿命がきれている変数xをキャプチャ。未定義動作
    // return[x](int i){ return(i+x); };    // コピーキャプチャなら正しく動く
}

int main(){
    std::cout << func(10)(1) << std::endl;

    return 1;
}
</pre>

上記の実行結果は、コンパイラによっては一見正しく動く事もあるし、動かない事もある。<br>
（clang10だと 11が表示され、gcc9だと2になった）<br>

上記を正しく動かすには、参照ではなくコピーキャプチャをしなければならない。<br>

## クロージャ(関数閉包)

クロージャはラムダ関数の一種である状態を持つラムダ関数。<br>
ガーベージコレクションが無い等の理由でC++のラムダは、多少違いはあるものの、C++ではクロージャが書ける。<br>
具体的には、状態を持った（変数を持った）関数が、ラムダ関数をreturnする。<br>

<pre>
#include&lt;iostream&gt;

int main(){

    auto sequence = [](int n) {         // クロージャはよくラムダ関数をReturnする2重のラムダ関数で表現される（もちろん通常関数でもOK)
        int x = n;                      // クロージャはローカル変数を保持する必要がある
        return [x]() mutable {          // 参照キャプチャだと寿命が切れているためNG、コピーキャプチャだと変数を変更できない。
            std::cout << "hoge " << x_ << std::endl;
            ++x;
        };
    };

    auto s = sequence(0);
    auto s2 = sequence(100);

    s();
    s();
    s2();
    s2();
    s();

    return 1;
}


hoge 0
hoge 1
hoge 100
hoge 101
hoge 2
</pre>

先ほど説明した通り、この2重のラムダでは、参照キャプチャすると呼び出し時に変数の寿命が切れていて未定義動作。<br>
かといって、コピーキャプチャだと変数をインクリメント出来ない。<br>

そんな時に使うのが、コピーキャプチャしてmutableを指定し書き込み可能にする。<br>
コピーキャプチャなので、変数の書き換えはローカルのみで外へは影響しない。<br>
この例では、sの変数xの値は、s2の変数xに影響を与えない。<br>
よってこれを 関数閉包と呼ぶ。<br>

## 初期化lambdaキャプチャ(init-captur)
ラムダキャプチャには、特定の変数をコピーキャプチャ、参照キャプチャ指定する機能しかなかったがC++14からは、キャプチャに任意の式を書くことができる。<br>
それにより、キャプチャ変数の名前を変更したり、関数を呼んだ結果をキャプチャしたり出来る。<br>
そしてなにより、ムーブキャプチャが可能になったことが大きい。<br>

<pre>
#include&lt;iostream&gt;
#include&lt;memory&gt;

int main(){

    auto sequence = [](int n) {
        auto y = std::make_unique<int>(n);
//        return [x = y]() mutable {               // unique_ptrはコピー出来ないのでコンパイルエラー
        return [x = std::move(y)]() mutable {      // moveは可能。moveするためには初期化キャプチャが必要
            std::cout << "hoge " << *x << std::endl;
            (*x)++;
        };
    };

    auto s = sequence(0);
    auto s2 = sequence(100);

    s();
    s();
    s();
    s2();
    s();

    return 1;
}


hoge 0
hoge 1
hoge 2
hoge 100
hoge 3
</pre>

moveは所有権の移譲をするセマンティクスでありコピーではなく、ポインタを付け替えるだけなので、オーバーヘッドが低い。<br>
また、スマートポインタやthreadなど、コピーが出来ずmoveしか出来ないものをキャプチャできる。<br>

## ジェネリックラムダ
ラムダ関数の引数をジェネリック（Template）にする事が可能だ。<br>
表記方法は template<>を使わず、引数の型を autoにするだけで非常に簡潔である。<br>
(C++20からは、Templateで柔軟に制御する構文も追加される)。<br>

<pre>
#include&lt;functional&gt;
#include&lt;iostream&gt;


int main(){
    auto fn = [](auto a, auto b){    // autoには様々な型が適応される。ここがジェネリックラムダ
        std::cout << a  << " " << b << std::endl;
    };

    fn( "hello", "world" );
    fn( "string", 10 );
    fn( 100, 1.23f );

    return 1;
}


hello world
string 10
100 1.23
</pre>

また、ジェネリックラムダは、ジェネリックのまま束縛することは不可能である。<br>
（パラメータの引数を限定した後なら束縛は可能）。<br>

## ジェネリックラムダ、パラメータパック(参考
パラメータパックとは、Templateにおける可変長パラメータ ... の事である。<br>
ジェネリックラムダは、Template同様に可変長パラメータを扱う事が出来る。<br>

<pre>
#include&lt;iostream&gt;


int main(){
    auto fn = [](auto ... args){    // この...がパラメータパックで、可変長テンプレート引数である
         (std::cout << ... << args ) << std::endl;   // Fold構文を使って展開をしている。普通に展開するには再帰が必要かなあ？
    };

    fn( 1,"hello", "world", 11.4f );
    fn( );
    fn( 1 );

    return 1;
}
</pre>

fold式をつかているが、このようにラムダにパラメータパックを適用可能。<br>

また、C++20にて 初期化Lambdaキャプチャでパラメータパックの展開が出来るようになった。<br>
