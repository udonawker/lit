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
