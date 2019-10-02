[C++の並列処理入門](http://yuta1402.hatenablog.jp/entry/2017/12/15/233615)<br/>

スレッドの結果(戻り値)を取得したい場合は、std::async(std::future)を使うことで単純にかける。<br/>

#### std::thread
<pre>
#include &lt;iostream&gt;
#include &lt;thread&gt; // &lt;thread&gt;をインクルード
#include &lt;vector&gt;

int main()
{
    std::vector&lt;int&gt; v{ 0, 1, 2, 3, 4 };

    std::vector&lt;std::thread&gt; threads;

    // 各要素をスレッド別に処理
    for(std::size_t i = 0; i &lt; 5; ++i) {
        threads.emplace_back([i, &v](){
            v[i] *= 2;
        });
    }

    // 全スレッドの同期待ち
    for(auto& t : threads) {
        t.join();
    }

    for(const auto& vi : v) {
        std::cout &lt;&lt; vi &lt;&lt; std::endl;
    }

    return 0;
}
</pre>

#### std::async
std::threadの場合は、処理結果をそのままvector<int>の各要素に代入していましたが、 実際にプログラムを書いてみるとラムダ式で&vをキャプチャしなければならないので面倒です。<br/>
そこで、並列処理の結果を戻り値として取得したい場合に、std::asyncを使います。<br/>

<pre>
#include &lt;iostream&gt;
#include &lt;future&gt; // &lt;future&gt;をインクルード
#include &lt;vector&gt;

int main()
{
    std::vector&lt;std::future&lt;int&gt;&gt; futures;

    // 各要素をスレッド別に処理
    for(std::size_t i = 0; i &lt; 5; ++i) {
        futures.emplace_back(std::launch::async, [i](){
            return i * 2;
        });
    }

    // 全スレッドの同期待ちと結果取得
    for(auto& f : futures) {
        std::cout &lt;&lt; f.get() &lt;&lt; std::endl;
    }

    return 0;
}
</pre>
