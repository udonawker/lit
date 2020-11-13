## [Std :: stringとintを連結する方法](https://www.it-swarm-ja.tech/ja/c++/std-string%E3%81%A8int%E3%82%92%E9%80%A3%E7%B5%90%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95/958463073/)

<pre>
std::string name = "John";
int age = 21;
std::string result;

// 1. with Boost
result = name + boost::lexical_cast&lt;std::string&gt;(age);

// 2. with C++11
result = name + std::to_string(age);

// 3. with FastFormat.Format
fastformat::fmt(result, "{0}{1}", name, age);

// 4. with FastFormat.Write
fastformat::write(result, name, age);

// 5. with the {fmt} library
result = fmt::format("{}{}", name, age);

// 6. with IOStreams
std::stringstream sstm;
sstm << name << age;
result = sstm.str();

// 7. with itoa
char numstr[21]; // enough to hold all numbers up to 64-bits
result = name + itoa(age, numstr, 10);

// 8. with sprintf
char numstr[21]; // enough to hold all numbers up to 64-bits
sprintf(numstr, "%d", age);
result = name + numstr;

// 9. with STLSoft's integer_to_string
char numstr[21]; // enough to hold all numbers up to 64-bits
result = name + stlsoft::integer_to_string(numstr, 21, age);

// 10. with STLSoft's winstl::int_to_string()
result = name + winstl::int_to_string(age);

// 11. With Poco NumberFormatter
result = name + Poco::NumberFormatter().format(age);
</pre>

1. 安全ですが遅いです。 ブースト （ヘッダーのみ）が必要です。ほとんど/すべてのプラットフォーム
1. 安全です、C++ 11が必要です（ to_string（） はすでに#include <string>に含まれています）
1. 安全で高速です。 FastFormat が必要で、これはコンパイルする必要があります。ほとんど/すべてのプラットフォーム
1. 安全で高速です。 FastFormat が必要で、これはコンパイルする必要があります。ほとんど/すべてのプラットフォーム
1. 安全で高速です。 {fmt}ライブラリ が必要です。これは、コンパイルすることも、ヘッダーのみのモードで使用することもできます。ほとんど/すべてのプラットフォーム
1. 安全で、遅く、そして冗長です。 #include <sstream>が必要です（標準C++から）
1. 壊れやすく（十分な大きさのバッファーを用意する必要があります）、速く、冗長です。 itoa（）は非標準的な拡張であり、すべてのプラットフォームで利用可能であることを保証するものではありません
1. 壊れやすく（十分な大きさのバッファーを用意する必要があります）、速く、冗長です。何も必要としません（標準C++です）。すべてのプラットフォーム
1. 壊れやすい（十分な大きさのバッファを用意しなければならない）、 おそらく最速の変換 、冗長。 STLSoftが必要 /（ヘッダーのみ）。ほとんど/すべてのプラットフォーム
1. 安全です（1つのステートメントで複数の int_to_string（） を使用しないでください）。 STLSoftが必要 /（ヘッダーのみ）。 Windowsのみ
1. 安全ですが遅いです。 Poco C++ ;が必要です。ほとんど/すべてのプラットフォーム
