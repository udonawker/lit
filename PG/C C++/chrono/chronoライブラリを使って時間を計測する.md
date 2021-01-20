<pre>
#include &lt;iostream&gt;
#include &lt;chrono&gt;

int main() {
    
    auto start = std::chrono::system_clock::now();

    // 重い処理
    long long j = 0;
    for(int i = 1; i <= 100000000; ++i)
    {
        j += i;
    }

    auto end = std::chrono::system_clock::now();

    // 経過時間をミリ秒単位で表示
    auto diff = end - start;
    std::cout << "elapsed time = "
              << std::chrono::duration_cast<std::chrono::milliseconds>(diff).count()
              << " msec."
              << std::endl;

    return 0;
}
</pre>

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
