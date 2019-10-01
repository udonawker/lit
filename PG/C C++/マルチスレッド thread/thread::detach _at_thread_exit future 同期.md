[_at_thread_exit系の関数が存在している理由](https://cpprefjp.github.io/article/lib/at_thread_exit.html)<br/>

`<future>` や `<condition_variable>` には、`*_at_thread_exit` という名前の関数が定義されている。<br/>

<pre>
namespace std {
  void notify_all_at_thread_exit(condition_variable& cond, unique_lock&lt;mutex&gt; lk);

  template &lt;class R&gt;
  class promise {
  public:
    ...
    void set_value_at_thread_exit(const R& r);
    void set_exception_at_thread_exit(exception_ptr p);
  };

  template &lt;class R, class... ArgTypes&gt;
  class packaged_task&lt;R(ArgTypes...)&gt; {
  public:
    ...
    void make_ready_at_thread_exit(ArgTypes... args);
  };
}
</pre>

これらの関数は、スレッドローカル記憶域が破棄された後に通知を行なったり、状態を変更する。<br/>
また、`thread::detach()` されたスレッド上で、 スレッドローカル記憶域との同期を取る唯一の方法でもある。<br/>
デタッチされたスレッドにおいて、スレッドローカル記憶域にあるオブジェクトがいつ破棄されるかという規定は無い。 そのため、未定義動作を含まずにこれらのオブジェクトを破棄するのは難しい。<br/>
例えば、以下のようなケースで問題になる。<br/>

<pre>
#include &lt;type_traits&gt;
#include &lt;future&gt;
#include &lt;thread&gt;
#include &lt;iostream&gt;

template&lt;class F&gt;
std::future&lt;typename std::result_of&lt;F()&gt;::type&gt; spawn_task(F f) {
  using result_type = typename std::result_of&lt;F()&gt;::type;
  std::packaged_task&lt;result_type ()&gt; task(std::move(f));
  std::future&lt;result_type&gt; future(task.get_future());
  std::thread th(std::move(task));
  th.detach();
  return future;
}


struct Hoge {
  ~Hoge() { std::cout &lt;&lt; "Hoge destructor" &lt;&lt; std::endl; }
};

int f() {
  thread_local Hoge h;
  return 42;
}

int main() {
  std::future&lt;int&gt; res(spawn_task(f));
  std::cout &lt;&lt; res.get() &lt;&lt; std::endl;
}
</pre>

出力:<br/>

<pre>
42Hoge destructor

</pre>

`spawn_task` は、渡された任意の処理を別スレッドで行なう一般的な関数である。関数内部でスレッドを作り、デタッチを行なっている。<br/>
出力は、`main()` 関数での出力と、`Hoge` デストラクタでの出力が混在している。これはスレッドローカル記憶域と `future` オブジェクトが正しく同期されていないからである。そのため、これ以外の出力も起こり得る。<br/>
これは `*_at_thread_exit` 系の関数を利用することで修正できる。<br/>

<pre>
#include &lt;type_traits&gt;
#include &lt;future&gt;
#include &lt;thread&gt;
#include &lt;iostream&gt;

struct task_executor
{
  template &lt;class R&gt;
  void operator()( std::packaged_task&lt;R&gt; task )
  {
    task.make_ready_at_thread_exit(); // operator() を呼び出す代わりに make_ready_at_thread_exit() を呼び出す。
  }
};

template&lt;class F&gt;
std::future&lt;typename std::result_of&lt;F()&gt;::type&gt; spawn_task(F f) {
  using result_type = typename std::result_of&lt;F()&gt;::type;
  std::packaged_task&lt;result_type ()&gt; task(std::move(f));
  std::future&lt;result_type&gt; future(task.get_future());
  std::thread th(task_executor{}, std::move(task));
  th.detach();
  return future;
}


struct Hoge {
  ~Hoge() { std::cout &lt;&lt; "Hoge destructor" &lt;&lt; std::endl; }
};

int f() {
  thread_local Hoge h;
  return 42;
}

int main() {
  std::future&lt;int&gt; res(spawn_task(f));
  std::cout &lt;&lt; res.get() &lt;&lt; std::endl;
}
</pre>

出力:<br/>

<pre>
Hoge destructor
42
</pre>
このプログラムの出力は、必ずこの通りになる。つまり、確実にスレッドローカル記憶域のオブジェクトが破棄された後に `res.get()` の結果が出力される。<br/>
