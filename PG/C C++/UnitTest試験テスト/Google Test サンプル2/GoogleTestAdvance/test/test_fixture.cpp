#include "gtest/gtest.h"
#include "sample.h"

#include <tuple>

namespace {//}

// ASSERT_PRED ASSERT_PRED_FORMAT確認
class SamplePredTest : public ::testing::Test
{
protected:
    static void SetUpTestCase() {}
    static void TearDownTestCase() {}

    SamplePredTest() {}
    virtual ~SamplePredTest() {}
    virtual void SetUp() {}
    virtual void TearDown() {}
    
    struct AssertPredHelper : public std::unary_function <int, bool> {
        explicit AssertPredHelper(Sample& sample) : m_sample(sample) {}
        bool operator()(int num) { return m_sample.IsPrime(num); }
        Sample& m_sample;
    };
    
    ::testing::AssertionResult IsPrime(int num) {
        Sample sample;
        
        if (sample.IsPrime(num)) {
            return ::testing::AssertionSuccess();
        }
        
        return ::testing::AssertionFailure() << "\"" << num << "\"" << " は素数ではない";
    }
    
    ::testing::AssertionResult IsPrimeF(const char* expr1, int val1) {
        Sample sample;
        
        if (sample.IsPrime(val1)) {
            return ::testing::AssertionSuccess();
        }
        
        ::testing::Message msg;
         msg << "\"" << expr1 << "\" の値は \"" << val1 << "\"" << " 素数ではない";
        return ::testing::AssertionFailure(msg);
    }
/*
// 2つの整数が互いに素かを調べるアサーション用の述語フォーマッタ．
::testing::AssertionResult AssertMutuallyPrime(const char* m_expr,
                                               const char* n_expr,
                                               int m,
                                               int n)
*/
};

// ASSERT_PRED1
TEST_F(SamplePredTest, IsPrimePred) {
    Sample sample;
    
    int num = 1; // ⇒ Failed
    // ASSERT_PRED1([&sample](int num) { return sample.IsPrime(num); }, num); compile error
    
    ASSERT_PRED1(AssertPredHelper(sample), num);
}

// AssertionResult 
TEST_F(SamplePredTest, IsPrimeAssertionResult) {
    int num = 1; // ⇒ Failed
    EXPECT_TRUE(IsPrime(num));
}

// ASSERT_PRED_FORMAT1
TEST_F(SamplePredTest, IsPrimePredFormat) {
    int num = 4; // ⇒ Failed
    ASSERT_PRED_FORMAT1(IsPrimeF, num);
}

// 値をパラメータ化したテスト                                                                                    // ↓パラメータの型
class SamplePredParameterTest : public SamplePredTest, public ::testing::WithParamInterface<int> {
public:
    static void SetUpTestCase() {}
    static void TearDownTestCase() {}
    // SamplePredTest::SetUpTestCase(),SamplePredTest::TearDownTestCase()を削除するか
    // public SamplePredParameterTest::SetUpTestCase() SamplePredParameterTes::TearDownTestCase()を定義するかしないとコンパイルエラーになる
    // protected SamplePredParameterTest::SetUpTestCase() ... でもダメ
};

INSTANTIATE_TEST_CASE_P(
    ParameterTest,
    SamplePredParameterTest,
    ::testing::Values(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
);
TEST_P(SamplePredParameterTest, ParameterTest){
    EXPECT_TRUE(IsPrime(GetParam()));
}


// 値をパラメータ化したテスト 複数要素を持つパラメータ
// 参照[gtest] 複数要素を持つパラメータでテストを書く(https://srz-zumix.blogspot.com/2014/10/gtest.html)
class SampleMultiParameterTest : public ::testing::TestWithParam<std::tuple<int, int, int>> {};

INSTANTIATE_TEST_CASE_P(
    MultiParameterTest,
    SampleMultiParameterTest,
    ::testing::Values(
        std::make_tuple(1, 1, 2),
        std::make_tuple(1, 2, 3),
        std::make_tuple(2, 3, 5),
        std::make_tuple(128, 256, 384),
        std::make_tuple(128, 256, 0)
    )
);

TEST_P(SampleMultiParameterTest, MultiParameterTest)
{
    Sample sample;
    std::tuple<int, int, int> param = GetParam();
    ASSERT_EQ(std::get<2>(param), sample.Add(std::get<0>(param), std::get<1>(param)));
}

}  // namespace
