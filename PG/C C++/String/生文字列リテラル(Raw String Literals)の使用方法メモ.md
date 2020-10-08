## [生文字列リテラル(Raw String Literals)の使用方法メモ](https://qiita.com/koara-local/items/6500ff525684110a5abc)

test_raw_literals.cpp<br>
<pre>
#include &lt;cstdio&gt;

static const char* raw_string_literals1 = R"(hoge)";
static const char* raw_string_literals2 = R"("foo", "bar")";
static const char* raw_string_literals3 = R"({
    "object" : {
        "foo" : 1,
        "bar" : "hoge"
    }
})";
static const char* raw_string_literals4 = R"*("(cdr '(1 2 3 4))" => "(2 3 4)")*";

int main(int argc, char const* argv[])
{
    puts("case 1: 通常ケース");
    puts(raw_string_literals1);
    puts("case 2: ダブルコーテーションを含むケース");
    puts(raw_string_literals2);
    puts("case 3: 改行を含むケース");
    puts(raw_string_literals3);
    puts("case 4: 丸括弧とダブルコーテーションが隣接する文字があるケース");
    puts(raw_string_literals4);
    return 0;
}
</pre>

ビルドと実行結果<br>
<pre>
$ g++ -std=c++11 test_raw_literals.cpp && ./a.out
case 1: 通常ケース
hoge
case 2: ダブルコーテーションを含むケース
"foo", "bar"
case 3: 改行を含むケース
{
    "object" : {
        "foo" : 1,
        "bar" : "hoge"
    }
}
case 4: 丸括弧とダブルコーテーションが隣接する文字があるケース
"(cdr '(1 2 3 4))" => "(2 3 4)"
</pre>
