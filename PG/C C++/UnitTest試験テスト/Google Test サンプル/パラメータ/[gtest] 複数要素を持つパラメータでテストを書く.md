引用<br/>
[[gtest] 複数要素を持つパラメータでテストを書く](https://srz-zumix.blogspot.com/2014/10/gtest.html)<br/>

## 構造体をパラメータ化
ぱっと思いつく簡単な方法として構造体を使う方法があります。<br/>

<pre>
struct Param
{
    int x;
    float y;
};
 
::std::vector<Param> make_param()
{
    ::std::vector<Param> v;
    for( int i=0; i < 5; ++i ) v.push_back(Param{ i, i*0.5f });
    return v;
}
 
class Test : public testing::TestWithParam<Param> {};
INSTANTIATE_TEST_CASE_P(A, Test, testing::ValuesIn(make_param()));
 
TEST_P(Test, A)
{
    Param p = GetParam();
    ::std::cout << p.x << ", " << p.y << ::std::endl;
}
</pre>
ただ、これだと構造体の定義やパラメータの生成がやや面倒です。<br/>

## tuple パラメータ
tuple をパラメータの型として扱う方法です。<br/>

<pre>
class Test : public testing::TestWithParam< ::std::tuple<int, float> > {};
INSTANTIATE_TEST_CASE_P(A, Test, testing::Values(
    ::std::make_tuple(0, 0*0.5f)
    , ::std::make_tuple(1, 1 * 0.5f)
    , ::std::make_tuple(2, 2 * 0.5f)
    , ::std::make_tuple(3, 3 * 0.5f)
    , ::std::make_tuple(4, 4 * 0.5f)
    ));
 
TEST_P(Test, A)
{
    ::std::tuple<int, float> p = GetParam();
    ::std::cout << ::std::get<0>(p) << ", " << ::std::get<1>(p) << ::std::endl;
}
</pre>

構造体の分だけ、すこ～しだけ簡単になった？気がします。<br/>
パラメータの構築は最初の例のように vector を返す関数で作ってもいいです。お好みでどうぞ。<br/>


