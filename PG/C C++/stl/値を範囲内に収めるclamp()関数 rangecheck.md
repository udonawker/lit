値を、min <= v <= maxのように範囲内に収める関数として、clamp()が定義されます。<br>
std::min(std::max(min_value, x), max_value)のようにするのと同等の効果があります。<br>
引数の順番は、対象の値、最小値、最大値です。戻り値として範囲内に丸められた値が返ります。<br>

<pre>
// <algorithm>
namespace std {
  template <class T>
  constexpr const T& clamp(const T& v, const T& lo, const T& hi);

  template <class T, class Compare>
  constexpr const T& clamp(const T& v, const T& lo, const T& hi, Compare comp);
}
<pre>
例：<br>
<pre>
#include &lt;iostream&gt;
#include &lt;algorithm&gt;

int main()
{
    int v = 3;

    // vの値を[0, 2]の範囲内に収める
    int result = std::clamp(v, 0, 2);
    std::cout << result << std::endl;
}
</pre>
出力：<br>
<pre>
2
<pre>
