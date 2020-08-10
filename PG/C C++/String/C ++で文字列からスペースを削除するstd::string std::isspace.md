## [C ++で文字列からスペースを削除する](https://www.it-swarm.dev/ja/c%2B%2B/c-%E3%81%A7%E6%96%87%E5%AD%97%E5%88%97%E3%81%8B%E3%82%89%E3%82%B9%E3%83%9A%E3%83%BC%E3%82%B9%E3%82%92%E5%89%8A%E9%99%A4%E3%81%99%E3%82%8B/1072027550/)
## [std :: stringの空白を削除します](https://www.it-swarm.dev/ja/c++/std-string%E3%81%AE%E7%A9%BA%E7%99%BD%E3%82%92%E5%89%8A%E9%99%A4%E3%81%97%E3%81%BE%E3%81%99/1069931781/)

<pre>
std::string input;
input.erase(std::remove(input.begin(), input.end(), ' '), input.end());
</pre>

<pre>
std::string input;
input.erase(std::remove_if(input.begin(), input.end(), std::isspace), input.end());
// C++11では使えない?
// C++11では以下
input.erase(std::remove_if(input.begin(), input.end(), []( char ch ) { return std::isspace<char>( ch, std::locale::classic() ); }), input.end());
</pre>
