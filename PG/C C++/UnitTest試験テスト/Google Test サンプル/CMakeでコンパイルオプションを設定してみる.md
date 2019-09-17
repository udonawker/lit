引用<br/>
[CMakeでコンパイルオプションを設定してみる](https://s15silvia.blog.so-net.ne.jp/2013-03-16)<br/>

[以前](http://s15silvia.blog.so-net.ne.jp/2013-02-16)，Google Testを使ってみた．<br/>
このときはお試しだったので，とりあえずコンパイルできてテストできればよかったんだけど，実際に使い続けるとなるとコンパイルオプションをちゃんと設定したい．<br/>
<br/>
コンパイラが教えてくれるエラーやワーニングは，（ときどき余計なお世話だと思うこともあるけど）ちゃんとしたコードを書くためにはとても役に立つと思う．<br/>
少なくとも，世間一般でよく言われるコンパイルオプションは設定しておかないと．．．<br/>
<br/>
というわけで，CMakeでやるとしたらどうするかを調べてみた．<br/>
で，お手軽には，CMakeの変数「CMAKE_CXX_FLAGS」にコンパイルオプションを設定してやればいいようだ．<br/>
ただ，もうちょっと柔軟にコンパイルオプションを設定するんだと，CMakeの「set_target_properties」コマンドを使うといいらしい．これだと，ビルドするターゲットごとにコンパイルオプションを設定するとかってこともできるようになる．例えば，リリースするバイナリをビルドするときとテストのときでコンパイルオプションを変えるとかもできるようになる．<br/>
<br/>
で，参考にしたのはGoogle Testのライブラリの設定だ．<br/>
Google Testをダウンロードしたディレクトリの中に，CMakeLists.txtと，cmake/internal_utils.cmakeというファイルがあって，それを参考にしてる．<br/>
というかここから必要な部分だけ抜き出してる．<br/>
<br/>
では，具体的に，以前作ったadd_projに対してどうなるかだが，細かい説明は抜きにしてとりあえず結果を示すと以下のようになる．<br/>
<br/>
まず，ディレクトリ構成<br/>

<pre>
add_proj/
├── CMakeLists.txt
├── add.cpp
├── add.h
├── compiler_settings.cmake　<--- このファイルを追加
├── main.cpp
└── test
    └── add_unittest.cpp
</pre>

で，今回変更したファイルは，CMakeLists.txtと，追加したcompiler_settings.cmakeだけ．<br/>
まず，CMakeLists.txt<br/>

<pre>
cmake_minimum_required(VERSION 2.6)
project(add)

include (compiler_settings.cmake)

enable_testing()
set(CMAKE_INCLUDE_CURRENT_DIR ON)
message(STATUS GTEST_DIR=$ENV{GTEST_DIR})

include_directories($ENV{GTEST_DIR}/include)
link_directories($ENV{GTEST_DIR}/lib)

cxx_executable(add_main "" main.cpp add.cpp)
cxx_test(add "" add.cpp test/add_unittest.cpp)
</pre>

次にcompiler_settings.cmake<br/>

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
</pre>

で，内容をざっくり書くと．．．<br/>
compiler_settings.cmakeで必要なコンパイルオプションの設定とCMakeのfunctionを定義してる．<br/>
で，CMakeLists.txtからは定義したfunctionを呼び出すようにしてる．<br/>
ちなみに今回設定しているコンパイルオプションは，-Wall -Wshadow -Wextra -Werrorの４つだけ．<br/>
他にも大事なオプションはいっぱいあるんだけどとりあえず今回はこれだけ．<br/>
で，これの意味は，まぁGoogle先生に聞いてください．<br/>
<br/>
なお，実際にちゃんとコンパイルオプションが設定されているか確認するには，ビルドディレクトリで，<br/>

<pre>
make VERBOSE=1
</pre>

としてやると，詳細が表示されるようになる．<br/>
