引用<br/>
[C++で簡単非同期処理&#40;std::thread,std::async&#41;](https://qiita.com/termoshtt/items/d3cb7fe226cdd498d2ef)<br/>

## 戻り値が必要ない場合(Thread-per-message pattern)
## 結果を取得したい場合(std::async)
## Thread Pool (Worker Thread) pattern

C++でスレッドプール(ワーカースレッド)パターンを実装する方法は方々で議論されている。<br/>

* C++11で実装する場合
    * [A Thread Pool with C++11](http://progsch.net/wordpress/?p=81)
    * [progschj/ThreadPool - GitHub](https://github.com/progschj/ThreadPool)
* Boost.Asioを使用する場合
    * [Boost.Asioによるワーカースレッドパターン](http://faithandbrave.hateblo.jp/entry/20110408/1302248501)
