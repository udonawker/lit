引用<br/>
[ファイルの比較](https://www.wabiapp.com/WabiSampleSource/windows/file_compere.html "ファイルの比較")<br/>

<pre>
#include <stdio.h>
#include <tchar.h>
#include <iostream>
#include <fstream>
 
 
 
/*
    ファイルの比較
*/
void compere_file
(
      std::wstring oFile1
    , std::wstring oFile2
)
{
    std::ifstream ifstr1( oFile1.c_str(), std::ios::binary );
    std::ifstream ifstr2( oFile2.c_str(), std::ios::binary );
 
    // ファイルの比較
    if ( std::equal( std::istreambuf_iterator<char>( ifstr1 )
        , std::istreambuf_iterator<char>(), std::istreambuf_iterator<char>( ifstr2 ) ) ) {
        std::wcout << L"一致しました" << std::endl;
    }
    else {
        std::wcout << L"一致しませんでした" << std::endl;
    }
}
 
 
 
int _tmain
(
      int argc
    , _TCHAR* argv[]
)
{
    // 標準出力にユニコード出力する
    setlocale( LC_ALL, "Japanese" );
 
    // ファイルを比較する
    compere_file( L"file1.txt", L"file2.txt" );
 
    // 正常終了
    return( 0 );
}
</pre>


引用<br/>
[C++のstd::equalやstd::mismatchで指定範囲の要素を比較する](https://www.gesource.jp/weblog/?p=4532 "C++のstd::equalやstd::mismatchで指定範囲の要素を比較する")<br/>

C++のstd::equalやstd::mismatchで指定範囲の要素を比較する<br/>
std::equalは指定した範囲をoperator==で比較します。<br/>

<pre>
std::vector<std::string> vec1, vec2;
vec1.push_back("C++");
vec1.push_back("Java");
vec1.push_back("Python");

vec2.push_back("C++");
vec2.push_back("Java");
vec2.push_back("Python");

//vec1.begin()からvec1.end()までの範囲をoperator==で比較する
if (std::equal(vec1.begin(), vec1.end(), vec2.begin())) {
  std::cout << "equal" << std::endl;
} else {
  std::cout << "not equal" << std::endl;
}
</pre>

<br/>
<br/>
std::equalの第4引数で、operator==の代わりに比較する関数を指定できます。<br/>

<pre>
#include <algorithm>

//大文字小文字を区別しないで比較する
struct compare {
  bool operator()(const std::string& s1, const std::string& s2) {
    return (stricmp(s1.c_str(), s2.c_str()) == 0);
  }
};

std::vector<std::string> vec1, vec2;
vec1.push_back("C++");
vec1.push_back("Java");
vec1.push_back("Python");

vec2.push_back("c++");
vec2.push_back("java");
vec2.push_back("python");

if (std::equal(vec1.begin(), vec1.end(), vec2.begin(), compare())) {
  std::cout << "equal" << std::endl;
} else {
  std::cout << "not equal" << std::endl;
}
</pre>

<br/>
<br/>
std::mismatchは2つのシーケンスの等しくない最初の要素を返します。<br/>

<pre>
std::vector<std::string> vec1, vec2;
vec1.push_back("C++");
vec1.push_back("Java");
vec1.push_back("Python");

vec2.push_back("C++");
vec2.push_back("Java");
vec2.push_back("python");

std::pair<std::vector<std::string>::iterator, std::vector<std::string>::iterator> p = 
  std::mismatch(vec1.begin(), vec1.end(), vec2.begin());

std::cout << *(p.first) << std::endl; //Python
std::cout << *(p.second) << std::endl; //python
</pre>
