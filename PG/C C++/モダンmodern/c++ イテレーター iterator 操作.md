[std::distance](https://cpprefjp.github.io/reference/iterator/distance.html)<br>
[std::advance](https://cpprefjp.github.io/reference/iterator/ranges_advance.html)<Br>
```
// イテレータ間の距離を求める
auto result = std::distance(container.begin(), itr);

// イテレータをn回あるいは指定された位置まで進める。
std::advance(itr,5);

// n回前方に進めたイテレータを返す。
auto result = std::next(container.begin(), 2);

// n回あるいは指定された位置まで戻したイテレータを返す。
decltype(container)::iterator it = std::prev(container.end(), 2); // イテレータを2回逆に進める

```
