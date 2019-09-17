引用<br/>
[Google Testのアサーションをいろいろ使ってみる](https://s15silvia.blog.so-net.ne.jp/2013-02-23)<br/>

[前回](http://s15silvia.blog.so-net.ne.jp/2013-02-16)に引き続き，Google Testを試してみる．<br/>
Google Testにはいろいろなアサーションが用意されてるので，それを試してみる．<br/>
<br/>
前回と同様に適当なディレクトリにassert_projというディレクトリを作って，ファイル構成は以下のようにしてやる．なお，今回はアサーションのテストだけしかしないので，作成するファイルはCMakeLists.txtとassert_unittest.cppだけだ．<br/>

<pre>
assert_proj/
├── CMakeLists.txt
└── test
    └── assert_unittest.cpp
</pre>

CMakeLists.txt<br/>

<pre>
cmake_minimum_required(VERSION 2.6)
project(assert_test)
enable_testing()
find_package(Threads)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

message(STATUS GTEST_DIR=$ENV{GTEST_DIR})

include_directories($ENV{GTEST_DIR}/include)
link_directories($ENV{GTEST_DIR}/lib)

add_executable(assert_test test/assert_unittest.cpp)
target_link_libraries(assert_test gtest gtest_main)
target_link_libraries(assert_test ${CMAKE_THREAD_LIBS_INIT})
add_test(NAME assert_test COMMAND assert_test)
</pre>

assert_unittest.cpp<br/>

<pre>
#include <gtest/gtest.h>

// message output test
TEST(TestAssert, Message)
{
    bool flag[2] = {true, false};
    for (int i = 0; i < 2; i++) {
        EXPECT_TRUE(flag[i]) << "test failed at index " << i;
    }
}

// bool test
TEST(TestAssert, AssertTrue)
{
    EXPECT_TRUE(true);
    ASSERT_TRUE(true);
}

TEST(TestAssert, AssertFalse)
{
    EXPECT_FALSE(false);
    ASSERT_FALSE(false);
}

// value test
TEST(TestAssert, Value)
{
    int expected = 2;
    int actual = 2;
    EXPECT_EQ(expected, actual);    // expected == actual

    int val1, val2;
    val1 = val2 = 3;
    EXPECT_NE(val1  , val2+1);  // val1 != val2
    EXPECT_LE(val1  , val2  );  // val1 <= val2
    EXPECT_GE(val1  , val2  );  // val1 >= val2
    EXPECT_LT(val1  , val2+1);  // val1 <  val2
    EXPECT_LE(val1  , val2+1);  // val1 <= val2
    EXPECT_GT(val1+1, val2  );  // val1 >  val2
    EXPECT_GE(val1+1, val2  );  // val1 >= val2
}

// class test
class Point
{
    private:
        int x_;
        int y_;
    public:
        Point(int x, int y) : x_(x), y_(y) {}
        bool operator==(const Point& obj) const { return (x_ == obj.x_) && (y_ == obj.y_); }
        bool operator!=(const Point& obj) const { return !(*this == obj); }
};

TEST(TestAssert, Class)
{
    Point a(0, 0);
    Point b(0, 1);

    EXPECT_EQ(a, a);
    EXPECT_NE(a, b);
} 

// c string test
TEST(TestAssert, CStr)
{
    char str1[] = "aaa";
    char str2[] = "aaa";

    EXPECT_NE(str1, str2);
    EXPECT_STREQ(str1, str2);       // "aaa" vs "aaa"

    strcpy(str2, "Aaa");
    EXPECT_STRNE(str1, str2);       // "aaa" vs "Aaa"
    EXPECT_STRCASEEQ(str1, str2);   // "aaa" vs "Aaa"

    strcpy(str2, "bAA");
    EXPECT_STRCASENE(str1, str2);   // "aaa" vs "bAA"
}
</pre>

じゃあビルド．前回と同様，assert_buildディレクトリを作ってビルド．<br/>

<pre>
mkdir assert_build
cd assert_build/
cmake ../assert_proj/
make
</pre>

これで，assert_testバイナリが生成される．<br/>
実行は，<br/>

<pre>
make test ARGS=--output-on-failure
</pre>

でOK．<br/>
ARGS=-Vにすると詳細が表示されるんだけど，テストに失敗したときだけ詳細が表示されればいいんだったら，ARGS=--output-on-failureにするといい．<br/>
ま，テスト成功のときはシンプルな表示で失敗のときにいろいろ表示されるほうが使いやすいかも．<br/>
<br/>
アサーションの説明は，Google Test ドキュメント日本語訳の入門ガイドにあるアサーションあたりを読むと分かると思う．<br/>
<br/>
ま，それだけだと寂しいので，テストの内容をいくつか，ざっくり書いとく．<br/>
<br/>
TEST(TestAssert, Message)<br/>
アサーションに失敗したときにメッセージを出力するもの．<br/>
flagがfalseのときに失敗して，「test failed at index 1」というメッセージが追加で表示される．<br/>
成功のときはメッセージは表示されない．<br/>
<br/>
TEST(TestAssert, Class)<br/>
値の比較をするアサーションは，組み込み型ならそのまま使える．<br/>
もしユーザ定義型でも使いたい場合は，比較演算子を用意してやれば使える．<br/>
今回の場合だと，EXPECT_EQとEXPECT_NEを使うので，==演算子と!=演算子を用意してやればよい．<br/>
<br/>
TEST(TestAssert, CStr)<br/>
C言語文字列を比較したいときは，EXPECT_EQではなく，EXPECT_STREQを使う．<br/>
EXPECT_EQだとポインタの比較になってしまい文字列そのものの比較にならない．<br/>
<br/>
とりあえず今回はここまで．<br/>
お試しあれ．<br/>
