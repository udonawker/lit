#include "gtest/gtest.h"
#include "sample.h"

namespace {

// テスト対象となるクラス Sample のためのフィクスチャ
class SampleFixtureTest : public ::testing::Test
{
protected:
    // テストケース毎の set-up．
    // このテストケースの最初のテストよりも前に呼び出されます．
    static void SetUpTestCase() {
        //std::cout << "[Debug] SampleFixtureTest::SetUpTestCase()" << std::endl;
    }

    // テストケース毎の tear-down．
    // このテストケースの最後のテストの後で呼び出されます．
    static void TearDownTestCase() {
        //std::cout << "[Debug] SampleFixtureTest::TearDownTestCase()" << std::endl;
    }

    // テスト毎に実行される set-up をここに書きます
    SampleFixtureTest()
    : m_addResult1(3)
    , m_addResult2(4)
    , m_getStringResult("Sample")
    {
        //std::cout << "[Debug] SampleFixtureTest::SampleFixtureTest()" << std::endl;
    }

    // テスト毎に実行される，例外を投げない clean-up をここに書きます．
    virtual ~SampleFixtureTest() {
        //std::cout << "[Debug] SampleFixtureTest::~SampleFixtureTest()" << std::endl;
    }

    // このコードは，コンストラクタの直後（各テストの直前）に呼び出されます．
    virtual void SetUp() {
        //std::cout << "[Debug] SampleFixtureTest::SetUp()" << std::endl;
    }

    // このコードは，各テストの直後（デストラクタの直前）に呼び出されます．
    virtual void TearDown() {
        //std::cout << "[Debug] SampleFixtureTest::TearDown()" << std::endl;
    }

    // 高コストのリソースが，全てのテストで共有されます．
    //static int xxx;

    // ここで宣言されるオブジェクトは，テストケース内の全てのテストで利用できます．
    int m_addResult1;
    int m_addResult2;
    std::string m_getStringResult;
};

// Add を行う Sample をテストします．
TEST_F(SampleFixtureTest, Add) {
    Sample sample;
    ASSERT_EQ(m_addResult1, sample.Add(1, 2));
    ASSERT_EQ(m_addResult2, sample.Add(2, 2));
}

// GetString を行う Sample をテストします．
TEST_F(SampleFixtureTest, GetString) {
    Sample sample;
    ASSERT_EQ(m_getStringResult, sample.GetString());
}

// True False を行う Sample をテストします．
TEST_F(SampleFixtureTest, True_False) {
    Sample sample;
    ASSERT_TRUE(sample.True());
    ASSERT_FALSE(sample.False());

    // ユーザ定義の失敗メッセージを出力するには，単に<<演算子を用いて，そのメッセージをストリームに出力するだけです．
    //ASSERT_FALSE(sample.True()) << "[Debug] SampleFixtureTest True Failed";
}

}  // namespace
