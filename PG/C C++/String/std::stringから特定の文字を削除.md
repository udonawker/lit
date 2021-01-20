https://teratail.com/questions/34367<br>

<pre>
#include &lt;iostream&gt;
#include &lt;string&gt;
#include &lt;algorithm&gt;

using namespace std;

int main() {
  string str = "abc\r\ndef\r\nghi\r\n";
  string::iterator last = 
    remove_if(str.begin(), str.end(), 
              [](char ch) { return ch == '\r' || ch == '\n'; });
  str.erase(last, str.end());
  cout << '[' << str << "]\n";
}
</pre>

<pre>
#include &lt;boost/range/algorithm_ext/erase.hpp&gt;
#include &lt;boost/algorithm/string/classification.hpp&gt;

void remove_crlf(std::string& s)
{
  boost::remove_erase_if(s, boost::is_any_of("\r\n"));
}
</pre>

https://www.it-swarm-ja.tech/ja/c%2B%2B/c-%E3%81%AE%E6%96%87%E5%AD%97%E5%88%97%E3%81%8B%E3%82%89%E7%89%B9%E5%AE%9A%E3%81%AE%E6%96%87%E5%AD%97%E3%82%92%E5%89%8A%E9%99%A4%E3%81%99%E3%82%8B%E3%81%AB%E3%81%AF%E3%81%A9%E3%81%86%E3%81%99%E3%82%8C%E3%81%B0%E3%82%88%E3%81%84%E3%81%A7%E3%81%99%E3%81%8B%EF%BC%9F/973164178/<br>
<pre>
void removeCharsFromString( string &str, char* charsToRemove ) {
   for ( unsigned int i = 0; i < strlen(charsToRemove); ++i ) {
      str.erase( remove(str.begin(), str.end(), charsToRemove[i]), str.end() );
   }
}
//example of usage:
removeCharsFromString( str, "()-" );
</pre>
