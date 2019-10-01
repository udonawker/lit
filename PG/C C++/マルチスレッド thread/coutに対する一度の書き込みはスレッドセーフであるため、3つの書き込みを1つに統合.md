[スレッドローカルストレージ](https://cpprefjp.github.io/lang/cpp11/thread_local_storage.html)<br/>

<pre>
#include &lt;iostream>
#include &lt;thread>
#include &lt;random>

// 範囲[min_inclusive, max_inclusive]でランダム一様分布する整数を生成する。
// スレッドごとに乱数の状態を持つ。
int random_range(int min_inclusive, int max_inclusive)
{
  std::random_device seed_gen;
  thread_local std::mt19937 engine(seed_gen());
  std::uniform_int_distribution&lt;int&gt; dist(min_inclusive, max_inclusive);
  return dist(engine);
}

int main()
{
  // 複数のスレッドから並行にrandom_range()関数を呼び出せる
  std::thread t1([]{
    int random_value = random_range(0, 100);

    // ※coutに対する一度の書き込みはスレッドセーフであるため、3つの書き込みを1つに統合。
    std::cout << "thread1 : " + std::to_string(random_value) + "\n";
  });

  std::thread t2([]{
    int random_value = random_range(0, 100);
    std::cout << "thread2 : " + std::to_string(random_value) + "\n";
  });

  t1.join();
  t2.join();
}
</pre>
