## [std::regexでパターンにマッチするすべての文字列を抽出する](https://onihusube.hatenablog.com/entry/2019/07/23/183851)
## [C++ 正規表現で検索文字列の抽出／出現位置の判定【match_results／std::regex】](https://marycore.jp/prog/cpp/std-regex-match-results-match-count/)
## [本の虫 C++の正規表現ライブラリ: std::regex](https://cpplover.blogspot.com/2015/01/c-stdregex.html)

std::string_literal<br>
constexpr char str[] = "aaa";<br>

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

<pre>
// This file is a "Hello, world!" in C++ language by GCC for wandbox.
#include &lt;iostream&gt;
#include &lt;iterator&gt;
#include &lt;regex&gt;
#include &lt;string&gt;

void regex_match(const std::string& s)
{
    std::regex re(R"(\[sample "test"=(\d+)/\])");
    const char* suffix = nullptr;
    std::cout << "■■■ : " << s << std::endl;
    for (std::sregex_iterator it(std::begin(s), std::end(s), re), end; it != end; suffix = it->suffix().str().c_str(), ++it) {
        // *it == std::match_results
        auto&& m = *it;
        // std::match_results.prefix()|std::match_results.suffix() == std::sub_match
        std::cout << "prefix = " << m.prefix() << ", suffix = " << m.suffix() << ", size =  " << m.size() << ", position = " << m.position() << std::endl;
        for (decltype(m.size()) pos = 0; pos < m.size(); ++pos) {
          std::cout << "match_results[" << pos << "] length = " << m[pos].length() << ", str = '" << m[pos].str() << '\'' << std::endl;
        }
        std::cout << "--------------------------------" << std::endl;
    }
    if (suffix) {
        std::cout << "last suffix = " << suffix << " length = " << std::char_traits<char>::length(suffix) << std::endl;
    }
    std::cout << std::endl;
}

int main()
{
    std::string strs[] = {
        "[sample \"test\"=10000/]あしたは[sample \"test\"=3000/]晴れです[sample \"test\"=123/]わわわわ～", 
        "あしたは[sample \"test\"=3000/]晴れです[sample \"test\"=123/]わわわわ～", 
        "[sample \"test\"=10000/]あしたは[sample \"test\"=3000/]晴れです[sample \"test\"=123/]わわわわ～[sample \"test\"=99999/]",
        "[sample \"test\"=10000/][sample \"test\"=20000/][sample \"test\"=30000/][sample \"test\"=40000/]",
        "" };

    for (const auto& str : strs) {
        regex_match(str);
    }

    return 0;
}

//$ g++ prog.cc -Wall -Wextra -std=c++11
/*
■■■ : [sample "test"=10000/]あしたは[sample "test"=3000/]晴れです[sample "test"=123/]わわわわ～
prefix = , suffix = あしたは[sample "test"=3000/]晴れです[sample "test"=123/]わわわわ～, size =  2, position = 0
match_results[0] length = 22, str = '[sample "test"=10000/]'
match_results[1] length = 5, str = '10000'
--------------------------------
prefix = あしたは, suffix = 晴れです[sample "test"=123/]わわわわ～, size =  2, position = 34
match_results[0] length = 21, str = '[sample "test"=3000/]'
match_results[1] length = 4, str = '3000'
--------------------------------
prefix = 晴れです, suffix = わわわわ～, size =  2, position = 67
match_results[0] length = 20, str = '[sample "test"=123/]'
match_results[1] length = 3, str = '123'
--------------------------------
last suffix = わわわわ～ length = 15

■■■ : あしたは[sample "test"=3000/]晴れです[sample "test"=123/]わわわわ～
prefix = あしたは, suffix = 晴れです[sample "test"=123/]わわわわ～, size =  2, position = 12
match_results[0] length = 21, str = '[sample "test"=3000/]'
match_results[1] length = 4, str = '3000'
--------------------------------
prefix = 晴れです, suffix = わわわわ～, size =  2, position = 45
match_results[0] length = 20, str = '[sample "test"=123/]'
match_results[1] length = 3, str = '123'
--------------------------------
last suffix = わわわわ～ length = 15

■■■ : [sample "test"=10000/]あしたは[sample "test"=3000/]晴れです[sample "test"=123/]わわわわ～[sample "test"=99999/]
prefix = , suffix = あしたは[sample "test"=3000/]晴れです[sample "test"=123/]わわわわ～[sample "test"=99999/], size =  2, position = 0
match_results[0] length = 22, str = '[sample "test"=10000/]'
match_results[1] length = 5, str = '10000'
--------------------------------
prefix = あしたは, suffix = 晴れです[sample "test"=123/]わわわわ～[sample "test"=99999/], size =  2, position = 34
match_results[0] length = 21, str = '[sample "test"=3000/]'
match_results[1] length = 4, str = '3000'
--------------------------------
prefix = 晴れです, suffix = わわわわ～[sample "test"=99999/], size =  2, position = 67
match_results[0] length = 20, str = '[sample "test"=123/]'
match_results[1] length = 3, str = '123'
--------------------------------
prefix = わわわわ～, suffix = , size =  2, position = 102
match_results[0] length = 22, str = '[sample "test"=99999/]'
match_results[1] length = 5, str = '99999'
--------------------------------
last suffix =  length = 0

■■■ : [sample "test"=10000/][sample "test"=20000/][sample "test"=30000/][sample "test"=40000/]
prefix = , suffix = [sample "test"=20000/][sample "test"=30000/][sample "test"=40000/], size =  2, position = 0
match_results[0] length = 22, str = '[sample "test"=10000/]'
match_results[1] length = 5, str = '10000'
--------------------------------
prefix = , suffix = [sample "test"=30000/][sample "test"=40000/], size =  2, position = 22
match_results[0] length = 22, str = '[sample "test"=20000/]'
match_results[1] length = 5, str = '20000'
--------------------------------
prefix = , suffix = [sample "test"=40000/], size =  2, position = 44
match_results[0] length = 22, str = '[sample "test"=30000/]'
match_results[1] length = 5, str = '30000'
--------------------------------
prefix = , suffix = , size =  2, position = 66
match_results[0] length = 22, str = '[sample "test"=40000/]'
match_results[1] length = 5, str = '40000'
--------------------------------
last suffix =  length = 0

■■■ : 
*/
// GCC reference:
//   https://gcc.gnu.org/

// C++ language references:
//   https://cppreference.com/
//   https://isocpp.org/
//   http://www.open-std.org/jtc1/sc22/wg21/

// Boost libraries references:
//   https://www.boost.org/doc/
</pre>
