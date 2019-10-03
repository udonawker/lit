#include "sample_mt.h"

#include <thread>

std::future<int> SampleMT::AddMT(std::chrono::seconds duration, int lhs, int rhs)
{
    std::promise<int> promise;
    std::future<int> future = promise.get_future();
    std::thread(
        [](std::promise<int>&& p, std::chrono::seconds duration, int lhs, int rhs) {
            std::this_thread::sleep_for(duration);
            p.set_value(lhs + rhs);
        },
        std::move(promise),
        duration,
        lhs,
        rhs
    ).detach();
    
    return future;
}
