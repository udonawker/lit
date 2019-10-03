引用
[C++で文字列を数値に変換する方法](https://nekko1119.hatenablog.com/entry/2013/08/17/144722) <br/>

## atoi

<pre>
#include &lt;cstdlib>
#include &lt;iostream>
#include &lt;string>
#include &lt;typeinfo>

int main()
{
    const std::string str("123");
    auto num = std::atoi(str.c_str());
    std::cout << typeid(num).name() << " : " << num << std::endl;
}
</pre>

## strtol

<pre>
#include &lt;cstdlib>
#include &lt;iostream>
#include &lt;string>
#include &lt;typeinfo>

int main()
{
    const std::string str("123");
    char* e = nullptr;
    auto num = std::strtol(str.c_str(), &e, 10);
    std::cout << typeid(num).name() << " : " << num << std::endl;
}
</pre>

## sscanf

<pre>
#include &lt;cstdio>
#include &lt;iostream>
#include &lt;string>
#include &lt;typeinfo>

int main()
{
    const std::string str("123");
    int num = 0;
    sscanf(str.c_str(), "%d", &num);
    std::cout << typeid(num).name() << " : " << num << std::endl;
}
</pre>

## stoi

<pre>
#include &lt;iostream>
#include &lt;string>
#include &lt;typeinfo>

int main()
{
    const std::string str("123");
    int num = std::stoi(str);
    std::cout << typeid(num).name() << " : " << num << std::endl;
}
</pre>

## istringstream

<pre>
#include &lt;iostream>
#include &lt;sstream>
#include &lt;string>
#include &lt;typeinfo>

int main()
{
    const std::string str("123");
    std::istringstream iss(str);
    int num = 0;
    iss >> num;
    std::cout << typeid(num).name() << " : " << num << std::endl;
}
</pre>

## boost::lexical_cast

<pre>
#include &lt;boost/lexical_cast.hpp>
#include &lt;iostream>
#include &lt;string>
#include &lt;typeinfo>

int main()
{
    const std::string str("123");
    auto num = boost::lexical_cast<int>(str);
    std::cout << typeid(num).name() << " : " << num << std::endl;
}
</pre>

## boost::spirit::qi

<pre>
#include &lt;boost/spirit/include/qi.hpp&gt;
#include &lt;iostream&gt;
#include &lt;string&gt;
#include &lt;typeinfo&gt;

int main()
{
    const std::string str("123");
    int num = 0;
    boost::spirit::qi::parse(str.begin(), str.end(), boost::spirit::qi::int_, num);
    std::cout << typeid(num).name() << " : " << num << std::endl;
}
</pre>

## coerce

Boost.Coerceはまだ正式にBoost入りしていないみたいです。

<pre>
#include &lt;boost/coerce.hpp&gt;
#include &lt;iostream&gt;
#include &lt;string&gt;
#include &lt;typeinfo&gt;

int main()
{
    const std::string str("123");
    auto num = boost::coerce::as&lt&int&gt;(str);
    std::cout << typeid(num).name() << " : " << num << std::endl;
}
</pre>
