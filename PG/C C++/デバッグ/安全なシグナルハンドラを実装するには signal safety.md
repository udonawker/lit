## [安全なシグナルハンドラを実装するには](https://codezine.jp/article/detail/4700)
## [signal-safety(7) — Linux manual page](https://man7.org/linux/man-pages/man7/signal-safety.7.html)

## [安全なシグナルハンドラの書き方](https://alpha-netzilla.blogspot.com/2014/10/signal.html)

### 【シググナルハンドラの基礎】
以下の方針で簡単なブログラムを書く。<br>
● 標準入力から標準出力する<br>
● 標準入力を待つ間はSIGINTを受け付ける<br>
● 標準出力中はSIGINTを受け付けない<br>
つまり、入力があれば出力してから終了する<br>

<pre>
#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;
#include &lt;string.h&gt;
#include &lt;unistd.h&gt;
#include &lt;signal.h&gt;
#include &lt;errno.h&gt;

void handler(int no);

int main() {
  ssize_t ret;
  char buf[256];

  struct sigaction sa;
  sigset_t unblock_mask, block_mask;

  // シグナル受信時のハンドラ(呼び出す関数)関連の設定
  sa.sa_handler = handler;
  sa.sa_flags = SA_RESTART; 

  // シグナルマスク(ブロックするシグナルの集合)を初期化
  sigemptyset(&block_mask);

  // ブロックするシグナルをシグナルマスクとして設定(ここではSIGINT)
  // 対象となるシグナルセットするだけでまだブロックされない
  sigaddset(&block_mask, SIGINT);
  // 直接sigactionのmaskに設定もできるので以下でも可
  // sigaddset(&sa.sa_mask, SIGINT);

  // 設定したシグナルセットを有効化
  // マスクされたシグナルはブロック(正確には保留 ※1)される
  // 現在のマスク(未ブロックマスクセット)は第3引数に保存される
  sigprocmask(SIG_SETMASK, &block_mask, &unblock_mask);

  // 特定シグナル受信時の動作指示
  /* SIGINTは先にマスク(ブロック対象)にしているので、
    この段階ではSIGINTのシグナルハンドラは動作しない */
  sigaction(SIGINT, &sa, 0);


  // 標準入力を待つ間はSIGINTを受け付けるように変更
  // ブロックしないシグナルセットへ変更
  /* sigactionで設定したSIGINTシグナルを受信時に、
    指定したハンドラが呼ばれるようになる */
  sigprocmask(SIG_SETMASK, &unblock_mask, NULL);
  ret = read(0, buf, sizeof(buf));

  // 標準入力を待つ間はSIGINTを受け付けないように変更
  // ブロックするシグナルセットへ変更
  sigprocmask(SIG_SETMASK, &block_mask, &unblock_mask);

  // この間にCtrl+Cを送ってもハンドラは動作しない(確認のため意図的にsleep)
  sleep(10);
  write(1, buf, ret);

  return 0;
}


void handler(int num) {
  char *mes = "signal get\n";
  write( 1, mes, strlen(mes));
}
</pre>


### 【シググナルハンドラの問題点】
大きく２つシグナルハンドラには問題がある。<br>
● リエントラント問題<br>
● 最適化問題<br>

先のコードでprintfではなく、writeを使っていたことに気づいていただろうか。<br>
printfは非同期シグナルセーフな関数ではない(リエンﾆトラント性が考慮されていない)ためだ。<br>
シグナルハンドラからは非同期シグナルセーフな関数ﾆだけを呼ばなければならない。<br>

mutexを使うコードにおいて、非同期シグナルセーフな関数を使ったためデッドロックする例。<br>
※mutexの有無に関わらずデッドロックすることはありえる。<br>

最適化問題に関しては下のリンク参考になるだろう。<br>
[UNIX上でのC++ソフトウェア設計の定石 (2)](http://d.hatena.ne.jp/yupo5656/20040712/p2)<br>

### 【sigwaitを使い、シグナル処理スレッドを使う】
非同期に発生するシグナルに対応するハンドルを書くのは難しい。<br>
ただし、sigwaitという関数を利用すると、安全に、簡単に対応できる。<br>

シグナルハンドラの問題点を解消するために、<br>
適当なコードを書いてみる。<br>

方針<br>
● sigaction関数は使わない。<br>
● メインスレッド、その他サブスレッドすべてで特定のシグナル(ここではSIGINT)をマスク(ブロック)する。<br>
● 別途、特定のシグナルを受け持つ専用のスレッドを生成する。<br>
● その専用スレッドでもシグナルはマスクするのだが、シグナルの到着はsigwaitを利用して、その瞬間だけマスクを解除させる。<br>
<br>
sigwait以降の処理では、非同期シグナルセーフではない関数を呼び出しても問題が発生しないというのが一番のメリットであろう。<br>
ただし、スレッドを使うので、スレッドセーフであることには気をつけなくてはならない。<br>

<pre>
#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;
#include &lt;unistd.h&gt;
#include &lt;pthread.h&gt;
#include &lt;signal.h&gt;

void *signal_thread(void *arg);

int main() {
  // メインスレッド内で特定のシグナルをマスク(ブロック)
  sigset_t block_mask;
  sigemptyset(&block_mask);
  sigaddset(&block_mask, SIGINT);
  sigprocmask(SIG_SETMASK, &block_mask, NULL);

  // SIGINT処理専用スレッドを生成
  pthread_t pt;
  pthread_create(&pt, NULL, &signal_thread, NULL);
  pthread_detach(pt);

  // 実処理
  int cnt = 0;
  int max_cnt = 10;
  for(cnt; cnt < max_cnt; cnt++) {
    sleep(1) ;
    printf("cnt : %d\n", cnt );
  }
  return 0;
}


void *signal_thread(void *arg) {
  int sig;

  // 本スレッド内でマスク(ブロック)
  sigset_t block_mask;
  sigemptyset(&block_mask);
  sigaddset(&block_mask, SIGINT);
  // sigprocmask(SIG_SETMASK, &block_mask, NULL);

  while(1) {
    if(sigwait(&block_mask, &sig) == 0) {
      switch(sig) {
      case SIGINT:
        printf("SIGINT[%d] was called\n", sig );
        break;
      default:
        printf( "It's not SIGINT signal\n" );
        continue;
        break;
      }
    }
  }

  printf( "sigwait end!!\n" );
  return NULL;
}
</pre>

【触れなかった課題】
sigwaitを使いコードを書き直す際に、最初に記載したreadしてwriteさせていたものではなく、別のサンプルコードを利用したのには理由がある。<br>

実はread、writeコードにはsigwaitでは解決できない問題が残っているのである。<br>

read後はそれを必ずwriteするために、SIGINTをブロックする仕様だった。<br>
しかし、write処理前のシグナルマスクを設定する前に、シグナルがきたらハンドラが起動してしまう。<br>
サンプル例ではハンドラが起動しても何もしないので影響はないが。<br>

ブロックするシステムコールの直前なり直後のシグナル処理は難しいのである。<br>
解決手段としてsigsafeを利用することができるようである。<br>

本件で扱った内容と、sigsafeに関してはbinary hacksが参考になる。<br>
