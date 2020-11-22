# [algorithm](https://cpprefjp.github.io/reference/algorithm.html)

全てのアルゴリズムはデータ構造の実装の詳細から切り離されていて、イテレータによってパラメータ化されている。これはアルゴリズムの要件を満たすイテレータを提供しているなら、どのようなデータ構造であっても動作するということを示している。<br>
関数オブジェクトを使用するアルゴリズムでは、for_eachとfor_each_n以外、引数として渡されたオブジェクトを書き換えてはならない。<br>
ここでは、各アルゴリズムのテンプレートパラメータ名を、型の要件を表すために使っている。アルゴリズムを正しく利用するためには、テンプレートパラメータ名に応じたこれらの要件を満たしている必要がある。以下の通りである。<br>

|テンプレートパラメータ名|要件|
|:--|:--|
|InputIterator<br>InputIterator1<br>InputIterator2|input iterator|
|OutputIterator<br>OutputIterator1<br>OutputIterator2|output iterator|
|ForwardIterator<br>ForwardIterator1<br>ForwardIterator2|forward iterator|
|BidirectionalIterator<br>BidirectionalIterator1<br>BidirectionalIterator2|bidirectional iterator|
|RandomAccessIterator<br>RandomAccessIterator1<br>RandomAccessIterator2|random-access iterator|


## シーケンスを変更しない操作
|名前|説明|対応バージョン|
|:--|:--|:--|
|all_of|全ての要素が条件を満たしているかを調べる|C++11|
|any_of|どれかの要素が条件を満たしているかを調べる|C++11|
|none_of|全ての要素が条件を満たしていないかを調べる|C++11|
|for_each|全ての要素に対して処理を行う||
|for_each_n|範囲の先頭N個の要素に対して処理を行う|C++17|
|find|指定された値を検索する||
|find_if|条件を満たす最初の要素を検索する||
|find_if_not|条件を満たしていない最初の要素を検索する|C++11|
|find_end|指定された最後のサブシーケンスを検索する||
|find_first_of|ある集合の1つとマッチする最初の要素を検索する||
|adjacent_find|隣接する要素で条件を満たしている最初の要素を検索する||
|count|指定された値である要素の数を数える||
|count_if|条件を満たしている要素の数を数える||
|mismatch|2つの範囲が一致していない場所を検索する||
|equal|2つの範囲を等値比較する||
|search|指定された最初のサブシーケンスを検索する||
|search_n|指定された最初のサブシーケンスを検索する||


## シーケンスを変更する操作
|名前|説明|対応バージョン|
|:--|:--|:--|
|copy|指定された範囲の要素をコピーする||
|copy_n|指定された数の要素をコピーする|C++11|
|copy_if|条件を満たす要素のみをコピーする|C++11|
|copy_backward|指定された範囲の要素を後ろからコピーする||
|move|指定された範囲の要素をムーブする|C++11|
|move_backward|指定された範囲の要素を後ろからムーブする|C++11|
|swap_ranges|指定された2つの範囲同士を swap する||
|iter_swap|2つのイテレータの要素を swap する||
|transform|全ての要素に関数を適用する||
|replace|指定された値と一致する要素を指定された値に置き換える||
|replace_if|条件を満たす要素を指定された値に置き換える||
|replace_copy|指定された値を一致する要素を指定された値に置き換え、その結果を出力の範囲へコピーする||
|replace_copy_if|条件を満たす要素を指定された値に置き換え、その結果を出力の範囲へコピーする||
|fill|指定された値で出力の範囲に書き込む||
|fill_n|指定された値で出力の範囲に n 個書き込む||
|generate|出力の範囲へ関数の結果を書き込む||
|generate_n|出力の範囲へ関数の結果を n 個書き込む||
|remove|指定された要素を除ける||
|remove_if|条件を満たす要素を除ける||
|remove_copy|指定された要素を除け、その結果を出力の範囲へコピーする||
|remove_copy_if|条件を満たす要素を除け、その結果を出力の範囲へコピーする||
|unique|重複した要素を除ける||
|unique_copy|重複した要素を除け、その結果を出力の範囲へコピーする||
|reverse|要素の並びを逆にする||
|reverse_copy|要素の並びを逆にし、その結果を出力の範囲へコピーする||
|rotate|要素の並びを回転させる||
|rotate_copy|要素の並びを回転させ、その結果を出力の範囲へコピーする||
|shift_left|要素を左にシフトさせる|C++20|
|shift_right|要素を右にシフトさせる|C++20|
|sample|範囲から指定された個数の要素をランダムに抽出する|C++17|
|random_shuffle|それぞれの要素をランダムな位置に移動させる|C++14から非推奨|
|C++17で削除|
|shuffle|それぞれの要素をランダムな位置に移動させる|C++11|
|is_partitioned|与えられた範囲が条件によって区分化されているか判定する|C++11|
|partition|与えられた範囲を条件によって区分化する||
|stable_partition|与えられた範囲を相対順序を保ちながら条件によって区分化する||
|partition_copy|与えられた範囲を条件によって 2 つの出力の範囲へ分けてコピーする|C++11|
|partition_point|与えられた範囲から条件によって区分化されている位置を得る|C++11|

## ソートや、それに関連した操作
### ソート
|名前|説明|対応バージョン|
|:--|:--|:--|
|sort|範囲を並べ替える||
|stable_sort|範囲を安定ソートで並べ替える||
|partial_sort|範囲を部分的にソートし、先頭N個を並んだ状態にする||
|partial_sort_copy|範囲を部分的にソートした結果を他の範囲にコピーする||
|is_sorted|ソート済みか判定する|C++11|
|is_sorted_until|ソート済みか判定し、ソートされていない位置のイテレータを取得する|C++11|

### N 番目の要素
|名前|説明|対応バージョン|
|:--|:--|:--|
|nth_element|基準となる要素よりも小さい要素が、前に来るよう並べ替える||

### 二分探索
|名前|説明|対応バージョン|
|:--|:--|:--|
|lower_bound|指定された要素以上の値が現れる最初の位置のイテレータを取得する||
|upper_bound|指定された要素より大きい値が現れる最初の位置のイテレータを取得する||
|equal_range|lower_boundとupper_boundの結果を組で取得する||
|binary_search|二分探索法による検索を行う||

### マージ
|名前|説明|対応バージョン|
|:--|:--|:--|
|merge|2つのソート済み範囲をマージする||
|inplace_merge|2つの連続したソート済み範囲をマージする||

### ソート済み構造に対する集合演算
|名前|説明|対応バージョン|
|:--|:--|:--|
|set_union|2つのソート済み範囲の和集合を得る||
|set_intersection|2つのソート済み範囲の積集合を得る||
|set_difference|2つのソート済み範囲の差集合を得る||
|set_symmetric_difference|2つのソート済み範囲の互いに素な集合を得る||
|includes|2つのソート済み範囲において、一方の範囲の要素がもう一方の範囲に全て含まれているかを判定する||

### ヒープ
|名前|説明|対応バージョン|
|:--|:--|:--|
|push_heap|ヒープ化された範囲に要素を追加したヒープ範囲を得る||
|pop_heap|ヒープ化された範囲の先頭と末尾を入れ替え、ヒープ範囲を作り直す||
|make_heap|範囲をヒープ化する||
|sort_heap|ヒープ化された範囲を並べ替える||
|is_heap_until|範囲がヒープ化されているか判定し、ヒープ化されていない最初の要素を指すイテレータを取得する|C++11|
|is_heap|範囲がヒープ化されているか判定する|C++11|

### 最小と最大
|名前|説明|対応バージョン|
|:--|:--|:--|
|min|最小値を取得する||
|max|最大値を取得する||
|minmax|最小値と最大値を取得する|C++11|
|min_element|範囲内の最小要素へのイテレータを取得する||
|max_element|範囲内の最大要素へのイテレータを取得する||
|minmax_element|範囲内の最小要素と最大要素へのイテレータを取得する|C++11|
|clamp|値を範囲内に収める|C++17|

### 辞書式比較
|名前|説明|対応バージョン|
|:--|:--|:--|
|lexicographical_compare|2つの範囲を辞書式順序で比較する||


### 三方比較アルゴリズム
|名前|説明|対応バージョン|
|:--|:--|:--|
|lexicographical_compare_three_way|2つの範囲を辞書式順序で比較する||

### 順列
|名前|説明|対応バージョン|
|:--|:--|:--|
|next_permutation|次の順列を生成する||
|prev_permutation|前の順列を生成する||
|is_permutation|範囲が順列かを判定する|C++11|

## 関連項目
* [<numeric>](https://cpprefjp.github.io/reference/numeric.html)
    * 数値計算のアルゴリズム
