#include "gtest/gtest.h"
#include "sample_mt.h"

namespace {

// AddMT を行う Sample をテストします．
TEST(SampleMTTest, AddMT) {
    auto begin = std::chrono::system_clock::now();
    std::chrono::seconds sec(5);
    
    SampleMT sample;
    auto future = sample.AddMT(sec, 2, 3);
    int result = future.get();
    
    auto end = std::chrono::system_clock::now();
    auto diff = end - begin;
    
    ASSERT_EQ(5, result);
    ASSERT_EQ(sec.count(), std::chrono::duration_cast<std::chrono::seconds>(diff).count());
}

}  // namespace
