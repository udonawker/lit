引用<br/>
[Google Testを使ってみる](https://s15silvia.blog.so-net.ne.jp/2013-02-10)<br/>

C++のテストフレームワークとして，Google Testというのがあるので使ってみる．<br/>
<br/>
Google Testはいろんなプラットフォームに対応しているらしい．<br/>
例えばLinuxとかMac OS X，あとWindowsとかCygwinでも使えるらしい．<br/>
<br/>
で，これをうちのビルドマシン上で使ってみる．<br/>
ビルドマシンのOSはubuntu 12.04の64bit版だ．<br/>
<br/>
では，まずは適当なディレクトリを作成し，Google Testをダウンロード，展開してやる．<br/>

<pre>
cd ~/
mkdir googletest
cd googletest/
wget http://googletest.googlecode.com/files/gtest-1.6.0.zip
unzip gtest-1.6.0.zip
</pre>

そしたらライブラリを作成してやる．<br/>
作成方法の詳細は展開先のREADMEに書かれてるので一度ざっと目を通しとくといいかも．<br/>
あと，この作業でCMakeを使うので先にインストールしておく（使わなくてもできるけど）．<br/>
というわけでCMakeのインストール<br/>

<pre>
sudo apt-get install cmake
</pre>

ライブラリ作成<br/>

<pre>
cd ~/googletest/gtest-1.6.0/
mkdir lib
cd lib/
cmake ../
make
</pre>

これで，「libgtest.a」と「libgtest_main.a」が作成されるはずだ．<br/>
実際テストするときはこのライブラリをリンクして使うことになる．<br/>
<br/>
そしたら，試しにサンプルをビルドして，テストを実行してみる．<br/>

<pre>
cd ~/googletest/gtest-1.6.0/
mkdir build_sample
cd build_sample/
cmake -Dgtest_build_samples=ON ../
make
</pre>

そうすると，以下の実行可能なファイルが作成されるはずだ．<br/>

<pre>
sample1_unittest
sample2_unittest
sample3_unittest
sample4_unittest
sample5_unittest
sample6_unittest
sample7_unittest
sample8_unittest
sample9_unittest
sample10_unittest
</pre>

試しにsample1_unittestを実行してみる．<br/>

<pre>
./sample1_unittest
</pre>

そうするとテストが実行されて以下のような結果が表示されるはずだ．<br/>

<pre>
Running main() from gtest_main.cc
[==========] Running 6 tests from 2 test cases.
[----------] Global test environment set-up.
[----------] 3 tests from FactorialTest
[ RUN      ] FactorialTest.Negative
[       OK ] FactorialTest.Negative (0 ms)
[ RUN      ] FactorialTest.Zero
[       OK ] FactorialTest.Zero (0 ms)
[ RUN      ] FactorialTest.Positive
[       OK ] FactorialTest.Positive (0 ms)
[----------] 3 tests from FactorialTest (1 ms total)

[----------] 3 tests from IsPrimeTest
[ RUN      ] IsPrimeTest.Negative
[       OK ] IsPrimeTest.Negative (0 ms)
[ RUN      ] IsPrimeTest.Trivial
[       OK ] IsPrimeTest.Trivial (0 ms)
[ RUN      ] IsPrimeTest.Positive
[       OK ] IsPrimeTest.Positive (0 ms)
[----------] 3 tests from IsPrimeTest (0 ms total)

[----------] Global test environment tear-down
[==========] 6 tests from 2 test cases ran. (1 ms total)
[  PASSED  ] 6 tests.
</pre>

実際には色もついて表示される．<br/>
で，ここまで確認できればOK．<br/>
<br/>
次のステップはサンプルじゃなくて自分のコードをテストすることになるのだが，それはまた次回．<br/>
