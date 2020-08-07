# [【C++】配列から条件に合う値をfilterするいい方法は「小さいテンプレートメソッドを自作する」です](https://qiita.com/hirocueki2/items/5beac936c1db8ac4d397)

## テンプレート関数をうまく利用したfilterを自作
コンテナと条件は引数で指定する形で、このメソッドひとつ定義しておけばコンテナの型はなんでもいいので汎用性が高いです。<br>

<pre>
template &lt;typename Cont, typename Pred&gt;
Cont filter(const Cont &container, Pred predicate) {
    Cont result;
    std::copy_if(container.begin(), container.end(), std::back_inserter(result), predicate);
    return result;
}
</pre>

## つかいかた：サンプルコード

<pre>
#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;algorithm&gt;

template <typename Cont, typename Pred>
Cont filter(const Cont &container, Pred predicate) {
    Cont result;
    std::copy_if(container.begin(), container.end(), std::back_inserter(result), predicate);
    return result;
}

int main()
{
  // --------------------------
  // 「整数配列から偶数のみを取る」
  std::vector<int> numbers{ 1, 2, 3, 4, 5, 6 };
  const auto odd = filter(numbers, [](int a) { return a % 2 == 0; });

  for (auto& n : odd) {
    std::cout << n << std::endl;
    // 2, 4, 6
  }

  // --------------------------
  // 「どのビットが立っているかを調べる」
  const unsigned long expect_value = 0x23;
  std::vector<unsigned long> bits = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20 };

  const auto matched_bits = filter(flags, [](unsigned long bit) { return expect_value & bit; });

  for (auto& v : matched_bits) {
    std::cout << std::hex << v << std::endl;
    // 1, 2, 20 (hex表記)
  }

  // --------------------------
  // 「30歳以上の名前を集める」
  struct Person
  {
    std::string Name = "";
    int Age = 0;
  };
  std::vector<Person> people = {
    { "ueki", 35 },
    { "yamada", 20 },
    { "suzuki", 50 },
    { "saito", 19 },
  };
  const auto people_30_plus = filter(people, [](Person person) { return person.Age > 30; });

  for (auto& person : people_30_plus) {
    std::cout << person.Name.c_str() << std::endl;
    // "ueki", "suzuki"
  }
}
</pre>

## まとめ
- 汎用性のあるテンプレートメソッドがあると、たくさんのメソッドをつくらずに済む
- 「forループで回して値をチェック」より説明的でコードリーディングのとき脳への負担が軽い
- 他のロジック（map,redudce）にも応用ができる
