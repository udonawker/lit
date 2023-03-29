## [可変長引数をもつ関数(printf, ioctl, etc..)をラップする方法まとめ](https://qiita.com/koara-local/items/585755faac70c8b37b5b)


可変長引数を持つ関数をラップする方法を調べました。<br>
C++11以降であれば variadic templates を使うのが良いと思われます。<br>

```
#include <stdio.h>
#include <stdarg.h>

// [C++11 ~] variadic templates
template <typename ... Args>
void Printf(const char *format, Args const & ... args) {
    // int printf(const char *format, ...);
    printf(format, args ...);
}

// [C/C++] stdarg
void vPrintf(const char *format, ...) {
    va_list va;
    va_start(va, format);
    // int vprintf(const char *format, va_list ap);
    vprintf(format, va);
    va_end(va);
}

// [C/C++] macro __VA_ARGS__
#define PRINTF(format, ...) printf(format, __VA_ARGS__)

// [C/C++][GCC only] macro ##__VA_ARGS__
#define PRINTF_GCC(format, ...) printf(format, ##__VA_ARGS__)

int main(int argc, char const* argv[])
{
    // [C++11 ~] variadic templates
    Printf("%s : %d\n", "Printf", 20);

    // [C/C++] stdarg
    // va_listをサポートしている必要がある
    vPrintf("%s : %d\n", "vPrintf", 20);

    // [C/C++] macro __VA_ARGS__
    PRINTF("%s : %d\n", "PRINTF", 20);

    // __VA_ARGS__は最低１個引数が必要な仕様なため、カンマが入ってしまい以下はエラーになる
    // PRINTF("PRINTF format only\n");

    // [C/C++][GCC only] macro ##__VA_ARGS__
    // GCC拡張であれば未指定の場合最後のカンマを除去してくれる
    PRINTF_GCC("%s : %d\n", "PRINTF_GCC", 20);
    PRINTF_GCC("PRINTF_GCC : format only\n");

    return 0;
}
```

実行結果<br>

```
$ g++ -std=c++11 test.cpp && ./a.out
Printf : 20
vPrintf : 20
PRINTF : 20
PRINTF_GCC : 20
PRINTF_GCC : format only
```

[本の虫: Variadic Templatesの解説](http://cpplover.blogspot.jp/2010/03/variadic-templates.html)<br>
[c++ - 可変長引数関数のラッピング方法 - スタック・オーバーフロー](http://ja.stackoverflow.com/questions/11487/%E5%8F%AF%E5%A4%89%E9%95%B7%E5%BC%95%E6%95%B0%E9%96%A2%E6%95%B0%E3%81%AE%E3%83%A9%E3%83%83%E3%83%94%E3%83%B3%E3%82%B0%E6%96%B9%E6%B3%95)<br>
[C言語 可変引数マクロの作り方 - Qiita](http://qiita.com/saltheads/items/e1b0ab54d3d6029c9593)<br>
[C／C++での可変引数（stdarg他）](http://www.02.246.ne.jp/~torutk/cxx/tips/varargs.html)<br>
