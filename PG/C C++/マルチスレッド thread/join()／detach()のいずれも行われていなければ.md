[threadの利用と例外安全（その1）](https://yohhoy.hatenadiary.jp/entry/20120209/p1)<br/>
std::thread<br/>
threadオブジェクトに対してjoin()／detach()のいずれも行われていなければ、デストラクタはstd::terminate()を呼び出してプログラムを終了する。<br/>
（明示的にjoin／detach済みオブジェクトの場合は、デストラクタは何もしない。）<br/>
<br/>
[本の虫](https://cpplover.blogspot.com/2010/03/thread.html)<br/>
#### threadは明示的に使うべし<br/>
FCDで、thread周りの文面が、さらに明確に定義されるようになった。<br/>
たとえば、threadのデストラクタだ。もし、joinable()がtrueを返すthreadオブジェクトのデストラクタが実行された場合、terminate()が呼び出される。それ以外の場合、なにもしない（スレッドは、自分で実行を終えるまで、動き続ける。）<br/>
なぜか。もし、暗黙的に、join()やdetach()が呼び出される設計であれば、バグの温床になりえるからだ。<br/>
move代入演算子は、move元のオブジェクトが、joinableであった場合、terminate()を呼び出す。これはどうだろう。まあ、たしかに、join()している最中にmoveされたら、たまったものではない。join()出来る可能性があるオブジェクトをmoveするというのは、バグとみなしてもいいのかもしれない。<br/>
