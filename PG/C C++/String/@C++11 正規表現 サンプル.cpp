#include <iostream>
#include <regex>
#include <string>

// g++ -std=c++11 -o regex_test regex_test.cpp
int main(int argc, char* argv[]) {
    const std::string patterns[3]{"* abcd.aabbcc = 12345", "* abcd. = 12345", "* abcd.xxyyzz[123] = "};
    //const std::regex  re(R"(^\* abcd\.(\w+) = (\d+)$)");
    const std::regex  re(R"(^\* abcd\.([a-zA-Z0-9\[\]]+) = (\d*)$)");
    for (const auto& s : patterns) {
        std::smatch       results;
        std::cout << "pattern --------" << s << "--------" << std::endl;
        if (std::regex_match(s, results, re)) {
            std::cout << "smatch.size() = " << results.size() << std::endl;
            for (auto i = 0; i < results.size(); i++) {
                std::cout << results[i].str() << " : " << results[i].length() <<  std::endl;
            }
        }
        std::cout << std::string(16, '-') << std::endl;
    }
}
/*
pattern --------* abcd.aabbcc = 12345--------
smatch.size() = 3
* abcd.aabbcc = 12345 : 21
aabbcc : 6
12345 : 5
----------------
pattern --------* abcd. = 12345--------
----------------
pattern --------* abcd.xxyyzz[123] = --------
smatch.size() = 3
* abcd.xxyyzz[123] =  : 21
xxyyzz[123] : 11
 : 0
----------------
*/
