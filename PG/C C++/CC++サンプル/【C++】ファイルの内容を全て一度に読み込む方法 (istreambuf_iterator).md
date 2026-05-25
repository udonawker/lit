## 20260525 [【C++】ファイルの内容を全て一度に読み込む方法 (istreambuf_iterator)](https://morinokabu.com/2025/09/04/cpp-read-entire-file-istreambuf-iterator/)

```
#include <iostream>
#include <fstream>   // ifstream, ofstream
#include <vector>
#include <iterator>  // istreambuf_iterator
#include <string>

using namespace std;

int main() {
    const string filename = "data.bin";
    
    // 1. テスト用のファイルを作成
    ofstream ofs(filename, ios_base::binary);
    ofs << "Hello, C++!";
    ofs.close();
    
    // 2. ファイルをバイナリモードで開く
    ifstream ifs(filename, ios_base::binary);
    
    // ファイルが開けなかった場合のエラーチェック
    if (!ifs) {
        cerr << "ファイルを開けません: " << filename << endl;
        return 1;
    }

    // 3. istreambuf_iteratorを使って、ファイル全体をvectorに一括で読み込む
    vector<char> file_contents(
        (istreambuf_iterator<char>(ifs)), // 開始イテレータ
        (istreambuf_iterator<char>())    // デフォルトコンストラクタで終了イテレータ
    );

    // 4. 読み込んだ内容を確認
    cout << "ファイルから読み込んだ内容 (" << file_contents.size() << "バイト):" << endl;
    for (char c : file_contents) {
        cout << c;
    }
    cout << endl;

    return 0;
}
```
