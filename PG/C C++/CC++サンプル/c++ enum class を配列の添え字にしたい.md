## 20260525 [配列のインデックスに列挙型を使う(C++11)](https://qiita.com/SaitoAtsushi/items/b7f2aef6df10ba5da77d)

- enum classを配列やstd::vectorの添え字として使うには、static_castを用いてstd::size_tなどの整数型に明示的に変換する必要があります。cpp#include <iostream>
```
#include <vector>
#include <array>

enum class Fruit { Apple, Orange, Melon, Size };

int main() {
    // std::array を使った例（要素数として Size を利用）
    std::array<int, static_cast<std::size_t>(Fruit::Size)> prices = { 100, 150, 500 };

    // static_cast で整数値に変換して配列の添え字にする
    std::cout << "りんごの価格: " << prices[static_cast<std::size_t>(Fruit::Apple)] << std::endl;
}
```
<br>

- 安全かつ簡潔に扱うための代表的なアプローチは以下の通りです。<br>
1. 変換用ヘルパー関数を作る（推奨）毎回static_castを書くのは手間なため、列挙型を引数に取ってstd::size_tを返すインライン関数を定義するのが一般的です。cpptemplate<typename E><br>
(c++14から)<br>
```
constexpr auto to_index(E e) noexcept {
    return static_cast<std::size_t>(e);
}
```

// 使い方<br>
```
int apple_price = prices[to_index(Fruit::Apple)];
```

2. 添え字演算子（operator[]）をオーバーロードする専用のラッパークラス（またはstd::arrayやstd::vectorの派生）を定義し、enum classをそのまま渡せるように演算子をオーバーロードします。<br>
3. 要素数を自動管理するトリックenum classの末尾にCountやSizeといった要素を配置し、それを配列のサイズとして流用します。※このとき、明示的に数値を指定していない限り、先頭は 0 から順に割り当てられるため、末尾の要素が全体の要素数と一致します。<br>
```
cppenum class Category {
    Food,
    Book,
    Toy,
    Size // 要素数として利用 (この場合 3)
};
```
