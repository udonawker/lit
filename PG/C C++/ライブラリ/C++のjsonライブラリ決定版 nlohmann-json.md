## 20260507 [C++のjsonライブラリ決定版 nlohmann-json](https://qiita.com/yohm/items/0f389ba5c5de4e2df9cf)
## 20260507 [C++でJSONを爆速で扱える！現場で使える実践ガイド2024](https://dexall.co.jp/articles/?p=1865)
## 20260507 nlohmann/json を使ったファイル読み込み手順

- nlohmann/json を使ったファイル読み込み手順
- ライブラリの取得: nlohmann/jsonのGitHubからjson.hppをダウンロードし、プロジェクトに配置。
- コードの実装:cpp
```
#include <iostream>
#include <fstream>
#include <nlohmann/json.hpp>

// 便利のためのエイリアス
using json = nlohmann::json;

int main() {
    // 1. ファイルを開く
    std::ifstream file("data.json");
    if (!file.is_open()) {
        std::cerr << "ファイルを開けませんでした" << std::endl;
        return 1;
    }

    // 2. JSONをパース
    json data;
    try {
        file >> data; // ストリームから直接読み込み
    } catch (const json::parse_error& e) {
        std::cerr << "パースエラー: " << e.what() << std::endl;
        return 1;
    }

    // 3. データの取得
    std::string name = data["name"];
    int age = data["age"];
    std::cout << "Name: " << name << ", Age: " << age << std::endl;

    return 0;
}
```
