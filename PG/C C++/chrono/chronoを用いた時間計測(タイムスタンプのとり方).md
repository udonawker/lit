引用<br/>
[(c++11)chronoを用いた時間計測(タイムスタンプのとり方)](https://qiita.com/hurou927/items/a2d63837e731713c7a22)

## Chrono

chronoを用いた処理時間の計測の一般的な使い方は以下である. <br/>

<pre>
#include &lt;iostream&gt;
#include &lt;chrono&gt;

int main(){
 std::chrono::system_clock::time_point  start, end; // 型は auto で可
 start = std::chrono::system_clock::now(); // 計測開始時間
// 処理
 end = std::chrono::system_clock::now();  // 計測終了時間
 double elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(end-start).count(); //処理に要した時間をミリ秒に変換

}
</pre>

型はautoでいいとしても, 関数を覚えたりTemplateを理解していないと使いにくい. <br/>
そこで, 以下のようなコードを書きたい. <br/>

<pre>
int main(){
 double start,end;
 start = get_time_sec();
 // 処理
 end = get_time_sec();
 double elapsed=end-start;
}
</pre>

そのためのget_time_sec()関数は以下のように設計した. <br/>

<pre>
#include <chrono>
using namespace std::chrono;
inline double get_time_sec(void){
    return static_cast<double>(duration_cast<nanoseconds>(steady_clock::now().time_since_epoch()).count())/1000000000;
}
</pre>

無理やりstatic_castでキャストしたけどもっといい実装あるかな... <br/>
