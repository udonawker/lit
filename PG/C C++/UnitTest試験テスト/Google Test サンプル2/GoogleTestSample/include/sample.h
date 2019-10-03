#ifndef _SAMPLE_H_
#define _SAMPLE_H_

#include <string>

class Sample {
public:
    int Add(int lhs, int rhs) const;
    std::string GetString() const;
    bool True() const;
    bool False() const;
    
};

#endif // _SAMPLE_H_
