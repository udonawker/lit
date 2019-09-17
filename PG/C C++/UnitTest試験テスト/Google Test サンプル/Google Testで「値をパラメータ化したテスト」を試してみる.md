引用<br/>
[Google Testで「値をパラメータ化したテスト」を試してみる](https://s15silvia.blog.so-net.ne.jp/2013-05-12)<br/>

Google Testでは値をいろいろと変えてテストをしたいときのために，「値をパラメータ化したテスト」というのが用意されている．<br/>
詳細は，いつもの通りドキュメントを参照してほしいんだけど，要は値を変えてテストするときに自分でいちいち値ごとにテストをコピーしたりしなくても，たとえば値の組み合わせを用意してやれば，Google Testがそれにあわせて値を変えながらテストしてくれるという仕組みがあるということだ．<br/>
<br/>
では，具体的にやってみよう．<br/>
例によってディレクトリ構成．<br/>

<pre>
gtest_advanced_param_proj/
├── CMakeLists.txt
├── compiler_settings.cmake
└── test
    └── advanced_unittest.cpp
</pre>

compiler_settings.cmakeは以前から変更が無いので省略して，それ以外は以下のようになる．<br/>
<br/>
CMakeLists.txt<br/>

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
#include <tr1/tuple>
#include <iostream>


bool IsEven(int n)
{
    return (n % 2) == 0;
}

class ParamTestInt : public ::testing::TestWithParam<int>
{};

TEST_P(ParamTestInt, IsEvenTest)
{
    EXPECT_TRUE(IsEven(GetParam()));
}

INSTANTIATE_TEST_CASE_P(
    TestDataIntRange,
    ParamTestInt,
    ::testing::Range(0, 10, 2));

INSTANTIATE_TEST_CASE_P(
    TestDataIntValues,
    ParamTestInt,
    ::testing::Values(0, 2, 4, 6, 8));

class ParamTestTuple : public ::testing::TestWithParam<
    std::tr1::tuple<int, bool> >
{};

TEST_P(ParamTestTuple, IsEvenTest)
{
    const int n = std::tr1::get<0>(GetParam());
    const bool expected = std::tr1::get<1>(GetParam());

    EXPECT_EQ(expected, IsEven(n));
}

INSTANTIATE_TEST_CASE_P(
    TestDataTuple,
    ParamTestTuple,
    ::testing::Values(
        std::tr1::make_tuple( 1,   false),
        std::tr1::make_tuple( 2,   true),
        std::tr1::make_tuple( 3,   false),
        std::tr1::make_tuple( 0,   true),
        std::tr1::make_tuple( 100, true)
    )
);

std::tr1::tuple<int, bool> TestDataArray[] = {
    std::tr1::make_tuple(11,   false),
    std::tr1::make_tuple(12,   true),
};

INSTANTIATE_TEST_CASE_P(
    TestDataTuple2,
    ParamTestTuple,
    ::testing::ValuesIn(TestDataArray)
);

struct TestData {
    int n;
    bool expected;
} test_data[] = {
    { 21, false, },
    { 22, true,  },
};

class ParamTestStruct : public ::testing::TestWithParam<TestData>
{};

TEST_P(ParamTestStruct, IsEvenTest)
{
    const int n = GetParam().n;
    const bool expected = GetParam().expected;

    EXPECT_EQ(expected, IsEven(n));
}

INSTANTIATE_TEST_CASE_P(
    TestDataSturct,
    ParamTestStruct,
    ::testing::ValuesIn(test_data)
);

int mul(int x, int y)
{
    return x * y;
}

class ParamTestCombine : public ::testing::TestWithParam< ::std::tr1::tuple<int, int> >
{};

TEST_P(ParamTestCombine, MulTest)
{
    int x = std::tr1::get<0>(GetParam());
    int y = std::tr1::get<1>(GetParam());
    std::cout << x << " * " << y << " = " << mul(x, y) << std::endl;
    EXPECT_EQ(x * y, mul(x, y));
}

INSTANTIATE_TEST_CASE_P(
        TestDataCombine, 
        ParamTestCombine,
        ::testing::Combine(::testing::Range(1,10),
                           ::testing::Range(1,10))
);
</pre>

CMakeLists.txtは特に変わったことはしていないので，test/advanced_unittest.cppだけ説明しよう．<br/>
では，上の方から順番に．．．<br/>
まず，IsEven()というのがテスト対象で，これについて引数をいくつか値を変えてテストしたいとする．<br/>
例えば，0以上10未満かつ2刻みの値を使ってテストしたいとする．<br/>
で，値をパラメータ化したテストなので，フィクスチャクラスとして，::testing::TestWithParam<T>から派生させたParamTestIntクラスを定義してやる必要がある．<br/>
今はint型の値をパラメータ化したテストをしたいのでTはintだ．<br/>
そしたらTEST_Pを使って，テストを定義してやる．<br/>
普段TEST_Fでやってるように定義すればいい．<br/>
で，ここでGetParam()ってのを呼び出すと，テストパラメータを呼び出せるようになる．<br/>
じゃあテストパラメータってどう定義するのかってことなんだけど，INSTANTIATE_TEST_CASE_Pってのを使う．<br/>
引数は，順に，インスタンス化するときの名前，フィクスチャクラス名，そしてテストパラメータだ．<br/>
上記の例で言えば，TestDataIntRangeという名前でテストをインスタンス化し，そのときのテストフィクスチャクラスはParamTestIntで，パラメータは，::testing::Range(0, 10, 2)だ．<br/>
ここで，::testing::Range(0, 10, 2)ってのはGoogle Testが用意してくれてる便利なやつで，0以上10未満step2を意味する．<br/>
つまり，0,2,4,6,8がテストパラメータとなる．<br/>
で，TEST_P内のGetParam()ではこの値が取得できるという訳だ．<br/>
要するに，ここまでの記述で，IsEven()に対して引数が0,2,4,6,8の場合のテストができるということになる．<br/>
楽ちん．<br/>
<br/>
なお，パラメータは::testing::Range()以外にもいろいろあって，たとえば::testing::Values(0, 2, 4, 6, 8)というのも使える．<br/>
こっちはまさに0,2,4,6,8をパラメータとして使うって言う場合の書き方だ．<br/>
他にもいくつかあるけど，それはまずはドキュメントを参照してくださいな．<br/>
