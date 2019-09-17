引用<br/>
[Google Mockを使ってみる](https://s15silvia.blog.so-net.ne.jp/2013-03-23)<br/>

いままで，Google Testを使ってきたが，さらにGoogle Mockも使ってみる．<br/>
<br/>
Google Mockとは，まぁ[日本語ドキュメント](http://opencv.jp/googlemockdocs/)があるので参照してください．<br/>
って書いてしまうとさすがに寂しいのでもうちょっと書くというか引用すると，Google Mockは「モッククラスを作成して使用するためのライブラリ」ということになる．<br/>
で，モックというのは，「Expectation を利用して事前にプログラムされたオブジェクト」だ．<br/>
呼び出されたら何を返すかとか，何を引数として呼び出されるのかとか，そもそも何回呼び出されるのかとかをあらかじめ指定しておけるオブジェクトだ．<br/>
なので，テストをするときに「本物」の代わりに使うと何かと便利になる．<br/>
<br/>
ではまず，Google Mockを使えるようにしてみる．<br/>
[Google Testを使えるようにしたとき](http://s15silvia.blog.so-net.ne.jp/2013-02-10)と同様に，まずは適当なディレクトリを作成し，Google Mockをダウンロード，展開してやる．<br/>

<pre>
cd ~/
mkdir googlemock
cd googlemock/
wget http://googlemock.googlecode.com/files/gmock-1.6.0.zip
unzip gmock-1.6.0.zip
</pre>

そしたらmakeする．<br/>
このとき，ubuntuの環境だとエラーが出てmakeできない．<br/>
なので，１カ所変更する．<br/>
変更対象のファイルは，~/googlemock/gmock-1.6.0/make/Makefileだ．<br/>
このファイルの最後の部分，-lpthreadのところを変更してやる．<br/>
変更前<br/>

<pre>
gmock_test : gmock_test.o gmock_main.a
    $(CXX) $(CPPFLAGS) $(CXXFLAGS) <span style="color: red; ">-lpthread</span> $^ -o $@
</pre>

変更後<br/>

<pre>
gmock_test : gmock_test.o gmock_main.a
    $(CXX) $(CPPFLAGS) $(CXXFLAGS) $^ -lpthread -o $@
</pre>

変更したらmakeして，テストする．<br/>

<pre>
cd gmock-1.6.0/make/
make
./gmock_test
</pre>

テストでエラーが出なければOKだ．<br/>
そしたらライブラリはコピーしておく．<br/>

<pre>
cd ~/googlemock/gmock-1.6.0/
mkdir lib
cp make/gmock_main.a lib/libgmock_main.a
</pre>

あと，Google Mockのパスを設定しておく．~/.bashrcとかに，<br/>

<pre>
export GMOCK_DIR=~/googlemock/gmock-1.6.0
</pre>

としておけばよい．<br/>
<br/>
これでひとまず準備は完了．<br/>
そしたら，Google Mock ドキュメント日本語訳の超入門編に出てくるMock Turtlesの例で試してみる．<br/>
<br/>
いつもと同じように適当なディレクトリにturtles_mock_projディレクトリを作って，ファイル構成は以下のようにしてやる．<br/>

<pre>
turtles_mock_proj/
├── CMakeLists.txt
├── compiler_settings.cmake
├── mock_turtle.h
├── painter.cpp
├── painter.h
├── test
│   └── mock_unittest.cpp
└── turtle.h
</pre>

それぞれのファイルは以下のようになる．ちょっと長くなるが全部示そう．<br/>
<br/>
CMakeLists.txt<br/>

<pre>
cmake_minimum_required(VERSION 2.6)
project(mock_test)

include (compiler_settings.cmake)

enable_testing()
set(CMAKE_INCLUDE_CURRENT_DIR ON)
message(STATUS GTEST_DIR=$ENV{GTEST_DIR})
message(STATUS GMOCK_DIR=$ENV{GTEST_DIR})

include_directories($ENV{GTEST_DIR}/include)
include_directories($ENV{GMOCK_DIR}/include)
link_directories($ENV{GTEST_DIR}/lib)
link_directories($ENV{GMOCK_DIR}/lib)

cxx_gmock_test(mock_test "" painter.cpp  test/mock_unittest.cpp)
</pre>

compiler_settings.cmake<br/>

<pre>
# compiler settings
find_package(Threads)

set(cxx_base_flags "${cxx_base_flags} -Wall -Wshadow")
set(cxx_base_flags "${cxx_base_flags} -Wextra")
set(cxx_base_flags "${cxx_base_flags} -Werror")

function(cxx_executable_with_flags name cxx_flags libs)
  add_executable(${name} ${ARGN})
  if (cxx_flags)
    set_target_properties(${name}
      PROPERTIES
      COMPILE_FLAGS "${cxx_flags}")
  endif()
  foreach (lib "${libs}")
    target_link_libraries(${name} ${lib})
  endforeach()
endfunction()

function(cxx_executable name libs)
  cxx_executable_with_flags(${name} "${cxx_base_flags}" "${libs}" ${ARGN})
endfunction()

function(cxx_test_with_flags name cxx_flags libs)
  cxx_executable_with_flags(${name} "${cxx_flags}" "${libs}" ${ARGN})
  target_link_libraries(${name} gtest;gtest_main)
  target_link_libraries(${name} ${CMAKE_THREAD_LIBS_INIT})
  add_test(${name} ${name})
endfunction()

function(cxx_test name libs)
  cxx_test_with_flags("${name}" "${cxx_base_flags}" "${libs}" ${ARGN})
endfunction()

function(cxx_gmock_test name libs)
  cxx_test_with_flags("${name}" "${cxx_base_flags}" "${libs};gmock_main" ${ARGN})
endfunction()
</pre>

painter.h<br/>

<pre>
#ifndef PAINTER_H
#define PAINTER_H

#include "turtle.h"

class Painter {
public:
    Painter(Turtle* turtle)
        : turtle_(turtle) {}
    ~Painter() {}

    bool DrawCircle(int x, int y, int r);

private:
    Turtle* turtle_;
};

#endif // PAINTER_H
</pre>

painter.cpp<br/>

<pre>
#include "painter.h"

bool Painter::DrawCircle(int x, int y, int r)
{
    (void)x;
    (void)y;
    (void)r;

    turtle_->PenDown();
    return true;
}
</pre>

turtle.h<br/>

<pre>
#ifndef TURTLE_H
#define TURTLE_H

class Turtle {
public:
    Turtle() {}
    virtual ~Turtle() {}
    virtual void PenUp() = 0;
    virtual void PenDown() = 0;
    virtual void Forward(int distance) = 0;
    virtual void Turn(int degrees) = 0;
    virtual void GoTo(int x, int y) = 0;
    virtual int GetX() const = 0;
    virtual int GetY() const = 0;
};

#endif // TURTLE_H
</pre>

mock_turtle.h<br/>

<pre>
#ifndef MOCK_TURTLE_H
#define MOCK_TURTLE_H

#include "gmock/gmock.h"
#include "turtle.h"

class MockTurtle : public Turtle {
public:
    MOCK_METHOD0(PenUp, void());
    MOCK_METHOD0(PenDown, void());
    MOCK_METHOD1(Forward, void(int distance));
    MOCK_METHOD1(Turn, void(int degrees));
    MOCK_METHOD2(GoTo, void(int x, int y));
    MOCK_CONST_METHOD0(GetX, int());
    MOCK_CONST_METHOD0(GetY, int());
};

#endif // MOCK_TURTLE_H
</pre>

test/mock_unittest.cpp<br/>

<pre>
#include "gtest/gtest.h"
#include "gmock/gmock.h"

#include "painter.h"
#include "mock_turtle.h"

TEST(PainterTest, CanDrawSomething)
{
    MockTurtle turtle;
    EXPECT_CALL(turtle, PenDown())
        .Times(::testing::AtLeast(1));
  
    Painter painter(&turtle);

    EXPECT_TRUE(painter.DrawCircle(0, 0, 10));
}
</pre>

そしたらいつも通りビルドしてやればテストできる．<br/>
コードとテストの詳細は前述のGoogle Mock ドキュメント日本語訳の超入門編をみてもらうとして，ポイントだけ説明しておく．<br/>
今回の例だと，CanDrawSomethingのテストで，PenDown()が１回だけ呼ばれることをモックを使ってテストしていて，実際，DrawCircle()でPenDown()を呼び出しているので，テストは成功する．<br/>
試しに，DrawCircle()でのPenDown()の呼び出しをコメントアウトしたりするとテストが失敗するようになるはずだ．<br/>
<br/>
今回はとりあえずメソッド呼び出しの回数テストだけしか試してないけど，Google Mockの雰囲気は分かると思う．<br/>
Google Mockは他にもいろいろできるんだけど，その辺についてはまた次回．<br/>
