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
#include &lt;iostream&gt;
#include &lt;iterator&gt;
#include &lt;regex&gt;
#include &lt;string&gt;


std::string tail(std::string const& source, size_t const length) {
  if (length >= source.size()) { return source; }
  return source.substr(source.size() - length);
} // tail

void regex_match(const std::string& s)
{
    std::regex re(R"(\[sample "test"=(\d+)\])");
    std::cout << "■■■ : " << s << std::endl;
    auto suffix_length = s.length();
    std::cout << "length = " << suffix_length << std::endl;
    for (std::sregex_iterator it(std::begin(s), std::end(s), re), end; it != end; ++it) {
        // *it == std::match_results
        auto&& m = *it;
        // std::match_results.prefix()|std::match_results.suffix() == std::sub_match
        std::cout << "prefix = " << m.prefix() << "(" << m.prefix().length() << \
                     "), suffix = " << m.suffix() << "(" << m.suffix().length() << \
                     "), size =  " << m.size() << ", position = " << m.position() << ", length = " << m.length() << std::endl;
        for (decltype(m.size()) pos = 0; pos < m.size(); ++pos) {
          std::cout << "match_results[" << pos << "] length = " << m[pos].length() << ", str = '" << m[pos].str() << '\'' << std::endl;
        }
        suffix_length -= (m.prefix().length() + m.length());
        std::cout << "--------------------------------" << std::endl;
    }
    std::cout << "last suffix length = " << suffix_length << " : suffix = " << tail(s, suffix_length) << std::endl;
    std::cout << std::endl;
}

int main()
{
    std::string strs[] = {
        "[sample \"test\"=10000]てすと[sample \"test\"=3000]テストテスト[sample \"test\"=123]わわわわ～", 
        "てすと[sample \"test\"=3000]テストテスト[sample \"test\"=123]わわわわ～", 
        "[sample \"test\"=10000]てすと[sample \"test\"=3000]テストテスト[sample \"test\"=123]わわわわ～[sample \"test\"=99999]",
        "[sample \"test\"=10000][sample \"test\"=20000][sample \"test\"=30000][sample \"test\"=40000]",
        "ああああ いいいい",
        "" };

    for (const auto& str : strs) {
        regex_match(str);
    }

    return 0;
}

/*
■■■ : [sample "test"=10000]てすと[sample "test"=3000]テストテスト[sample "test"=123]わわわわ～
length = 102
prefix = (0), suffix = てすと[sample "test"=3000]テストテスト[sample "test"=123]わわわわ～(81), size =  2, position = 0, length = 21
match_results[0] length = 21, str = '[sample "test"=10000]'
match_results[1] length = 5, str = '10000'
--------------------------------
prefix = てすと(9), suffix = テストテスト[sample "test"=123]わわわわ～(52), size =  2, position = 30, length = 20
match_results[0] length = 20, str = '[sample "test"=3000]'
match_results[1] length = 4, str = '3000'
--------------------------------
prefix = テストテスト(18), suffix = わわわわ～(15), size =  2, position = 68, length = 19
match_results[0] length = 19, str = '[sample "test"=123]'
match_results[1] length = 3, str = '123'
--------------------------------
last suffix length = 15 : suffix = わわわわ～

■■■ : てすと[sample "test"=3000]テストテスト[sample "test"=123]わわわわ～
length = 81
prefix = てすと(9), suffix = テストテスト[sample "test"=123]わわわわ～(52), size =  2, position = 9, length = 20
match_results[0] length = 20, str = '[sample "test"=3000]'
match_results[1] length = 4, str = '3000'
--------------------------------
prefix = テストテスト(18), suffix = わわわわ～(15), size =  2, position = 47, length = 19
match_results[0] length = 19, str = '[sample "test"=123]'
match_results[1] length = 3, str = '123'
--------------------------------
last suffix length = 15 : suffix = わわわわ～

■■■ : [sample "test"=10000]てすと[sample "test"=3000]テストテスト[sample "test"=123]わわわわ～[sample "test"=99999]
length = 123
prefix = (0), suffix = てすと[sample "test"=3000]テストテスト[sample "test"=123]わわわわ～[sample "test"=99999](102), size =  2, position = 0, length = 21
match_results[0] length = 21, str = '[sample "test"=10000]'
match_results[1] length = 5, str = '10000'
--------------------------------
prefix = てすと(9), suffix = テストテスト[sample "test"=123]わわわわ～[sample "test"=99999](73), size =  2, position = 30, length = 20
match_results[0] length = 20, str = '[sample "test"=3000]'
match_results[1] length = 4, str = '3000'
--------------------------------
prefix = テストテスト(18), suffix = わわわわ～[sample "test"=99999](36), size =  2, position = 68, length = 19
match_results[0] length = 19, str = '[sample "test"=123]'
match_results[1] length = 3, str = '123'
--------------------------------
prefix = わわわわ～(15), suffix = (0), size =  2, position = 102, length = 21
match_results[0] length = 21, str = '[sample "test"=99999]'
match_results[1] length = 5, str = '99999'
--------------------------------
last suffix length = 0 : suffix = 

■■■ : [sample "test"=10000][sample "test"=20000][sample "test"=30000][sample "test"=40000]
length = 84
prefix = (0), suffix = [sample "test"=20000][sample "test"=30000][sample "test"=40000](63), size =  2, position = 0, length = 21
match_results[0] length = 21, str = '[sample "test"=10000]'
match_results[1] length = 5, str = '10000'
--------------------------------
prefix = (0), suffix = [sample "test"=30000][sample "test"=40000](42), size =  2, position = 21, length = 21
match_results[0] length = 21, str = '[sample "test"=20000]'
match_results[1] length = 5, str = '20000'
--------------------------------
prefix = (0), suffix = [sample "test"=40000](21), size =  2, position = 42, length = 21
match_results[0] length = 21, str = '[sample "test"=30000]'
match_results[1] length = 5, str = '30000'
--------------------------------
prefix = (0), suffix = (0), size =  2, position = 63, length = 21
match_results[0] length = 21, str = '[sample "test"=40000]'
match_results[1] length = 5, str = '40000'
--------------------------------
last suffix length = 0 : suffix = 

■■■ : ああああ いいいい
length = 25
last suffix length = 25 : suffix = ああああ いいいい

■■■ : 
length = 0
last suffix length = 0 : suffix = 
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
    const char* suffix = s.c_str();
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
        std::cout << "last suffix = " << suffix << " length = " << std::char_traits&lt;char&gt;::length(suffix) << std::endl;
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
        "ああああ いいいい",
        "" };

    for (const auto& str : strs) {
        regex_match(str);
    }

    return 0;
}

// $ g++ prog.cc -Wall -Wextra -std=c++11
// std::string_literal
// std::regex_iterator
// constexpr char str[] "aaa";
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

■■■ : ああああ いいいい
last suffix = ああああ いいいい length = 25

■■■ : 
last suffix =  length = 0
*/
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
