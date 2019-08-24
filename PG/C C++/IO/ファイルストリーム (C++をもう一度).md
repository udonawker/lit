引用<br/>
[ファイルストリーム (C++をもう一度)](https://www.qoosky.io/techs/736a22850b "ファイルストリーム (C++をもう一度)")<br/>

## テキストモード
### 読み込み
input.txt<br/>

```
1 10 100
2 20 200
```
main.cpp
```
#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib> // EXIT_FAILURE のため
using namespace std;

int main() {
    fstream fs;

    fs.open("input.txt", ios::in);
    if(! fs.is_open()) {
        // exit だけでなく return の戻り値としても使用できる。
        return EXIT_FAILURE;
    }

    // 文字列として一行読み込む
    string str;
    getline(fs, str); //← cin ( https://www.qoosky.io/techs/d5709e9878 ) ではなく今回は fs
    cout << str << endl; //=> 1 10 100

    // cin のように一行読み込む
    int l,m,n;
    fs >> l >> m >> n;
    cout << "l: " << l << ", "
            "m: " << m << ", "
            "n: " << n << endl; //=> l: 2, m: 20, n: 200

    fs.close(); // デストラクタでも閉じてくれますが、明示的に閉じる習慣を。

    return 0;
}
```

### 書き込み
main.cpp(UTF-8)<br/>

```
#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib> // EXIT_FAILURE のため
using namespace std;

int main() {
    fstream fs;

    fs.open("output.txt", ios::out);
    if(! fs.is_open()) {
        return EXIT_FAILURE;
    }

    // シンプルに書き出す
    fs << "改行含める" << endl; // 改行。そして書き出す
    fs << "改行含めない" << flush; // 書き出すだけ

    // flush() メソッドで書き出す
    fs << "改行含めない";
    fs.flush(); // cout.flush() というのも実はあり、同様の効果です

    // close() で暗黙的に書き出す (閉じるときにバッファをすべて書き出してくれる)
    fs << "改行含めない";
    fs.close();

    return 0;
}
```

output.txt(UTF-8)
```
改行含める
改行含めない改行含めない改行含めない  ← 改行なしでEOF
```
## フラグ
上記サンプルコード内の<br/>
- 入力: ios::in
- 出力: ios::out
という基本のフラグにオプションとなるフラグを追加することで、入出力に関する振舞を変更できます。<br/>
ちなみに ios::out ではファイルが存在していなくても is_open() は true になりますが ios::in では false になります。<br/>

- 追記(append): ios::app
- ファイルが存在していれば破棄(truncate): ios::trunc
- ファイルポインタを末尾(at e(nd))に移動: ios::ate
- バイナリモードで開く: ios::binary
組み合わせの例をいくつか示します。<br/>

|mode  |説明  |
|---|---|
|ios::in &#x7C; ios::out|読み込みと書き込みができる。<br/>既存のファイル内容は書き込んだ時点で破棄される。|
|ios::in &#124; ios::out &#124; ios::app|読み込みと書き込みができる。<br/>書き込んだ内容は既存のファイルがあれば追記される。<br/>なければ新規作成される。|
|ios::in &#124; ios::app|エラーです。<br/>読み込みのみで追記というオプションは意味をなしません。|
|ios::out &#124; ios::app|書き込みができる。<br/>書き込んだ内容は既存のファイルがあれば追記される。<br/>なければ新規作成される。|
|ios::in &#124; ios::out &#124; ios::trunc|読み込みと書き込みができる。<br/>既存のファイル内容は開いた時点で破棄される。|
|ios::in &#124; ios::trunc|エラーです。<br/>何も読み込めないファイルストリームを作成しても無意味です。|
|ios::out &#124; ios::trunc|書き込みができる。<br/>既存のファイル内容は開いた時点で破棄される (開いた時点で破棄せずとも out すれば勝手に上書きされるため ios::out だけの場合と実質的には同じです。冗長な表現です)|

## バイナリモード
テキストモードの場合、「fs << "\n" << flush」が例えば Windows だと "\r\n" になりました。<br/>
読み込みの場合にも "\r\n" は改行として扱われました。<br/>
一方、バイナリモードの場合、「fs << "\n" << flush」はOSによらず "\n" のまま出力されます。<br/>
読み込みについても OS によらず "\n" として読み込まれます。<br/><br/>
実は、バイナリモードとテキストモードの違いはこの「改行コードの扱い」だけです。<br/>
ios::binary を忘れに注意してください。<br/>
改行コードの点でしか違いがないため不具合が発生する箇所が限定的であり気づきにくいです。<br/>

### 書き込み
```
#include <iostream>
#include <fstream>
#include <cstdlib>
using namespace std;

int main() {
    fstream fs;

    fs.open("output.bin", ios::out | ios::binary);
    if(! fs.is_open()) {
        return EXIT_FAILURE;
    }

    int n = 0x41424344; // 16進数 (4バイト (4ビット: 2進数1111 == 16進数F なので、32ビットで4バイト))
    // int n = 010120441504; // 8進数
    // int n = 1094861636; // 10進数
    // int n = 'A' * (16*16*16*16*16*16) + 'B' * (16*16*16*16) + 'C' * (16*16) + 'D';
    // ↑0x41, 0x42, 0x43, 0x44 は 'A','B','C','D' のアスキーコード (1バイト x 4)

    // int型 sizeof n バイト (通常4バイト) の領域の先頭
    // アドレス &n を write の引数 const char* にキャスト
    fs.write((const char*)&n, sizeof n);

    //=> cat output.bin (↓endian: バイトオーダの種類を表す言葉
    //     バイトオーダはCPUに依存して決定されることがほとんどです)
    // - リトルエンディアン "DCBA"
    //   (反転します)
    //   - オフセット(アドレス先頭&nからのバイト差) 0: 0x44
    //   - オフセット 1: 0x43
    //   - オフセット 2: 0x42
    //   - オフセット 3: 0x41
    // - ビッグエンディアン "ABCD"
    //   - オフセット 0: 0x41
    //   - オフセット 1: 0x42
    //   - オフセット 2: 0x43
    //   - オフセット 3: 0x44
    // ↑ファイルとメモリは本質的に同じ。binaryモードはメモリ内容をダンプしている
    //   イメージです。メモリ上でもバイトオーダは等しくなります。

    fs.close();
    return 0;
}
```

### 読み込み
input.bin<br/>
```
DCBA  ← 改行なしでEOF
```
main.cpp<br/>
```
#include <iostream>
#include <fstream>
#include <cstdlib>
using namespace std;

int main() {
    fstream fs;

    fs.open("input.bin", ios::in | ios::binary);
    if(! fs.is_open()) {
        return EXIT_FAILURE;
    }

    int n;
    fs.read((char*)&n, sizeof n); // 0x41424344
    cout << n << endl; //=> 1094861636 (sizeof n == 4 かつリトルエンディアンの場合)

    fs.close();
    return 0;
}
```
