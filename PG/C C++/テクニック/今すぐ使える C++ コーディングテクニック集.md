引用<br/>
[今すぐ使える C++ コーディングテクニック集](https://torus711.hatenablog.com/entry/20131205/p1)<br/>

## 小手先の技

- double へのキャスト
- return 文を条件演算子で
- 変数名を工夫する
- ブロック化
- 実数の比較
- テンプレート型を明示的に指定
<pre>
std::max&lt;int&gt;( a, v.size() )
</pre>
- 論理演算の結果をそのまま使う
- 二重否定
<pre>
res += !!( a % m )
</pre>
- 切り上げ整数除算
<pre>
( a + m - 1 ) / m
</pre>
- 四捨五入
<pre>
(int)( a + 0.5 )
</pre>
- 条件演算子を左辺に
<pre>
vector&lt;int&gt; v1, v2;
( i &lt; x ? v1 : v2 ).push_back( i );
</pre>
- 複合代入式も左辺値
<pre>
( res += dp[i] ) %= MOD;
</pre>
- 入力の終わりまで処理
<pre>
while ( std::cin >> hoge )
{
	// do anything
}
</pre>
- 空白を含めた一行を読み込む
<pre>
std::string s;
std::getline( std::cin, s );
</pre>
- 余計な文字を読み飛ばす
<pre>
cin.ignore();
</pre>
- 複数の値を空白区切りで一行に出力

## STL を使う
- 文字列の連結
    - std::accumulate を使って文字列を連結することができます
<pre>
vector<string> ss; // 入力で受け取った string の配列
string s = accumulate( ss.begin(), ss.end(), string() );
</pre>
- std::accumulate の型
<pre>
accumulate( v.begin(), v.end(), 0LL )
</pre>
- ユニーク要素数を手軽に数える
<pre>
set<int>( v.begin(), v.end() ).size()
</pre>

## C++11 の機能を使う
- auto 型
- range-based-for
- ラムダ式

## GCC 拡張
- __gcd 最大公約数 ( Greatest Common Divisor ) を求める関数
- __builtin_popcount 引数で渡した値のビット表現に於いて、立っている bit がいくつあるかを数えてくれます。64 bit の値の場合は __builtin_popcountll
- __builtin_clz 引数で渡した値のビット表現に於いて、立っている bit の内最も上位のものの左にいくつの 0 があるかを数えてくれます
- __builtin_ctz こちらは末尾側の 0 、すなわち Trailing Zero を数えます
