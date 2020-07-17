# [std::mapまとめ](https://qiita.com/_EnumHack/items/f462042ec99a31881a81)
## keyとvalue
## map::at
## mapのvalue_type
## std::pair
## 自動で値を挿入せず, 例外も出さずに存在しない可能性のあるキーを指定したい(存在チェック)
## 双方向イテレータ
## mapの内部構造とstrict weak ordering
## mapへの要素操作
### 要素挿入
#### map::insert
#### map::emplace
### 要素削除
#### key指定のmap::erase
#### イテレータ指定のmap::erase
#### イテレータ範囲指定のmap::erase
#### map::clear
## mapテクニック
### stringをkeyにする場合にstd::less<>を第3テンプレート引数に指定する
### map::emplace_hintを使って挿入時のfindを省く
### mapのvalue_typeはautoで推論する

## mapのイテレーション
mapはコンテナなのでイテレータを取得してレンジを回すことができる.<br>

<pre>
#include <map>
#include <iostream>

int main(){
    std::map<std::string, unsigned> dictionary{
        {"John", 1000},
        {"Tom", 1400},
        {"Harry", 800}
    };

    for (const auto& [key, value] : dictionary){
        std::cout << key << " => " << value << "\n";
    }
}
</pre>
output<br>
> Harry => 800<br>
> John => 1000<br>
> Tom => 1400<br>
