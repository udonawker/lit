[左詰め／右詰め／ゼロ埋めの方法と注意点【cout／iostream 文字揃え】](https://marycore.jp/prog/cpp/padding-left-right-zero/)<br/>

C++の入出力ストリームクラス（cout/iostream, stringstream等）で空白による右詰めや右詰め、ゼロ埋め（zero padding）を実現する方法を紹介します。<br/>
事前にiosヘッダやiomanipヘッダをインクルードしておく必要があります。<br/>

<pre>
#include <ios>     // std::left, std::right
#include <iomanip> // std::setw(int), std::setfill(char)
</pre>

## 右詰め
<pre>
std::cout << std::right << std::setw(4) <<  12; // "  12"
std::cout << std::right << std::setw(4) << -12; // " -12"
</pre>

## 左詰め
<pre>
std::cout << std::left << std::setw(4) <<  12; // "12  "
std::cout << std::left << std::setw(4) << -12; // "-12 "
</pre>

## ゼロ埋め
<pre>
std::cout << std::setfill('0') << std::right << std::setw(4) << 12; // "0012"
std::cout << std::setfill('0') << std::left  << std::setw(4) << 12; // "1200"

std::cout << std::setfill(' '); // ゼロ埋め・解除（デフォルトに戻す）
</pre>

## 文字揃え関連のマニピュレータについて
左寄せと右寄せはそれぞれ`std::left`, `std::right`マニピュレータを用いて行います。文字幅は`std::setw()`、詰めたい文字は`std::setfill()`で指定します（空白やゼロ以外の文字も指定できます）。<br/>
<br/>
＃左詰め（`std::left`）と＃右詰め（`std::right`）それぞれのマニピュレータを`std::setfill('0')`や`std::setw(文字幅)`と組み合わせて利用することで＃ゼロ埋めを実現することもできます。<br/>
<br/>
以下は文字揃え関連のフォーマットでよく使われるマニピュレータです。それぞれのマニピュレータは`iomanip`ヘッダーや`ios`ヘッダー、場合によっては`iostream`ヘッダーを読み込むことで利用可能になります。<br/>

<pre>
#include <ios>
std::left;          // 左揃えで出力
std::right;         // 右揃えで出力
std::internal;      // 符号左揃え、数字右揃え
std::showpos;       // 正の符号も出力

#include <iomanip>
std::setw(int);     // 文字幅を指定
std::setfill(char); // 詰めたい文字を指定
</pre>
<pre>
std::cout << std::showpos << 9; // "+9"
std::cout << std::internal << std::setw(4) << -9; // "-  9"

std::cout << std::setfill('0') << std::right    << std::setw(4) << -12; // "0-12"
std::cout << std::setfill('0') << std::internal << std::setw(4) << -12; // "-012"
</pre>

## マニピュレータ／フラグの解除
setw以外のマニピュレータではフラグの状態が引き継がれるため注意してください。設定された状態は次回の出力時にも影響します。<br/>
setwについては、入出力ストリーム上に値を渡す度にゼロにリセットされます。<br/>

<pre>
std::cout << std::left;
std::cout << std::showpos;
std::cout << std::setfill('_');
std::cout << std::setw(4) << 12; // "+12_"
std::cout << std::setw(4) << 12; // "+12_" ("  12"ではない)
std::cout << 12;                 // "+12" (符号が付いたままとなる。setwのみリセットされる)
</pre>

以下の方法でデフォルトの状態に戻すことができます。<br/>

<pre>
/* 解除 */
std::cout << std::right;
std::cout << std::noshowpos;
std::cout << std::setfill(' ');
std::cout << std::setw(0);

/* 確認 */
std::cout                 << 12; // "12"
std::cout << std::setw(4) << 12; // "  12"
std::cout                 << 12; // "12"
std::cout << std::setw(4);
std::cout                 << 12; // "  12"
</pre>
