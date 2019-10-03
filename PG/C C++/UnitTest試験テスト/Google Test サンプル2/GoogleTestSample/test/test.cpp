#include "gtest/gtest.h"
#include "sample.h"

namespace {

// Add を行う Sample をテストします．
TEST(SampleTest, Add) {
    Sample sample;
    ASSERT_EQ(3, sample.Add(1, 2));
    ASSERT_EQ(4, sample.Add(2, 2));
}

// GetString を行う Sample をテストします．
TEST(SampleTest, GetString) {
    Sample sample;
    ASSERT_EQ("Sample", sample.GetString());
}

// True_False を行う Sample をテストします．
TEST(SampleTest, True_False) {
    Sample sample;
    ASSERT_TRUE(sample.True());
    ASSERT_FALSE(sample.False());
}

}  // namespace
