引用<br/>
[Google Testの上級ガイドにある「その他のアサーション」を試してみる](https://s15silvia.blog.so-net.ne.jp/2013-04-14)<br/>
<br/>

Google Testには本当にいろいろなアサーションが用意されている．<br/>
詳細は，[「上級ガイド — Google Test ドキュメント日本語訳」](http://opencv.jp/googletestdocs/advancedguide.html#adv-etaaching-gtest-how-to-print-your-values)に記載されてるので，そっちを参照してもらうとして，とりあえずその上級ガイドにある，「その他のアサーション」についていくつか試してみた．<br/>
<br/>
で，詳細を説明しようと思ったけど，まぁ上級ガイドに書かれてることを試そうなんて人は，上記のドキュメントを読めば内容は理解できると思うので，とりあえず試したコードとメモ程度の内容だけ示しておくにとどめとく．ってまぁ説明するのが面倒なのと，実際のところ説明って言っても結局ドキュメントに書かれてることそのままになっちゃうからなんだけど．<br/>
<br/>
というわけで，まずはディレクトリ構成．まぁいつもと同じなんだけど．．．<br/>

<pre>
gtest_advanced_proj/
├── CMakeLists.txt
├── compiler_settings.cmake
└── test
    └── advanced_unittest.cpp
</pre>

compiler_settings.cmakeは以前から変更が無いので省略して，それ以外のファイルを示すと，<br/>
<br/>
CMakeLists.txt．<br/>

<pre>
cmake_minimum_required(VERSION 2.6)
project(gtest_advanced_test)

include (compiler_settings.cmake)

enable_testing()
set(CMAKE_INCLUDE_CURRENT_DIR ON)
message(STATUS GTEST_DIR=$ENV{GTEST_DIR})

include_directories($ENV{GTEST_DIR}/include)
link_directories($ENV{GTEST_DIR}/lib)

cxx_test(gtest_advanced_test "" test/advanced_unittest.cpp)
</pre>

test/advanced_unittest.cpp<br/>

<pre>
#include <gtest/gtest.h>

TEST(AdvancedTest, Succeed)
{
    SUCCEED();
}

TEST(AdvancedTest, Fail)
{
    FAIL() << "FAIL() is always fail.";   // 常に失敗
}

bool do_something(int x, int y)
{
    return x == y;
}

TEST(AdvancedTest, Predicate)
{
    int a = 3;
    int b = 5;
    EXPECT_PRED2(do_something, a, b);
    EXPECT_TRUE(do_something(a, b));
}

namespace testing {
AssertionResult AssertionSuccess();
AssertionResult AssertionFailure();
}

::testing::AssertionResult IsEven(int n)
{
    if ((n % 2) == 0) {
        return ::testing::AssertionSuccess();
    } else {
        return ::testing::AssertionFailure() << n << " is odd";
    }
}

bool IsEvenSimple(int n)
{
    return (n % 2) == 0;
}

int add(int x, int y)
{
    return x + y;
}

TEST(AdvancedTest, AssertionResult)
{
    EXPECT_TRUE(IsEven(add(3, 2)));
    EXPECT_TRUE(IsEvenSimple(add(3, 2)));
}

::testing::AssertionResult AssertDoSomething(const char* m_expr,
                                             const char* n_expr,
                                             int m,
                                             int n)
{
    if (do_something(m, n)) {
        return ::testing::AssertionSuccess();
    } else {
        return ::testing::AssertionFailure()
            << m_expr << " and " << n_expr << " ( " << m << " and " << n << ")"
            << " are not same.";
    }
}

TEST(AdvancedTest, PredicateFormat)
{
    int a = 5;
    int b = 8;
    EXPECT_PRED_FORMAT2(AssertDoSomething, a, b);
}

TEST(AdvancedTest, Float)
{
    float x = 0.1;
    float y = 0.01;
    EXPECT_EQ(x, y * 10) << "using EXPECT_EQ()";
    EXPECT_FLOAT_EQ(x, y * 10) << "using EXPECT_FLOAT_EQ()";
}

template <typename T> class Foo {
    public:
        void Bar() {
            ::testing::StaticAssertTypeEq<int, T>();
        }
};

void Test1()
{
    // 以下は::testing::StaticAssertTypeEqによりコンパイルエラーを発生させてくれる
    // コンパイルできなくなり，他のテストを試せなくなるのでコメントアウト
    /*
     * Foo<bool> foo;
     * foo.Bar();
     */
}
</pre>

で，内容だけど，前半は主にテスト結果をいかに分かりやすくするかって感じのいろいろな機能で，エラーのときの表示を指定する方法なんかが書かれてる．<br/>
これらは分かりやすいテストを書くには必要だし，あると便利なんだろうけど，まぁ面倒であまり使わない気もする．．．<br/>
あとは浮動小数点のテストと型の一致テストがちょろっと書かれてる．こっちはそこそこ使うかも．<br/>
