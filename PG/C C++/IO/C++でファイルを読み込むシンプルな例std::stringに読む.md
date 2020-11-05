## [C++でファイルを読み込むシンプルな例](https://www.miraclelinux.com/tech-blog/1n4hgx)
## [ファイルを読み込んでstd::stringを得る](http://blog.cafeform.com/?p=1525)

<pre>
std::string readFile(const char *filename)
{
        std::ifstream ifs(filename);
        return std::string(std::istreambuf_iterator&lt;char&gt;(ifs),
                      std::istreambuf_iterator&lt;char&gt;());
}
</pre>

<pre>
#include &lt;iostream&gt;
#include &lt;fstream&gt;
#include &lt;vector&gt;
 
std::string getStringFromFile(const std::string& filePath) {
     
    std::ifstream ifs(filePath, std::ios::binary);
     
    // ファイルサイズを得る
    ifs.seekg(0, std::ios::end);
    size_t sz = ifs.tellg();
    ifs.seekg(0, std::ios::beg);
     
    //ファイルサイズ分ファイルから読み込む
    std::vector&lt;char&gt; buf(sz);
    ifs.read(buf.data(), sz);
     
    //読み込んだcharデータからstringを作成
    return std::string(buf.data(), sz);
}
 
int main() {
     
    std::string str = getStringFromFile("/var/tmp/note.txt");    
    std::cout << str << std::endl;
}
</pre>

<pre>
std::ifstream f("file.txt");

if (f)
{
  std::stringstream buffer;
  buffer << f.rdbuf();
  f.close();

  // The content of "file.txt" is available in the string `buffer.str()`
}
</pre>

<pre>
std::ifstream f("file.txt");

if (f)
{
  std::string str((std::istreambuf_iterator<char>(f)),
                  std::istreambuf_iterator<char>());

  // Operations on `str`...
}
</pre>

<pre>
std::ifstream f("file.txt");

if (f)
{
  f.seekg(0, std::ios::end);
  const auto size = f.tellg();

  std::string str(size, ' ');
  f.seekg(0);
  f.read(&str[0], size); 
  f.close();

  // Operations on `str`...
}
</pre>
