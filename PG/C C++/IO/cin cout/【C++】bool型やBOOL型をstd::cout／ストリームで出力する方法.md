引用 [【C++】bool型やBOOL型をstd::cout／ストリームで出力する方法](https://marycore.jp/prog/cpp/print-bool/) <br/>

## bool型

`boolalpha`マニピュレーターを用いれば`true/false`形式での出力が可能になります。デフォルトは`1/0`形式です。<br/>

<pre>
bool b = true;
cout << b;                     // 1
cout << std::boolalpha   << b; // true
cout << std::noboolalpha << b; // 1
</pre>

## BOOL型

BOOL型がchar型ベースの場合は、int型やbool型へのキャストや条件演算子を用いた明示的な変換が必要になります。<br/>

<pre>
typedef unsigned char BOOL;
#define TRUE  1
#define FALSE 0

BOOL b = TRUE;
cout << b;                     // 何も表示されない
cout << (int)b;                // 1
cout << static_cast<int>(b);   // 1
cout << (b ? "TRUE" : "FALSE"); // TRUE
cout << (b ? 1 : 0);            // 1
cout << !!b;                    // 1
cout << std::boolalpha << (bool)b; // true
</pre>
