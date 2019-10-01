std::this_thread<br/>
std::future<br/>
std::promise<br/>
std::packaged_task<br/>
std::launch<br/>
std::async<br/>
std::future_category<br/>

thread_local [スレッドローカルストレージ](https://cpprefjp.github.io/lang/cpp11/thread_local_storage.html)<br/><br/>

std::this_thread::sleep_for(std::chrono::seconds(5));<br/>
std::async( std::launch::async, foo );<br/>

- c++11からはスレッドが言語に取り込まれている．
- コンパイルには-pthreadを付ける．
- スレッドを一時的に止めるときにはsleepではなく，スレッド用のstd::this_thread::thread_for()を使う．
- thread::join()をちゃんと実行して対象のスレッドの終了を待つようにする．（またはdetachする．detachはスレッドを管理対象から外す．但し実行は裏で勝手に続く．これどんな時に使うんだろう？）
- 無限ループに入れるような場合は，外から止められるように定期的に停止フラグを見に行かせる．
- std::threadのコンストラクタに関数を渡すことでその関数を別スレッドとして実行する．関数の引数はコンストラクタの第2引数以降で渡す．
- クラス内でメンバ関数をスレッド化するときは特殊なので注意．リファレンスで渡すこと，第2引数にthisが要ることを忘れちゃダメ

