引用<br/>
[Google MockのExpectationをいろいろ使ってみる](https://s15silvia.blog.so-net.ne.jp/2013-04-06)<br/>

[前回](http://s15silvia.blog.so-net.ne.jp/2013-03-23)，Google Mockを使ってみた．<br/>
で，今回はさらにいろいろなExpectationを使ってみる．<br/>
という訳で，[Google Mock ドキュメント日本語訳の超入門編](http://opencv.jp/googlemockdocs/fordummies.html#expectation)に出てくるExpectationをいろいろ試してみる．<br/>
<br/>
ファイル構成は前回と同じ．<br/>
というか前回のファイルに追記してる．<br/>
変更したのは，painter.h，painter.cpp，test/mock_unittest.cppの３つだけだ．<br/>
まずはこれを示そう．<br/>
<br/>
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
    int GetPositionX();
    void Move(int steps);

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

int Painter::GetPositionX()
{
    return turtle_->GetX();
}

void Painter::Move(int steps)
{
    turtle_->Forward(steps * 10);
}
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

TEST(PointerTest, ReturnOfGetX)
{
    MockTurtle turtle;
    EXPECT_CALL(turtle, GetX())
        .Times(5)
        .WillOnce(::testing::Return(100))
        .WillOnce(::testing::Return(150))
        .WillRepeatedly(::testing::Return(200));
  
    Painter painter(&turtle);

    EXPECT_EQ(100, painter.GetPositionX());
    EXPECT_EQ(150, painter.GetPositionX());
    EXPECT_EQ(200, painter.GetPositionX());
    EXPECT_EQ(200, painter.GetPositionX());
    EXPECT_EQ(200, painter.GetPositionX());
}

TEST(PointerTest, CheckForwardArgs)
{
    MockTurtle turtle;
    EXPECT_CALL(turtle, Forward(100));
  
    Painter painter(&turtle);
    painter.Move(10);
}

TEST(PointerTest, CheckOnlyForwardCall)
{
    MockTurtle turtle;
    EXPECT_CALL(turtle, Forward(::testing::_));
  
    Painter painter(&turtle);
    painter.Move(3);
}

TEST(PointerTest, CheckForwardArgsGe)
{
    MockTurtle turtle;
    EXPECT_CALL(turtle, Forward(::testing::Ge(200)));
  
    Painter painter(&turtle);
    painter.Move(20);

    EXPECT_CALL(turtle, Forward(::testing::Ge(200)));
    painter.Move(30);
}

TEST(PointerTest, CardinalityCheck)
{
    MockTurtle turtle;
    EXPECT_CALL(turtle, GetX())
        .WillOnce(::testing::Return(100))
        .WillOnce(::testing::Return(150));
  
    Painter painter(&turtle);
    painter.GetPositionX();
    painter.GetPositionX();
}

TEST(PainterTest, MultipleExpectation)
{
    MockTurtle turtle;
    EXPECT_CALL(turtle, Forward(::testing::_));
    EXPECT_CALL(turtle, Forward(10))
        .Times(2);
  
    Painter painter(&turtle);
    painter.Move(1);
    painter.Move(3);
    painter.Move(1);
}

TEST(PainterTest, NoSequence)
{
    MockTurtle turtle;
    EXPECT_CALL(turtle, Forward(::testing::_));
    EXPECT_CALL(turtle, PenDown());
    EXPECT_CALL(turtle, GetX());
    
    Painter painter(&turtle);

    painter.GetPositionX();         // GetX()呼び出し
    painter.Move(3);                // Forward()呼び出し
    painter.DrawCircle(0, 0, 10);   // PenDown()呼び出し
}

TEST(PainterTest, SequenceRequired)
{
    MockTurtle turtle;

    {
        ::testing::InSequence dummy;

        EXPECT_CALL(turtle, Forward(::testing::_));
        EXPECT_CALL(turtle, PenDown());
        EXPECT_CALL(turtle, GetX());
    }
    
    Painter painter(&turtle);

    painter.Move(3);                // Forward()呼び出し
    painter.DrawCircle(0, 0, 10);   // PenDown()呼び出し
    painter.GetPositionX();         // GetX()呼び出し
}

TEST(PainterTest, SaturationNoSequence)
{
    MockTurtle turtle;

    for (int i = 3; i > 0; i--) {
        EXPECT_CALL(turtle, GetX())
            .WillOnce(::testing::Return(10 * i))
            .RetiresOnSaturation();
    }

    Painter painter(&turtle);
    EXPECT_EQ(10, painter.GetPositionX());
    EXPECT_EQ(20, painter.GetPositionX());
    EXPECT_EQ(30, painter.GetPositionX());
}

TEST(PainterTest, SaturationInSequence)
{
    MockTurtle turtle;

    ::testing::InSequence s;    // これがないとEXPECT_CALLを逆順にセットする必要がある

    for (int i = 1; i <= 3; i++) {
        EXPECT_CALL(turtle, GetX())
            .WillOnce(::testing::Return(10 * i))
            .RetiresOnSaturation();
    }

    Painter painter(&turtle);
    EXPECT_EQ(10, painter.GetPositionX());
    EXPECT_EQ(20, painter.GetPositionX());
    EXPECT_EQ(30, painter.GetPositionX());
}
</pre>

前回と同様，コードとテストの詳細は前述のGoogle Mock ドキュメント日本語訳の超入門編をみてもらうとして，ポイントだけ説明しておく．<br/>
まず，今回，テスト用にPainterクラスにGetPositionX()とMove()を追加してる．<br/>
まぁこの動作にはあまり意味は無くて，単にテスト例を示すためだけの処理になってる．<br/>
<br/>
で，テストの内容だが，CanDrawSomethingは前回示したので置いておいて，それ以外について説明しておく．<br/>
<br/>
まずReturnOfGetX．<br/>
これはEXPECT_CALLでGetX()の戻り値を設定してる．<br/>
Mockに100, 150, 以後200を返すように設定する場合の例だ．<br/>
WillOnceが１回だけ，WillRepeatedlyは繰り返し，設定した値を返すようになる．<br/>
<br/>
次にCheckForwardArgsとCheckOnlyForwardCall．<br/>
テストするときに，引数チェックまでするか，単にメソッド呼び出しだけチェックしたいか，の２つのパターンがあると思う．<br/>
で，引数チェックするならEXPECT_CALLで引数指定してやればいいし，呼び出しだけでいいなら，::testing::_というのがが使える．<br/>
これにしておくと，引数は何でもいいから呼び出しだけをチェックできるようになる（引数の一致はチェックされなくなる）．<br/>
<br/>
CheckForwardArgsGe．<br/>
引数チェックに条件（たとえば「100以上であること」とか）を設定したければ，::testing::_の代わりに::testing::Ge(値)が使える．<br/>
他にもいろいろ条件は選べる．<br/>
これらは::testing::_も含め，matcherと呼ばれるようだ．<br/>

CardinalityCheck．<br/>
EXPECT_CALLには呼び出し回数としてTimes()を書けるけど，書かない場合でもGoogle Mockがそれなりに推測してうまくやってくれる．<br/>
例えば，WillOnce()が２回書かれてれば，呼び出し回数は２回と推測してくれる．<br/>
<br/>
MultipleExpectation．<br/>
複数のEXPECT_CALLを書く場合．<br/>
こいつはちょっと分かりにくいかもしれない．<br/>
まず複数のEXPECT_CALLが書かれてる場合だと，Google Mockは書かれてる逆の順番で一致を探索する仕様になってる．<br/>
なので，今回の例だと，引数10が先に探索され，次に引数不問の呼び出しが探索される．<br/>
逆の順序で探索してEXPECT_CALLと一致する呼び出しが見つかればOKだけど，そうじゃないとテストは失敗する．<br/>
例えば，今回の例だと，引数10の呼び出しが先に探索され，一致しなければ引数不問の呼び出しが探索される．<br/>
で，今回のMove(3)は，引数10の呼び出しとは一致しないが引数不問の呼び出しとは一致するのでOKとなる．<br/>
注意が必要なのは，一致探索は逆順ということと，逆順で最初に一致判断できるものが採用されるという点だ．<br/>
たとえば今回の例で，EXPECT_CALLの記載順序を変えて，引数不問の呼び出しを後に書くと，このテストは失敗するようになる．<br/>
なぜなら引数不問呼び出しを後に書くとMove(1)が引数不問と一致していると判断されてしまい，次のMove(3)と一致するものがなくなってしまうからだ．<br/>
たとえEXPECT_CALLに引数10の呼び出し，すなわちMove(1)と完全一致するEXPECT_CALLが書かれていても，その呼び出しとは判断されない．<br/>
あくまで，逆順で探索し最初に一致判断できる引数不問のEXPECT_CALLが採用されてしまう．<br/>
ちょっと分かりにくい気がするが，まぁそういうことだ．<br/>
まぁ，この場合は呼び出しの順番は関係なくてとにかく引数10の呼び出しが２回あることと，それ以外が１回だけあることをテストしたい場合，つまり順番は関係ない場合向けということになる．<br/>
<br/>
NoSequenceとSequenceRequired．<br/>
テストするときに，呼び出し順序まで指定したい場合もある．<br/>
で，その場合の例．<br/>
::testing::InSequenceを書くと，EXPECT_CALLを書いた順番で呼び出さないとエラーになる．<br/>
::testing::InSequenceが無ければ，MultipleExpectationのテストのように，逆順から探索される．<br/>
順番はどうでもよくてメソッドの呼び出しがされているかだけチェックしたければ::testing::InSequenceはいらないけど，呼び出し順序，すなわちシーケンスを守らなければならないのであれば::testing::InSequenceを書いてやる．<br/>
<br/>
SaturationNoSequenceとSaturationInSequence．<br/>
これも最初はちょっと分かりにくいかも．<br/>
基本は，呼び出しが一致するEXPECT_CALLがあった場合に，消えたりしないということだ．<br/>
んー，表現が分かりにくいな．<br/>
ドキュメントによれば，「呼び出し回数が上限に達してもアクティブであり続ける」とある．<br/>
例えば，SaturationNoSequenceの例で言えば，もしRetiresOnSaturation()の記載がなければ，<br/>

<pre>
EXPECT_CALL(turtle, GetX()).WillOnce(::testing::Return(30));
EXPECT_CALL(turtle, GetX()).WillOnce(::testing::Return(20));
EXPECT_CALL(turtle, GetX()).WillOnce(::testing::Return(10));
</pre>

と書かれているのと等価で，前述の通り，EXPECT_CALLは逆順から探索され，最初に一致したものが有効になる．<br/>
この場合だと，GetX()呼び出しをすると，最初に<br/>
EXPECT_CALL(turtle, GetX()).WillOnce(::testing::Return(10));<br/>
が一致するのでこれが有効となる．<br/>
で，問題は，一回一致した<br/>
EXPECT_CALL(turtle, GetX()).WillOnce(::testing::Return(10));<br/>
はずっと有効で，消えたりしないということだ．<br/>
再度GetX()を呼び出すと，やはり<br/>
EXPECT_CALL(turtle, GetX()).WillOnce(::testing::Return(10));<br/>
が一致することになるが，WiiOnce()といっているので，２回目の呼び出しはテストとしてエラーとなる．<br/>
で，これを避けたければ，RetiresOnSaturation()を書いてやればいい．<br/>
これなら指定した呼び出し回数に一致したら消える（破棄される）ようになる．<br/>
で，さらに::testing::InSequenceも書いてやると，EXPECT_CALLの順番通り，指定回数通りの呼び出しチェックができるようになる．<br/>
このへんは，テスト内容（何をテストしたいか）によって使い分けるといいだろう．<br/>
<br/>
では，お試しあれ．<br/>
