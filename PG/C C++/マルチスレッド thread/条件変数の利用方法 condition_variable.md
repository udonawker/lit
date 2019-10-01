# [条件変数の利用方法](https://cpprefjp.github.io/article/lib/how_to_use_cv.html)

標準ヘッダ<condition_variable>で提供される、条件変数(condition variable)の利用方法について説明する。<br/>
簡単のため、条件変数condition_variableとロックunique_lock<mutex>の組に対してのみ説明を行う。<br/>
condition_variable_anyクラスは、任意のロック型と組み合わせ可能なことを除き、その利用方法はcondition_variableと同じである。<br/>

## 利用の目的

条件変数オブジェクトのみを単体で利用するのではなく、必ずミューテックス（排他制御）オブジェクトと、同ミューテックスで保護されるデータ状態を表す変数群（以下、"ステート"と呼ぶ）という3つの組で利用すること。<br/>
条件変数オブジェクトとは、複数スレッドがこの共有"ステート"を更新／参照する場合に、"ステート"の更新を他スレッドに通知／"ステート"が指定条件を満たすまで待機する処理を、効率的に記述するための同期機構である。<br/>
<br/>
理論的には条件変数を利用しなくても、ミューテックス保護＋"ステート"参照をループする処理でも条件待機は実現できる。<br/>
ただし、このような実装（ポーリング方式）では参照側スレッドが常に動作し続けるため、一般的には計算機リソース浪費による実行効率の著しい低下をもたらす。<br/>
（対象処理系や特殊ユースケースでは、ポーリング方式の方が望ましい状況も否定しない。）<br/>

## 利用パターン

下記コードでは典型的な利用パターンを示す。<br/>
なお、通知処理と待機処理は異なるスレッド上で並行実行されるものとする。<br/>

<pre>
#include <mutex>
#include <condition_variable>

// "ステート"変数＋ミューテックスmtx＋条件変数cv
int state;  // 注: 変数型やその個数は目的による
std::mutex mtx;
std::condition_variable cv;
</pre>

<pre>
#include <mutex>
#include <condition_variable>

// "ステート"変数＋ミューテックスmtx＋条件変数cv
int state;  // 注: 変数型やその個数は目的による
std::mutex mtx;
std::condition_variable cv;
</pre>

<pre>
// 指定条件を満たすまで待機
{
  std::unique_lock<std::mutex> lk(mtx);
  cv.wait(lk, [&]{
    return /* "ステート"変数を参照し、指定条件を満たす場合はtrueを返す */;
  });
  // "ステート"変数を参照した処理
}
</pre>

通知処理の実装では、通知関数としてnotify_all()を利用している。<br/>
通知関数としてはもう1種類`notify_one()`が提供されるが、`notify_one()`で論理的に十分であると判断できないならば、まずは`notify_all()`利用を推奨する。<br/>
（`notify_all()`が待機中の全スレッドに通知を行うのに対し、`notify_one()`は待機中の任意の1スレッドにのみ通知を行うため、後者は実行時オーバーヘッドの観点で有利である。<br/>
一方、待機処理における指定条件によっては、`notify_one()`利用ではライブロック(live lock)に陥るケースも存在する。<br/>
なお、`nofity_all()`の動作セマンティクスは`notify_one()`を完全に包含するため、`notify_one()`で正しく動作する並行処理は`notify_all()`利用でも正しく動作する。）<br/>
<br/>
待機処理の実装では、第2引数に述語をとる`wait()`を利用することで、条件変数のSpurious Wakeupと呼ばれる現象を考慮しなくとも正しい処理を記述できる。<br/>
`wait()`メンバ関数はロック型のみを引数にとる1引数オーバーロードも提供するが、特殊なケースを除いて上記の2引数オーバーロード利用を推奨する。<br/>
待機関数によるブロッキング期間以外では、そのスレッド自身がロック`lk`保持中であると保証されるため、述語処理（前掲実装ではラムダ式）や`wait()`呼出より後に"ステート"変数へと安全にアクセスできる。<br/>

## 条件変数と状態

条件変数オブジェクトはスレッド間通知／待機機能を提供するだけであり、オブジェクトそれ自身は永続的な状態管理を行わない。<br/>
このため条件変数オブジェクトに対する通知関数`notify_one()`/`notify_all()`は、その通知時点で同オブジェクトの待機関数`wait()`/`wait_for()`/`wait_until()`にてブロックされているスレッド群にしか影響しない。<br/>
<br/>
この条件変数オブジェクトの動作は、概念的には「待機／実行可能スレッドのキュー」と解釈する事ができる。<br/>
待機関数`wait()`系は呼出スレッドをブロック状態へ遷移してから待機キューに追加する動作、通知関数`notify_one()`は待機キューからいずれか1つ／`notify_all()`は待機キュー内の全スレッドを実行可能キューへ移動させる動作に相当する。<br/>
待機関数`wait()`でブロック中のスレッドは、自スレッドを実行可能キュー内でみつけたら、実行状態へ遷移したのち待機関数の呼出元に制御を戻す。<br/>
<br/>
下記コードでは条件変数を誤用した例を示す。<br/>
なお、通知処理と待機処理は異なるスレッド上で並行実行されるものとする。<br/>

<pre>
// 条件変数を誤用した同期処理
std::mutex mtx;
std::condition_variable cv
</pre>
<pre>
// 誤った通知処理
{
  std::lock_guard<std::mutex> lk(mtx);
  // 共有データの更新
  cv.notify_all();
}
</pre>
<pre>
// 誤った待機処理
{
  std::unique_lock<std::mutex> lk(mtx);
  cv.wait(lk);
  // 共有データの参照利用
}
</pre>

上記の誤用例では、プログラマの意図と反するであろう次の実行結果が生じる。<br/>
このプログラムでは非決定的な動作となるため、偶然に期待通り動作したかのように見えるケースもある。<br/>

- 通知関数の呼び出し後に待機関数が呼び出された場合、待機処理スレッドはブロッキングされる。（ライブロック状態）
- 待機関数が先に呼び出された場合、待機処理スレッドはブロッキングされる。その後、通知処理スレッドによる通知関数の呼び出しよりも前に、待機処理スレッドのブロックが解除されて待機関数から制御が戻ってくる可能性がある。（Spurious Wakeupの未考慮）

この不具合を修正するには、過去に通知が行われた事実を永続化する変数（"ステート"変数）を導入すれば良い。<br/>

<pre>
// 条件変数による正しい同期処理
bool notify = false;
std::mutex mtx;
std::condition_variable cv;
</pre>
<pre>
// 修正した通知処理
{
  std::lock_guard<std::mutex> lk(mtx);
  // 共有データの更新
  notify = true;
  cv.notify_all();
}
</pre>
<pre>
// 修正した待機処理
{
  std::unique_lock<std::mutex> lk(mtx);
  cv.wait(lk, [&]{ return notify; });
  // 共有データの参照利用
}
</pre>

## ミューテックスと複数の条件変数
1つのミューテックスで保護される共有"ステート"変数に対して、複数個の条件変数オブジェクトを関連付ける事ができる。<br/>
逆に1つの条件変数オブジェクトに対して、複数個のミューテックス（と共有"ステート"のグループ）を関連付ける事は出来ない。<br/>
<br/>
下記に、一般的なProducer-Consumerパターンで利用される境界付きキュー(bounded queue)の簡易実装例を示す。<br/>
1つのミューテックス`guard_`にて*thisオブジェクト自身を保護し、2つの条件変数オブジェクト`not_empty_`, `not_full_`を関連付ける。<br/>
この`bounded_queue`クラスは、スレッド間同期を実現するモニタ(monitor)として機能する。<br/>

<pre>
#include <utility>
#include <queue>
#include <mutex>
#include <condition_variable>

template<typename T, size_t N>
class bounded_queue {
  std::queue<T> queue_;
  std::mutex guard_;
  std::condition_variable not_empty_;
  std::condition_variable not_full_;
public:
  // 値の挿入
  void push(T val) {
    std::unique_lock<std::mutex> lk(guard_);
    not_full_.wait(lk, [this]{
      return queue_.size() < N;
    });
    queue_.push(std::move(val));
    not_empty_.notify_all();
  }
  // 値の取り出し
  T pop() {
    std::unique_lock<std::mutex> lk(guard_);
    not_empty_.wait(lk, [this]{
      return !queue_.empty();
    });
    T ret = std::move(queue_.front());
    queue_.pop();
    not_full_.notify_all();
    return ret;
  }
};
</pre>
