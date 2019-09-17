ある特定の型を出力する際には，バイト値をダンプするより良い方法を教示することができる，ということを意味します．そのためには，その型に対して << 演算子を定義します：
<pre>
#include <iostream>

namespace foo {

class Bar { ... };  // Google Test が，これのインスタンスを出力できるようになってほしい．

// Bar の定義と「同じ」名前空間で << 演算子を定義することが重要です．
// C++ のルックアップルールは，それに依存しています．
::std::ostream& operator<<(::std::ostream& os, const Bar& bar) {
  return os << bar.DebugString();  // bar を os に出力するのに必要な処理を書きます
}

}  // 名前空間 foo
</pre>

この選択肢をとれない場合があるかもしれません：あなたのチームが，Bar に対して << 演算子を定義するのは悪いスタイルであると見なしている場合，Bar に対して既に << 演算子が定義されていて，その動作が望むものではない（そして，その変更もできない）場合，などです．その場合，代わりに PrintTo() 関数を次のように定義することができます：

<pre>
#include <iostream>

namespace foo {

class Bar { ... };

// Bar の定義と「同じ」名前空間で PrintTo() を定義することが重要です．
// C++ のルックアップルールは，それに依存しています．
void PrintTo(const Bar& bar, ::std::ostream* os) {
  *os << bar.DebugString();  // bar を os に出力するのに必要な処理を書きます
}

}  // 名前空間 foo
</pre>
