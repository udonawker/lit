## [std::regexでパターンにマッチするすべての文字列を抽出する](https://onihusube.hatenablog.com/entry/2019/07/23/183851)
## [C++ 正規表現で検索文字列の抽出／出現位置の判定【match_results／std::regex】](https://marycore.jp/prog/cpp/std-regex-match-results-match-count/)
## [本の虫 C++の正規表現ライブラリ: std::regex](https://cpplover.blogspot.com/2015/01/c-stdregex.html)

<pre>
#include &lt;iostream&gt;
#include &lt;iterator&gt;
#include &lt;regex&gt;
#include &lt;string&gt;

int main()
{
  std::string s("a01da123456da999d");
  std::regex re("\\d+");

  for (std::sregex_iterator it(std::begin(s), std::end(s), re), end; it != end; ++it) {
      // *it == std::match_results
      auto&& m = *it;
      std::cout << "prefix = " << m.prefix() << ", suffix = " << m.suffix() << ", size =  " << m.size() << std::endl;
      std::cout << "position = " << m.position() << ", length = " << m.length() << ", str = '" << m.str() << '\'' << std::endl;
  }
}

// $ g++ prog.cc -Wall -Wextra -std=c++11
// regex_iterator
/*
prefix = a, suffix = da123456da999d, size =  1
position = 1, length = 2, str = '01'
prefix = da, suffix = da999d, size =  1
position = 5, length = 6, str = '123456'
prefix = da, suffix = d, size =  1
position = 13, length = 3, str = '999'
*/
</pre>
