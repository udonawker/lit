引用<br/>
[gtestでパラメータライズテスト](https://gist.github.com/datsuns/2868831)<br/>

<pre>
#include &lt;gtest/gtest.h&gt;

class Hello {
    public:
        int ping( int a ){ return a; }
};

class HelloTest : public ::testing::TestWithParam<int> {
    protected:
        Hello hello;
};

TEST_P( HelloTest, hello ){
    EXPECT_TRUE( hello.ping(GetParam()) );
}

INSTANTIATE_TEST_CASE_P( TestCaseP, HelloTest, ::testing::Values( 1, 2, 0 ) );
</pre>
