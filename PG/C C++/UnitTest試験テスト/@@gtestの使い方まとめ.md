## [【C/C++】gtestの使い方まとめ(基本編)](https://www.mathkuro.com/c-cpp/gtest-primer/)

よく使いそうなアサーションをまとめました。<br>
※省略してEXPECT_〜のみ記載していますが、いずれのアサーションもASSERT_〜がありますので適宜置き換えてください。<br>

|アサーションマクロ|どのような判定が行われるか|備考|
|:--|:--|:--|
|EXPECT_TRUE(condition);|condition == true|
|EXPECT_FALSE(condition);|condition == false|
|EXPECT_EQ(val1, val2);|val1 == val2|std::string比較可能|
|EXPECT_NE(val1, val2);|val1 != val2|std::string比較可能|
|EXPECT_LT(val1, val2);|val1 < val2|std::string比較可能|
|EXPECT_LE(val1, val2);|val1 <= val2|std::string比較可能|
|EXPECT_GT(val1, val2);|val1 > val2|std::string比較可能|
|EXPECT_GE(val1, val2);|val1 >= val2|std::string比較可能|
|EXPECT_STREQ(str1, str2);|二つの文字列が等しい|C文字列用(char*等)|
|EXPECT_STRNE(str1, str2);|二つの文字列が等しくない|C文字列用(char*等)|
|EXPECT_STRCASEEQ(str1, str2);|大文字小文字を無視した場合、二つの文字列が等しい|C文字列用(char*等)|
|EXPECT_STRCASENE(str1, str2);|大文字小文字を無視した場合、二つの文字列が等しくない|C文字列用(char*等)|
|EXPECT_THROW(func, exception);|funcが指定したexceptionを投げる|
|EXPECT_ANY_THROW(func);|funcが何らかの例外を投げる。|
|EXPECT_NO_THROW(func);|funcが一切例外を投げない。|
|EXPECT_FLOAT_EQ(val1, val2);|2つのfloat値がほぼ等しい|4 ULPs 以内|
|EXPECT_DOUBLE_EQ(val1, val2);|2つのdouble値がほぼ等しい|4 ULPs 以内|
|EXPECT_NEAR(val1, val2, abs);|val1とval2の差がabs以内に収まる|
|EXPECT_THAT(val, matcher);|googlemockのMatcherを使用する|正規表現等を比較可能だが、mockの知識が必要なので応用編で紹介|
