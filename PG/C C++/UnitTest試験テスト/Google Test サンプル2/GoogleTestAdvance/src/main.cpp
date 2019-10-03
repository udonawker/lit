#include "sample.h"
#include <iostream>
#include <sstream>

int main(int argc, char* argv[])
{
    for (int i = 0; i < argc; i++) {
        std::istringstream iss(argv[i]);
        int num = 0;
        iss >> num;
        Sample sample;
        
        std::cout << argv[i] << "は素数? : " << std::boolalpha << sample.IsPrime(num);
    }
    
    return 0;
}
