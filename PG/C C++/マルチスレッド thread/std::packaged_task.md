[std::thread::detach](https://cpprefjp.github.io/reference/thread/thread/detach.html)<br/>
[std::packaged_task](https://cpprefjp.github.io/reference/future/packaged_task.html)<br/>

<pre>
#include &lt;iostream&gt;
#include &lt;thread&gt;
#include &lt;future&gt;

std::future<int> start_async(int x, int y)
{
  std::packaged_task<int()> task([x,y]{
    // 非同期実行されるタスク...
    return x + y;
  });
  auto ftr = task.get_future();

  // 新しいスレッド作成後にdetach操作
  std::thread t(std::move(task));
  t.detach();

  return ftr;
  // 変数tにはスレッドが紐付いていないため破棄可能
}

int main()
{
  auto result = start_async(1, 2);
  //...

  std::cout << result.get() << std::endl;
}
</pre>

<pre>
#include &lt;iostream&gt;
#include &lt;thread&gt;
#include &lt;future&gt;
#include &lt;utility&gt;

int calc()
{
  int sum = 0;
  for (int i = 0; i < 10; ++i) {
    sum += i + 1;
  }
  return sum;
}

int main()
{
  std::packaged_task<int()> task(calc); // 非同期実行する関数を登録する
  std::future<int> f = task.get_future();

  // 別スレッドで計算を行う
  std::thread t(std::move(task));
  t.detach();

  try {
    // 非同期処理の結果値を取得する
    std::cout << f.get() << std::endl;
  }
  catch (...) {
    // 非同期実行している関数内で投げられた例外を補足
  }
}
</pre>
