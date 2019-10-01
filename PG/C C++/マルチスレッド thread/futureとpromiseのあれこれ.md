引用<br/>
[futureとpromiseのあれこれ（理論編）](https://yohhoy.hatenadiary.jp/entry/20120131/p1) <br/>

### future/promiseの基本

両者ともに標準ヘッダ <future> にて定義されるクラステンプレートであり、「別スレッドでの処理完了を待ち、その処理結果を取得する」といった非同期処理を実現するための部品&#42;1。

- 処理結果として、通常の戻り値(value)または例外(exception)を扱う&#42;2。戻り値の型はテンプレート引数にて指定するが、例外は任意の型を扱うことができる。（例: `int`型を扱うなら`std::future<int>`, `std::promise<int>`を用いる。例外は`std::exception_ptr`を利用するため任意の型を伝搬可能。）
- `future` は計算処理の完了待ち（同期機構）と結果取り出し（通信チャネル）機能を提供する。
- `promise` は計算処理の結果設定（通信チャネル）と完了通知（同期機構）機能を提供する。
- `future`オブジェクトは、`promise`オブジェクトの`get_future`メンバ関数呼び出しにて作成する
- `future`, `promise`オブジェクトともにコピー不可／ムーブ可能。

`promise`オブジェクトとそこから取り出した`future`オブジェクトは内部的に同一のshared stateを参照しており、このshared stateを介して処理結果の受け渡しやスレッド間同期を実現する&#42;3。<br/>

<pre>
#include &lt;thread&gt;
#include &lt;future&gt;

void func(std::promise<double> p, double x)
{
  try {
    double ret = /* 何らかの計算 */;
    p.set_value(ret);  // (2a) promiseに戻り値を設定
  } catch (...) {
    p.set_exception(std::current_exception());  // (2b) promiseに例外を設定
  }
}

int main()
{
  std::promise<double> p;
  std::future<double> f = p.get_future();

  double x = 3.14159;
  std::thread th(func, std::move(p), x);  // (1) 別スレッドで関数funcを実行

  /* 自スレッドでの処理 */;

  try {
    double result = f.get();  // (3a) promiseに設定された値を取得（別スレッドでの処理完了を待機）
  } catch (...) {
    // (3b) promiseに設定された例外が再throwされる
  }

  th.join();  // (4) 別スレッドの完了待ち
  // future/promiseによって既に必要な同期はとられているが、thread::join()を呼ばずに
  // thオブジェクトのデストラクタが呼ばれると、std::terminate()が呼び出されてしまう。
  return 0;
}
</pre>

### future/promiseクラステンプレートの特殊化

`future`/`promise` クラステンプレートでは、2つのテンプレート特殊化（lvalue reference型による部分特殊化, void型による特殊化）が提供される。<br/>
`promise::set_value()`と`future::get()`の引数／戻り値が異なる。<br/>

<pre>
// R（プライマリテンプレート）
void promise::set_value(const R& r);
void promise::set_value(R&& r);
R future::get();
// R&
void promise<R&>::set_value(R& r);
R& future<R&>::get();
// void
void promise<void>::set_value();
void future<void>::get();
</pre>

### 例外future_errorとエラーコード

`future`/`promise` に対する操作でエラーが生じた場合、例外`std::future_error`が送出される。<br/>
この `future_error` オブジェクトにはエラーコード(`std::future_errc`列挙型)が格納されており、例外の発生原因を確認できる。<br/>
標準ヘッダ <future> では、future関連のエラーコードとして下記4つを定義している。<br/>

- `broken_promise`
- `future_already_retrieved`
- `promise_already_satisfied`
- `no_state`

<pre>
try {
  //...
} catch (const std::future_error& e) {
  if (e.code() == std::future_errc::no_state) {
    //...
  }
}
</pre>

### その他いろいろ

`std::future`クラステンプレート<br/>

- `promise::get_future()`で2回以上`future`を取り出そうとすると、例外`future_error`／エラーコード`future_already_retrieved`が送出される。1つの計算結果を複数スレッドが待機＆取得するケースのために、C++標準ライブラリでは `std::shared_future`クラステンプレートを提供する。
- 待機処理を行う`wait`メンバ関数、タイムアウト付き待機処理を行う`wait_for`, `wait_until`メンバ関数を提供する。これらのメンバ関数は`get`と異なり処理結果の取り出しを行わない。
- `future`のメンバ関数同士は同期化されない。つまり同一`future`オブジェクトに対して、異なるスレッドからそれぞれ操作するとデータレースを引き起こす。
- shared stateを参照していない`future`オブジェクトの`vaild`メンバ関数は`false`を返す。このとき、同オブジェクトに対する操作&#42;4は未定義(undefined)となっている。&#42;5

`std::promise`クラステンプレート<br/>

- `promise`への結果設定は`set_value`/`set_exception`メンバ関数で行う。結果を設定するとshared stateはready状態となり、ふたたび結果設定を行おうとすると例外`future_error`／エラーコード`promise_already_satisfied`が送出される。
- `promise`への結果設定は行うが取り出し可能とするタイミングをスレッド終了後まで遅延させる場合、`set_value_at_thread_exit`/`set_exception_at_thread_exit`メンバ関数が用意されている。同スレッド上のスレッドローカル変数（記憶クラス指定子にthread_localをつけた変数）が破棄された後に、shared stateがready状態に遷移する。&#42;6
- 結果を未設定のまま`promise`オブジェクトが破棄されると、shared stateには例外`future_error`／エラーコード`broken_promise`が設定されてready状態となる&#42;7。

&#42;1 : future/promiseの組はブロッキング動作をするためマルチスレッドプログラム上での利用が前提となるが、future＋async(deferred function)の組合わせはシングルスレッドプログラム上でも安全に利用できる。<br/>
&#42;2 : 処理結果として扱えるのは、値または例外のいずれか一方。普通の関数が値を返す(return)か例外を投げる(throw)かの一方の動作しかできないのと同じ。<br/>
&#42;3 : "shared state"はC++標準規格上の用語であり、future/promiseの振る舞いを定義するための概念的なもの。ユーザコードからshared stateを直接操作することは出来ない。<br/>
&#42;4 : デストラクタ、ムーブ代入演算、validメンバ関数以外のメンバ関数呼び出し<br/>
&#42;5 : 30.6.6/p3のNoteには「この状況で処理系は例外future_error／エラーコードno_stateを送出する」との記載があるが、C++標準規格は例外送出を要求していない(undefined)ため、処理系によっては異なる動作をする可能性もある。<br/>
&#42;6 : N2880, N3070によると、set_XXX_at_thread_exit メンバ関数は detached スレッド上のスレッドローカルオブジェクト破棄処理とのデータレースを防ぐために追加された。30.3.1.5/p10によれば「detach()済みスレッドが所有するリソースは、スレッド実行終了後に破棄しなければならない」と記載があるが、破棄タイミングについては定義しない。<br/>
&#42;7 : promiseオブジェクト破棄時に set_exception(std::make_exception_ptr( std::future_error(std::future_errc::broken_promise) )); 相当が行われる。<br/>
