## [C++11のcoutとスレッド安全性](https://yohhoy.hatenadiary.jp/entry/20120127/p1)

C++標準ライブラリのI/Oストリームが提供するstd::coutに対して、複数スレッドから同時に出力したときの振る舞いについてメモ。（C++03以前については、処理系依存が自明のため対象としない。）<br>

C++11標準規格によれば、下記が保証される。<br>

既定の状態 またはstd::sync_with_stdio(true);を呼び出したのち、<br>
coutに対する出力操作*1を、複数スレッドから並行に行ってもデータ競合(data race)を引き起こさない。<br>

```
#include <iostream>
#include <future>

void dump(const char* s, int v)
{
  std::cout << s << "=" << v << std::endl;
    // 複数スレッドで並行実行されても安全(※)
}

int main()
{
  auto handle = std::async(std::launch::async, dump, "xyz", 42);
    // 別スレッド上でdump("xyz", 42);を呼び出す
  dump("abc", 0);
  handle.wait();  // async()で作成された別スレッドの完了待ち
  return 0;
}
```
※ ただし「並行アクセスをしてもcoutオブジェクトが壊れない」「指定したデータが標準出力に出力される」ことが保証されるだけであり、標準出力へ実際に出力される順序は不定。上記コードの出力結果の一例としてはxyz=abc=0\n42\nなどが起こりえる。*2<br>

<br>
<br>

結局のところ、プログラマが意図した書式で出力させるにはmutexなどの同期機構が別途必要。<br>

```
#include <mutex>
std::mutex cout_guard;

void dump(const char* s, int v)
{
  std::lock_guard<std::mutex> lk(cout_guard);  // 1行出力する処理を保護
  std::cout << s << "=" << v << std::endl;
}
```
// 標準出力には xyz=42\nabc=0\n または abc=0\nxyz=42\n のいずれかが出力される。<br>
