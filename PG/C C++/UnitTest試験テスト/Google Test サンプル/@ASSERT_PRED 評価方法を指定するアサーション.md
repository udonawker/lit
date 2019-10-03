引用 [アサーションの解説（２）](https://blog.emattsan.org/entry/20091022/1256208978)<br/>

## 評価方法を指定するアサーション

たとえば、次のように偶数か否かを評価する関数（述語関数）があり、その関数を使って値が偶数か否かテストする場合を考えます。<br/>

<pre>
bool isEven(int n)
{
    return (n % 2) == 0;
}

TEST(MyPredTest, Test1)
{
    int n = 1;
    ASSERT_TRUE(isEven(n));
}
</pre>


実行結果。<br/>

<pre>
[==========] Running 1 test from 1 test case.
[----------] Global test environment set-up.
[----------] 1 test from MyPredTest
[ RUN      ] MyPredTest.Test1
test8.cpp:11: Failure
Value of: isEven(n)
  Actual: false
Expected: true
[  FAILED  ] MyPredTest.Test1
[----------] Global test environment tear-down
[==========] 1 test from 1 test case ran.
[  PASSED  ] 0 tests.
[  FAILED  ] 1 test, listed below:
[  FAILED  ] MyPredTest.Test1
</pre>

このとき、関数が偽を返し、**テストが失敗したことはわかりますが、評価された値（ここではnの値）はわかりません**。<br/>
このような場合のために、評価する値と一緒に述語関数を与えることができるマクロ`ASSERT_PREDn`、`EXCEPT_PREDn`が用意されています。`n`には評価する値の個数が入り、現時点では１〜５まで用意されています。<このような場合のために、評価する値と一緒に述語関数を与えることができるマクロASSERT_PREDn、EXCEPT_PREDnが用意されています。nには評価する値の個数が入り、現時点では１〜５まで用意されています。<br/>


|Fatal assertion|Nonfatal assertion|Verifies|
|--- |--- |--- |
|ASSERT_PRED1(pred1, val1)|EXPECT_PRED1(pred1, val1)|pred1(val1) returns true|
|ASSERT_PRED2(pred2, val1, val2)|EXPECT_PRED2(pred2, val1, val2)|pred2(val1, val2) returns true|
|...|...|...|

<pre>
bool isEven(int n)
{
    return (n % 2) == 0;
}

TEST(MyPredTest, Test2)
{
    int n = 1;
    ASSERT_PRED1(isEven, n); // 第一引数に述語関数を、第二引数以降に評価される値を記述
}
</pre>

実行結果。<br/>

<pre>
[==========] Running 1 test from 1 test case.
[----------] Global test environment set-up.
[----------] 1 test from MyPredTest
[ RUN      ] MyPredTest.Test2
test8.cpp:17: Failure
isEven(n) evaluates to false, where
n evaluates to 1
[  FAILED  ] MyPredTest.Test2
[----------] Global test environment tear-down
[==========] 1 test from 1 test case ran.
[  PASSED  ] 0 tests.
[  FAILED  ] 1 test, listed below:
[  FAILED  ] MyPredTest.Test2
</pre>

さらにテスト結果の表示も指定したい場合のためにASSET_PRED_FORMATn、EXCEPT_PRED_FORMATnが用意されています。<br/>
同様にnには評価する値の個数が入り、現時点では１〜５まで用意されています。<br/>

|Fatal assertion|Nonfatal assertion|Verifies|
|ASSERT_PRED_FORMAT1(pred_format1, val1)|EXPECT_PRED_FORMAT1(pred_format1, val1)|pred_format1(val1) is successful|
|ASSERT_PRED_FORMAT2(pred_format2, val1, val2)|EXPECT_PRED_FORMAT2(pred_format2, val1, val2)|pred_format2(val1, val2) is successful|
|...|...|...|

これらのマクロに与える述語関数は、n個の文字列とn個の値を引数に取り、`::testing::AssertionResult`を返す関数にします。<br/>

<pre>
::testing::AssertionResult PredicateFormattern(const char* expr1, const char* expr2, ...
const char* exprn, T1 val1, T2 val2, ... Tn valn);
</pre>

ここで文字列（`expr1`, `expr2`, ...）には、マクロに与えた式そのままが文字列として格納され、値（`val1`, `val2`, ...）には、マクロに与えられた式の値が格納されます。<br/>

評価が成功だった場合には、`::testing::AssertionSuccess()`の戻り値を返します。<br/>
評価が失敗だった場合には、`::testing::AssertionFailure(const ::testing::Message& msg)`の戻り値を返します。ここで`msg`は失敗時に出力される文字列で、下記の例のように挿入演算子`operator <<`を使ってメッセージを構築することができます。<br/>

<pre>
::testing::AssertionResult isEvenF(const char* expr1, int val1)
{
    if((val1 % 2) == 0)
    {
        return ::testing::AssertionSuccess();
    }

    ::testing::Message msg;
    msg << "\"" << expr1 << "\" の値は \"" << val1 << "\" だった。これは偶数じゃない！";
    return ::testing::AssertionFailure(msg);
}

TEST(MyPredTest, Test3)
{
    int n = 1;
    ASSERT_PRED_FORMAT1(isEvenF, n);
}
</pre>

実行結果。

<pre>
[==========] Running 1 test from 1 test case.
[----------] Global test environment set-up.
[----------] 1 test from MyPredTest
[ RUN      ] MyPredTest.Test3
test8.cpp:35: Failure
"n" の値は "1" だった。これは偶数じゃない！
[  FAILED  ] MyPredTest.Test3
[----------] Global test environment tear-down
[==========] 1 test from 1 test case ran.
[  PASSED  ] 0 tests.
[  FAILED  ] 1 test, listed below:
[  FAILED  ] MyPredTest.Test3
</pre>
