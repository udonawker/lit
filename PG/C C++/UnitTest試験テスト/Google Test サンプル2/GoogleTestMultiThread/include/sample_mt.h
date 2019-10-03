#ifndef _SAMPLE_MT_H_
#define _SAMPLE_MT_H_

#include <chrono>
#include <future>

class SampleMT {
public:
    SampleMT() = default;
    ~SampleMT() = default;
    
    std::future<int> AddMT(std::chrono::seconds dur, int lhs, int rhs);
    
};

#endif // _SAMPLE_H_
