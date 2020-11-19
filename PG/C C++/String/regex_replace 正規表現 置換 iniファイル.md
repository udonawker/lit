<pre>
#include &lt;iostream&gt;
#include &lt;iterator&gt;
#include &lt;regex&gt;
#include &lt;string&gt;
int main()
{
    std::stringstream ss;
    ss << "aaa=0.1";
    std::cout << std::regex_replace( ss.str(), std::regex("(aaa=)(.+)"), "$012", std::regex_constants::format_first_only ) << std::endl;
    std::cout << std::regex_replace( ss.str(), std::regex("(aaa=)(.+)"), "$0112345", std::regex_constants::format_first_only ) << std::endl;
    std::cout << std::regex_replace( ss.str(), std::regex("(aaa=)(.+)"), "$1112345", std::regex_constants::format_first_only ) << std::endl;
    std::cout << std::regex_replace( ss.str(), std::regex("(aaa=)(.+)"), "$0", std::regex_constants::format_first_only ) << std::endl;
    std::cout << std::regex_replace( ss.str(), std::regex("(aaa=)(.+)"), "$1", std::regex_constants::format_first_only ) << std::endl;
    std::cout << std::regex_replace( ss.str(), std::regex("(aaa=)(.+)"), "$2", std::regex_constants::format_first_only ) << std::endl;
    return 0;
}
/*
aaa=2
aaa=12345
12345
aaa=0.1
aaa=
0.1
*/
</pre>
