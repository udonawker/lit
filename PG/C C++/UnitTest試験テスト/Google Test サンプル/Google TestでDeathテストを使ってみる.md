引用<br/>
[Google TestでDeathテストを使ってみる](https://s15silvia.blog.so-net.ne.jp/2013-04-21)<br/>

Google TestにはDeathテストというのがある．<br/>
詳細は例によって，ドキュメントを参照してほしいんだけど，要はコード中のアサーションが正しく動作しているかどうかを確認するためのテストで，しかもアサーションが失敗してプログラムが処理を中断し終了するかどうかをテストするものだ．<br/>
ちなみにアサーションというのは日本語だと「表明」とかって訳されていて，そこには実行時に絶対に満たされているべき条件を記載してやる．つまり，条件に書かれてる内容が満たされてることを期待してますよ，と表明しているわけだ．<br/>
なお，その条件が満たされないと以後の処理は続けられない（続けると回復できない重大な問題が発生ししてしまう）場合に使う．その場合ってのは，つまり致命的なエラーが起きたってことだ．<br/>
<br/>
では，試してみよう．<br/>
例によってディレクトリ構成．<br/>

<pre>
gtest_advanced_death_proj/
├── CMakeLists.txt
├── assertion_func.cpp
├── assertion_func.h
├── compiler_settings.cmake
├── main.cpp
└── test
    └── advanced_unittest.cpp
</pre>

compiler_settings.cmakeは以前から変更が無いので省略して，それ以外は以下のようになる．<br/>
<br/>
CMakeLists.txt<br/>

<pre>
cmake_minimum_required(VERSION 2.6)
project(gtest_advanced_test)

include (compiler_settings.cmake)

enable_testing()
set(CMAKE_INCLUDE_CURRENT_DIR ON)
message(STATUS GTEST_DIR=$ENV{GTEST_DIR})

include_directories($ENV{GTEST_DIR}/include)
link_directories($ENV{GTEST_DIR}/lib)

cxx_executable(assert_main "" main.cpp assertion_func.cpp)
cxx_test(gtest_advanced_test "" assertion_func.cpp test/advanced_unittest.cpp)
</pre>

assertion_func.cpp<br/>

<pre>
#include <cassert>
#include "assertion_func.h"

void Func(bool is_true)
{
    assert(is_true);
}
</pre>

assertion_func.h<br/>

<pre>
#ifndef ASSERTION_FUNC_H
#define ASSERTION_FUNC_H

void Func(bool is_true);

#endif // ASSERTION_FUNC_H
</pre>

main.cpp<br/>

<pre>
#include <iostream>
#include "assertion_func.h"

int main()
{
    bool test = false;
    Func(test);

    return 0;
}
</pre>

test/advanced_unittest.cpp<br/>

<pre>
#include <gtest/gtest.h>
#include <cassert>
#include "assertion_func.h"

TEST(MyDeathTest, FuncDeath)
{
    ASSERT_DEATH({
            bool test = false;
            Func(test);
            }, "");
}
</pre>

では，ざっくり説明．<br/>
とりあえず，ビルドして，assertion_mainを実行してみると，以下のような表示が出てプログラムは終了する．<br/>

<pre>
gtest_advanced_death_proj/assertion_func.cpp:6: void Func(bool): Assertion `is_true' failed.
</pre>

これはassertion_func.cpp:6にis_trueが「true」であることを期待してますよと表明しておいたにもかかわらず，実際は「false」だったため，アサーションが失敗しました，ということだ．<br/>
で，これをテストするために，Google Testでは例えばASSERT_DEATHというマクロを用意してくれてる．書式は，<br/>

<pre>
ASSERT_DEATH(statement, regex);
</pre>

となっていて，statementにはプログラムが「クラッシュ」する文を書く．<br/>
ちなみにここで言うクラッシュとは，ドキュメントによれば「プロセスが exit() または _exit() を0ではない引数で呼び出した場合．<br/>
 あるいは，シグナルによって殺された場合」を指す．<br/>
 だから正常終了した場合なんかは当てはまらない．<br/>
 で，ここには式だけじゃなくて例にあるように文も書ける．<br/>
あと，regexには標準エラー出力とマッチする正規表現を書ける．<br/>
<br/>
アサーション自体はとても重要だ．<br/>
だからアサーションが正しく機能するかをテストすることもとても重要だ．<br/>
Deathテストを自分で作るとすると多分とてもめんどくさいはず．<br/>
それをGoogle Testが用意してくれてるのはとても助かる．<br/>
しかも簡単に使える．<br/>
ぜひお試しあれ．<br/>
