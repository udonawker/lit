#include "sample.h"

#include <math.h>

int Sample::Add(int lhs, int rhs) const
{
    return lhs + rhs;
}

bool Sample::IsPrime(int num) const
{
    if (num < 2) {
        return false;
    } else if(num == 2) {
        return true;
    } else if(num % 2 == 0) {
        // 偶数はあらかじめ除く
        return false;
    }

    int sqrtNum = static_cast<int>(sqrt(num));
    for (int i = 3; i <= sqrtNum; i += 2) {
        if (num % i == 0) {
            // 素数ではない
            return false;
        }
    }

    // 素数である
    return true;
}
