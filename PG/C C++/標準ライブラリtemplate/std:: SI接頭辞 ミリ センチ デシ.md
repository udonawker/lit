## [std::SI接頭辞](https://cpprefjp.github.io/reference/ratio/si_prefix.html)

```
namespace std {
  using yocto = ratio<1, 1000000000000000000000000>;
  using zepto = ratio<1,    1000000000000000000000>;
  using atto  = ratio<1,       1000000000000000000>;
  using femto = ratio<1,          1000000000000000>;
  using pico  = ratio<1,             1000000000000>;
  using nano  = ratio<1,                1000000000>;
  using micro = ratio<1,                   1000000>;
  using milli = ratio<1,                      1000>;
  using centi = ratio<1,                       100>;
  using deci  = ratio<1,                        10>;
  using deca  = ratio<                       10, 1>;
  using hecto = ratio<                      100, 1>;
  using kilo  = ratio<                     1000, 1>;
  using mega  = ratio<                  1000000, 1>;
  using giga  = ratio<               1000000000, 1>;
  using tera  = ratio<            1000000000000, 1>;
  using peta  = ratio<         1000000000000000, 1>;
  using exa   = ratio<      1000000000000000000, 1>;
  using zetta = ratio<   1000000000000000000000, 1>;
  using yotta = ratio<1000000000000000000000000, 1>;
}
```

これらは、コンパイル時有理数であるratioを利用した、SI単位系(The International System of Units : 国際単位系)の接頭辞を表す型である。<br>
|型|説明|
|:--|:--|
|yocto|ヨクト|
|zepto|ゼプト|
|atto|アト|
|femto|フェムト|
|pico|ピコ|
|nano|ナノ|
|micro|マイクロ|
|milli|ミリ|
|centi|センチ|
|deci|デシ|
|deca|デカ|
|hecto|ヘクト|
|kilo|キロ|
|mega|メガ|
|giga|ギガ|
|tera|テラ|
|peta|ペタ|
|exa|エクサ|
|zetta|ゼタ|
|yotta|ヨタ|
