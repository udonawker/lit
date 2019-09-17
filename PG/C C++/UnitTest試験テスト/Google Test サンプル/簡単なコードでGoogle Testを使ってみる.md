引用<br/>
[簡単なコードでGoogle Testを使ってみる](https://s15silvia.blog.so-net.ne.jp/2013-02-16)<br/>

前回，Google Testを使えるようにしたので，今回は，ごく簡単なコードに対してGoogle Testを使ってみることにする．<br/>
というわけで，Google Testの使い方について検索するとよく出てきて定番っぽい，２つの変数を加算するadd関数について試してみる．<br/>
なるべく，実際使う構成に近い方がイメージしやすいと思うので（といいつつも，単にadd関数だけなんて作ること無いと思うのだけど．．．）適当なディレクトリに，add_projというディレクトリを作ってやって，ファイル構成は以下のようにしてやる．あと，cmakeを使ってビルドしてみる．<br/>

<pre>
add_proj/
├── CMakeLists.txt
├── add.cpp
├── add.h
├── main.cpp
└── test
    └── add_unittest.cpp
</pre>

それぞれのファイルの内容は以下のようになる．<br/>
CMakeLists.txt（CMake用の設定ファイル）<br/>

<pre>
cmake_minimum_required(VERSION 2.6)
project(add)
enable_testing()
find_package(Threads)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

message(STATUS GTEST_DIR=$ENV{GTEST_DIR})

include_directories($ENV{GTEST_DIR}/include)
link_directories($ENV{GTEST_DIR}/lib)

add_executable(add_main main.cpp add.cpp)
add_executable(add add.cpp test/add_unittest.cpp)
target_link_libraries(add gtest gtest_main)
target_link_libraries(add ${CMAKE_THREAD_LIBS_INIT})
add_test(NAME add COMMAND add)
</pre>

ちなみに，GTEST_DIRは，前回Google Testをダウンロード，展開したディレクトリだ．<br/>
うちの場合だと，~/googletest/gtest-1.6.0/になる．なので，<br/>

<pre>
export GTEST_DIR=~/googletest/gtest-1.6.0
</pre>

としてやる．実際には，.bashrcにでも記載してやるといい．<br/>
add.cpp（add関数の定義）<br/>

<pre>
#include "add.h"

int add(int x, int y)
{
    return x + y;
}
</pre>

add.h（add関数の宣言）<br/>
<pre>
#ifndef ADD_H
#define ADD_H

int add(int x, int y);

#endif // ADD_H
</pre>

main.cpp（add関数を使用するmainの定義）<br/>

<pre>
#include <iostream>
#include "add.h"

int main()
{
    int x = 2;
    int y = 3;

    std::cout << x << " + " << y << " = " << add(x, y) << std::endl;

    return 0;
}
</pre>

test/add_unittest.cpp（add関数のテスト定義）<br/>

<pre>
#include <gtest/gtest.h>
#include "add.h"

TEST(TestAdd, add1)
{
    ASSERT_EQ(3, add(1,2));
}
</pre>

では，ビルドしてみる．<br/>
ビルドは，ソースファイルがあるディレクトリとは別のディレクトリにする（これをout-of-source buildとよぶらしい）．同じディレクトリでもいいのだが，CMakeはかなり中間ファイルを生成してごちゃごちゃするので，別ディレクトリにするのがおすすめだ．<br/>
今回は，add_projと同一階層にadd_buildディレクトリを生成して，以下のようにしてやる．<br/>

<pre>
mkdir add_build
cd add_build/
cmake ../add_proj/
make
</pre>

で，これによって，２つのバイナリが生成される．<br/>
add_mainとaddだ．<br/>
add_mainのほうは，単にadd関数によって2と3を加算した結果を表示するだけのプログラムで，addのほうがadd関数のテストになる．<br/>
今回は1+2の結果が3になることをテストしている．<br/>
<br/>
テストの実行は，./addでもいいし，make testでもいい．<br/>
ただし，make testだと，結果は詳細は表示されない．<br/>
./addと同等の表示をしたければ，make test ARGS=-Vとしてやればいい．<br/>
<br/>
なお，今回はadd_mainというadd関数を使ったプログラムも作ったが，単にadd関数のテストだけをやりたければ，main.cppはいらないし，add_mainの生成もしなくていい．<br/>
<br/>
Google Testは，今回の値の一致テスト以外にもいろんなことができる．<br/>
それについてはまた別の機会に．．．<br/>
<br/>
では，お試しあれ．<br/>
