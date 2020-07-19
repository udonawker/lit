# [C++でファイル読込み パターン別まとめ](https://gup.monster/entry/2014/04/03/233500)

1. char *型に一行ずつ読込む
2. string型に一行ずつ読込む
3. char *型に全部読込む
4. string型に全部読込む

## テスト用ファイル(test.txt)
<pre>
123456
89
</pre>

※このファイルは1行目は改行ありで、2行目は改行なしです<br>
　**(ただし、Vimなどのエディタでは改行なしの最終行を作ることはできないことに注意)。**<br>
 
## 1. char*型に一行ずつ読込む
<pre>
#include &lt;fstream&gt;
#include &lt;iostream&gt;
#include &lt;string&gt;

int main()
{
    std::ifstream ifs("test.txt");
    char str[256];
    if (ifs.fail())
    {
        std::cerr << "失敗" << std::endl;
        return -1;
    }
    while (ifs.getline(str, 256 - 1))
    {
        std::cout << "[" << str << "]" << std::endl;
    }
    return 0;
}
</pre>

### 実行結果
<pre>
[123456]
[89]
</pre>

## 2. string型に一行ずつ読込む
<pre>
#include &lt;fstream&gt;
#include &lt;iostream&gt;
#include &lt;string&gt;

int main()
{
    std::ifstream ifs("test.txt");
    std::string str;
    if (ifs.fail())
    {
        std::cerr << "失敗" << std::endl;
        return -1;
    }
    while (getline(ifs, str))
    {
        std::cout << "[" << str << "]" << std::endl;
    }
    return 0;
}
</pre>

※こちらはメンバ関数ではありませんので注意<br>
### 実行結果
<pre>
[123456]
[89]
</pre>

2のパターンでは下記リンクのようにもかけます。<br>
[file io - C++: Using ifstream with getline(); - Stack Overflow](http://stackoverflow.com/questions/12133379/c-using-ifstream-with-getline)<br>

## 3. char*型に全部読込む
<pre>
#include &lt;fstream&gt;
#include &lt;iostream&gt;
#include &lt;string&gt;
#include &lt;cstring&gt;

int main()
{
    std::ifstream ifs("test.txt");
    if (ifs.fail())
    {
        std::cerr << "失敗" << std::endl;
        return -1;
    }
    int begin = static_cast<int>(ifs.tellg());
    ifs.seekg(0, ifs.end);
    // 一応範囲チェックすべきだけど……
    int end = static_cast<int>(ifs.tellg());
    int size = end - begin;
    ifs.clear();  // ここでclearしてEOFフラグを消す
    ifs.seekg(0, ifs.beg);
    char *str = new char[size + 1];
    str[size] = '\0';  // 念のため末尾をNULL文字に
    ifs.read(str, size);
    std::cout << "[" << str << "]" << std::endl;
    std::cout << "size: " << size << "    strlen: " << std::strlen(str) << std::endl;
    delete[] str;
    return 0;
}
</pre>

### 実行結果
<pre>
[123456
89]
size: 10    strlen: 9
</pre>

### 補足
上記で使用しているreadは<br>
istream& read (char* s, streamsize n);<br>
という定義です。<br>

## 4. string型に全部読込む(ダメな方法)
<pre>
#include &lt;fstream&gt;
#include &lt;iostream&gt;
#include &lt;string&gt;

int main()
{
    std::ifstream ifs("test.txt");
    if (ifs.fail())
    {
        std::cerr << "失敗" << std::endl;
        return -1;
    }
    int begin = static_cast<int>(ifs.tellg());
    ifs.seekg(0, ifs.end);
    int end = static_cast<int>(ifs.tellg());
    ifs.clear();
    ifs.seekg(0, ifs.beg);
    int size = end - begin;
    //std::string str(size, '\0');  // こういう小細工をしてもダメ
    std::string str;
    ifs.read(&str[0], size);        // 無理やりchar *にする…
    std::cout << "[" << str << "]" << std::endl;
    std::cout << "size: " << size << "    strlen: " << str.length() << std::endl;
    return 0;
}
</pre>

### 実行結果
<pre>
[]
size: 10    strlen: 0
</pre>
※環境によって実行結果が異なることもあるかもしれません。<br>
istream& read (char* s, streamsize n);はstringに対応していないのです。<br>
じゃあ、ファイル一気読みしてstringに入れられないの？と思いましたが、方法はあります。<br>

## 4. string型に全部読込む
<pre>
#include &lt;fstream&gt;
#include &lt;iostream&gt;
#include &lt;string&gt;
#include &lt;iterator&gt;

int main()
{
    std::ifstream ifs("test.txt");
    if (ifs.fail())
    {
        std::cerr << "失敗" << std::endl;
        return -1;
    }
    std::string str((std::istreambuf_iterator<char>(ifs)),
        std::istreambuf_iterator<char>());
    std::cout << "[" << str << "]" << std::endl;
    return 0;
}
</pre>
<pre>
#include &lt;fstream&gt;
#include &lt;iostream&gt;
#include &lt;string&gt;
#include &lt;iterator&gt;

int main()
{
    std::ifstream ifs("test.txt");
    if (ifs.fail())
    {
        std::cerr << "失敗" << std::endl;
        return -1;
    }
    // ほとんどさっきと同じですが、こうもかけます。こっちのほうがわかりやすい
    std::istreambuf_iterator<char> it(ifs);
    std::istreambuf_iterator<char> last;
    std::string str(it, last);
    std::cout << "[" << str << "]" << std::endl;
    return 0;
}
</pre>

### 実行結果
<pre>
[123456
89]
</pre>
さらに、g++(4.8.3)では今回の場合、明示的に<br>
<pre>
#include &lt;cstdlib&gt;
</pre>
を書かないとEXIT_FAULUREマクロも使えないんですね。<br>
この方法で使っているstreambuf_iteratorが<br>
どんなものか知りたい場合は下記を参照してみてください。<br>
[string型にファイルを一気読みできるstreambuf_iteratorのおおまかな仕組み](https://gup.monster/entry/2014/07/19/051546)<br>
もちろん、上記で紹介した以外にも標準Cランタイムライブラリを使う方法もあります。<br>
fgets()ですね。事実上現在これが読込みが最速なのですが……。<br>
<br>
[C++ティプス](http://funktor.org/programming/cpp/tips)<br>
[MASATOの開発日記: ファイル読み出しコードの性能評価](http://www.sutosoft.com/room/archives/000441.html)<br>

## テキストモードとバイナリモードについて
今回はテキストモードのみ使用しています。ifstreamのコンストラクタの第2引数にstd::ios::binaryを指定してあげるとバイナリモードになります。<br>
ちなみにstd::ios_base::binaryとかほかにもいろいろあるんだけど、どれを使うのが標準的なのか僕は知りません。std::iosが無難なのかな？<br>
テキストモードとバイナリモードの違いですが、まぁ、グーグル先生が割と的確な答えをいってくれるのですが、一言でいうと、改行の扱いを環境(≒OS)によってうまいことやってくれるってやつです。<br>
Windowsだと改行はCR+LFで、Linux系(今のMac含む)はLFで違いますよね。<br>
余計なことすんな！なときはstd::ios::binaryを指定してあげましょう。<br>
