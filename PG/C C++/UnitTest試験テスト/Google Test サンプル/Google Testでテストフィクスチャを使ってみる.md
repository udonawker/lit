引用<br/>
[Google Testでテストフィクスチャを使ってみる](https://s15silvia.blog.so-net.ne.jp/2013-03-20)<br/>

Google Testを今回も試してみる．<br/>
で，今回は，テストフィクスチャを使ってみる．<br/>
テストフィクスチャってのは，Wikipediaを引用すると，「テストを実行、成功させるために必要な状態や前提条件の集合を、フィクスチャと呼ぶ。これらはテストコンテキストとも呼ばれる。開発者はテストの実行前にテストに適した状態を整え、テスト実行後に元の状態を復元することが望ましい。」とある．<br/>
<br/>
要するに，これを使うと，テストの事前準備と事後処理をさせることができるようになる．<br/>
<br/>
で，Google Testでの使い方なんだけど，まずはディレクトリ構成．<br/>

<pre>
fixture_proj/
├── CMakeLists.txt
├── compiler_settings.cmake
└── test
    └── fixture_unittest.cpp
</pre>

次にファイルについて．<br/>
compiler_settings.cmakeは前回と同じ内容で，CMakeLists.txtはプロジェクト名の変更と，テストファイル名がtest/fixture_unittest.cppに変わったことに伴う変更だけ．<br/>
<br/>
で，今回のテストフィクスチャの使い方はfixture_unittest.cppに書かれてるわけだが，最初に言っておくと，今回のテストはあくまでテストフィクスチャの使い方の説明のためだけであって，テストそのものとかは正直あんまり意味は無い．<br/>
<br/>
ではfixture_unittest.cppの中身．<br/>

<pre>
#include <gtest/gtest.h>

class FixtureTest : public ::testing::Test {
protected:
    virtual void SetUp() {
        printf("TestFixture SetUp called\n");
        p = new int[10];
        for (int i = 0; i < 10; i++) {
            p[i] = i;
        }
    }

    virtual void TearDown() {
        printf("TestFixture TearDown called\n");
        delete [] p;
    }

    int *p;
};

TEST_F(FixtureTest, CheckIndex0Value)
{
    EXPECT_EQ(0, p[0]);
}

TEST_F(FixtureTest, UpdateValue)
{
    p[0] = 100;
    p[5] = 500;

    EXPECT_EQ(100, p[0]);
    EXPECT_EQ(500, p[5]);
}

TEST_F(FixtureTest, CheckAllValue)
{
    for (int i = 0; i < 10; i++) {
        EXPECT_EQ(i, p[i]);
    }
}
</pre>

で，これをビルドしてテストを実行してみると分かるが，１つ１つのテスト（今回の例だとCheckIndex0Value，UpdateValue，CheckAllValue）が実行されるたびに，SetUp()とTearDown()が実行される．<br/>
ビルドディレクトリで，<br/>

<pre>
make test ARGS=-V
</pre>

とすると，SetUp()とTearDown()にあるprintf()がテストごとに実行されているのが分かるはずだ．<br/>
また，この例で試してみたところ，CheckAllValueのテストが実行されてからCheckAllValueのテストが実行されるようだが，SetUp()で毎回配列の初期化がされるので，UpdateValueのテストで配列の値の変更をしてもCheckAllValueのテストを実行するときには再度配列の初期化がされているのでテストは成功する．<br/>
<br/>
というわけで，１つ１つのテストに対して前提条件があって，常にその条件を満たすようにしたい場合には，このテストフィクスチャの仕組みがうまく機能するということだ．

今回の例はあんまり参考にならないかもしれないが，実際にいろいろなテストを書いてると，こういった前提条件を整えるというのはどうしても必要になってくる．<br/>
これがフレームワークとして用意されてるのはとても助かる．<br/>
<br/>
便利なのでぜひ使ってみてくださいな．<br/>
