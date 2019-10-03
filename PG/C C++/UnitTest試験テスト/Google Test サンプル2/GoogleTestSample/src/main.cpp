#include "sample.h"
#include <iostream>

int main(int argc, char* argv[])
{
    Sample sample;
    std::cout << "sample::Add(1, 2)   : " << sample.Add(1, 2) << std::endl;
    std::cout << "sample::GetString() : " << sample.GetString() << std::endl;
    std::cout << "sample::True()      : " << std::boolalpha << sample.True() << std::endl;
    std::cout << "sample::False()     : " << std::boolalpha << sample.False() << std::endl;
    return 0;
}
