[C++ std::string 文字列の分割（split）｜区切り文字／文字列に対応](https://marycore.jp/prog/cpp/std-string-split/ "C++ std::string 文字列の分割（split）｜区切り文字／文字列に対応")<br/>

```
// #include <sstream> // std::stringstream
// #include <istream> // std::getline

std::vector<std::string> v;

std::string s = ",a,b,,c,";
std::stringstream ss{s};
std::string buf;
while (std::getline(ss, buf, ',')) {
  v.push_back(buf);
}

v; // v == {"", "a", "b", "", "c"}
```

[【C++入門】文字列を分割するsplit関数の実装](https://www.sejuku.net/blog/49378 "【C++入門】文字列を分割するsplit関数の実装")<br/>

[C++におけるstringのsplit](https://qiita.com/iseki-masaya/items/70b4ee6e0877d12dafa8 "C++におけるstringのsplit")
```
#include <vector>
#include <string>
#include <sstream>

using namespace std;

vector<string> split(const string &s, char delim) {
    vector<string> elems;
    stringstream ss(s);
    string item;
    while (getline(ss, item, delim)) {
    if (!item.empty()) {
            elems.push_back(item);
        }
    }
    return elems;
}
```
