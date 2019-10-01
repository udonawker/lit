引用<br/>
### [C++11の時間ライブラリ: chrono](https://cpplover.blogspot.com/2015/01/c11-chrono.html) <br/>

<chrono>は、C++11で追加された時間ライブラリである。<br/>
<br/>
単位時間を扱うためのduration、起点からの経過時間を扱うためのtime_point、現在の起点からの経過時間を取得するためのclockからなる。<br/>
Cの標準ライブラリのtime_tとtime(), clock_gettime()を置き換えることが出来る。<br/>
日付機能は含まれていない。<br/>
<br/>

#### duration

時間について考える。一時間は60分である。1分は60秒である。1秒は1000ミリ秒である。<br/>
単位の異なる時間の値を相互に変換するのは、簡単な計算だ。<br/>

<pre>
unsigned int min_to_sec( unsigned int min )
{
    return min * 60 ;
}
</pre>

しかし、実引数minに渡される値の単位が分であることを保証する方法はない。<br/>
間違えたとしても、コンパイルエラーにはならない。<br/>
chronoでは、時間単位を扱うライブラリ、durationを追加した。<br/>
これは型安全に時間の計算をしてくれる。<br/>

<pre>
#include 

int main()
{
    // 15分
    std::chrono::minutes min(15) ;

    // 分を秒に変換
    std::chrono::seconds sec = min ;

    // 900
    std::cout << sec.count() << std::endl ;

    // エラー、余りが発生する可能性があるため
    min = sec ;

    // OK
    min = std::chrono::duration_cast<std::chrono::minutes>( sec ) ;
}
</pre>

durationテンプレートには、よく使う時間単位、hours, minutes, seconds, miliseconds, microseconds, nanosecondsというtypedef名があらかじめ宣言されている。<br/>
また、C++14からは、時間単位のtypedef名へのユーザー定義リテラルが定義されている。<br/>
それぞれ、h, min, s, ms, us, nsとなっている。<br/>

<pre>
int main()
{
    std::chrono::seconds s(10) ;

    s.count() ; // 10

    auto s2 = s + s ;

    s2.count() ; // 20

    std::chrono::hours h(1) ;
    h.count() ; // 1

    s = h ;

    s.count() ; // 3600
}
</pre>

#### time_point

time_pointは、ある起点時間からの経過時間を表現するクラスだ。<br/>
time_point同士を減算すると、その結果はdurationになる。<br/>
time_pointを直接構築することはあまりない。<br/>
time_pointは、clockから得ることができる。<br/>
C標準ライブラリのtime_tに比べて、型安全になっている。<br/>

#### clock

clockは、現在のtime_pointを取得するクラスだ。<br/>
staticメンバー関数のnowでtime_pointを取得できる。<br/>

<pre>
int main()
{
    // 処理前の起点からの経過時間
    auto t1 = std::chrono::system_clock::now() ;

    // 処理
    std::this_thread::sleep_for( std::chrono::seconds(1) ) ;

    // 処理後の起点からの経過時間
    auto t2 = std::chrono::system_clock::now() ;

    // 処理の経過時間
    auto elapsed = t2 - t1 ;

    // 単位は未規定
    std::cout << elapsed.count() << std::endl ;
}
</pre>

system_clockは、システム上のリアルタイムクロックを表現するclockである。<br/>
このクロックの使うdurationは未規定である。<br/>
そのため、経過時間を実際の時間単位で知りたければ、duration_castが必要になる。<br/>

<pre>
int main()
{
    // 処理前の起点からの経過時間
    auto t1 = std::chrono::system_clock::now() ;

    // 処理
    std::this_thread::sleep_for( std::chrono::seconds(1) ) ;

    // 処理後の起点からの経過時間
    auto t2 = std::chrono::system_clock::now() ;

    // 処理の経過時間をミリ秒で取得
    auto elapsed = std::chrono::duration_cast< std::chrono::milliseconds >(t2 - t1) ;

    // 単位はミリ秒
    std::cout << elapsed.count() << std::endl ;
}
</pre>

C++規格は、起点時間がいつなのかを規定していない。<br/>
経過時間はtime_pointのメンバー関数tiem_since_epochで取得できる。<br/>
また、system_clockから得られるtiem_pointは、time_tに変換できる。<br/>

<pre>
int main()
{
    // time_point
    auto t1 = std::chrono::system_clock::now() ;
    // 起点時間からの経過時間
    std::cout << t1.time_since_epoch().count() << '\n' ;

    // time_t
    auto t2 = std::chrono::system_clock::to_time_t( t1 ) ;
    std::cout << t2 << '\n' ;

    // tme_point
    auto t3 = std::chrono::system_clock::from_time_t( t2 ) ;

    std::cout << t3.time_since_epoch().count() << std::endl ;
}
</pre>

system_clockのtime_pointとtime_tが、同じ時間単位の分解能を使っているとは限らない。<br/>
clockはsystem_clockだけではない。<br/>
他にも、steady_clockがある。<br/>
これは、実時間の経過によって、time_pointの経過時間が減らないことが保証されている。<br/>

<pre>
int main()
{
    // time_point
    auto t1 = std::chrono::steady_clock::now() ;

    // この間にシステムの時刻が過去に変更されるかもしれない


    auto t2 = std::chrono::steady_clock::now() ;


    // trueであることが保証されている
    bool b = t2 >= t1 ;
}
</pre>

その他のclockにも、constexpr staticデータメンバーのis_steadyの値によって、steady_clockと同じ保証があるかどうかを確かめることができる。<br/>

<pre>
// true/false
bool b = std::chrono::system_clock::is_steady ;
</pre>

C++規格はもうひとつ、high_resolution_clockを規定している。<br/>
これは、時間の分解能が高いclockであると規定されている。<br/>

<pre>
auto t1 = std::chrono::high_resolution_clock::now() ;
// 処理
auto t2 = std::chrono::high_resolution_clock::now() ;

// 処理のかかった時間
auto e = t2 - t1 ;
</pre>
