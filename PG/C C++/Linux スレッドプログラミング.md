[GNU/Linux でのスレッドプログラミング](http://www.tsoftware.jp/nptl/ "GNU/Linux でのスレッドプログラミング")

<pre>
GNU/Linux でのスレッドプログラミング
NPTL (Native POSIX Thread Library) Programming.

以前から GNU/Linux でスレッドプログラミングをするための簡単なガイドを書きたいと思っていました。今更スレッドプログラミングについて書いても目新しいものになるとは思えないのですが、初めて NPTL (Native POSIX Thread Library) を使ったプログラムをするという方には、もしかしたら役に立つ情報かもしれません。はじめは怖々小さなプログラムを書いて動かしてみる。思ったより簡単なことに驚かれるでしょう。スレッドプログラミングと言っても難しいことはなにもありません。ライブラリが沢山仕事をしてくるおかげで快適に使うことができます。

本文中では glibc のバージョンによる違いについても触れます。参照したバージョンは glibc 2.3.4 (20041219) と glibc 2.5.1 (20070731) です。一部 glibc-2.6、glibc-2.7、glibc-2.8 についても触れます。

さて、まずは習うより慣れろですね。早速、簡単なプログラムを書いてみましょう。

初めてのスレッドプログラム
初めてのプログラムですので Hello World! と表示するスレッドプログラムを作ってみましょう。複数のスレッドを起動しそれぞれが一文字づつ担当します。最初は 'H' の文字を表示するスレッド、次に 'e' の文字を表示するスレッドという具合ですね。早速サンプルプログラムを見てみましょう。

/*****************************************************************************

  FILE NAME   : thread_test.c

  PROJECT     : 

  DESCRIPTION : A first thread program is to print out 'Hello World'.

  ----------------------------------------------------------------------------
  RELEASE NOTE : 

   DATE          REV    REMARK
  ============= ====== =======================================================


 *****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <semaphore.h>
#include <pthread.h>



/* --------------------------------- DEFS ---------------------------------- */

struct thdata {
    char                letter;
    pthread_t           th;
    sem_t               sync;
    sem_t               start;
};

/* ------------------------------------------------------------------------- */



/* ------------------------------- FUNCTIONS ------------------------------- */


/*****************************************************************************

 FUNCTION    : void *thread_function (void *thdata)

 DESCRIPTION : Thread function.

               * Argument
                 void *

               * Return
                 void *

 ATTENTION   :

 *****************************************************************************/
void *thread_function(void *thdata)
{

    struct thdata       *priv = (struct thdata *)thdata;


    /* sync */
    sem_post(&priv->sync);
    sem_wait(&priv->start);

    /* write my letter */
    putchar(priv->letter);

    /* sync */
    sem_post(&priv->sync);

    /* done */
    return (void *) NULL;

}



/* Main 

 *****************************************************************************/
int main (void)
{

    int                 rtn, i;
    struct thdata       *thdata;
    char                hello[128] = "Hello World!\n";


    /* initialize thread data */
    thdata = calloc(sizeof(struct thdata), strlen(hello));
    if (thdata == NULL) {
        perror("calloc()");
        exit(EXIT_FAILURE);
    }

    for (i = 0; i < strlen(hello); i++) {
        thdata[i].letter = hello[i];
        sem_init(&thdata[i].sync, 0, 0);
        sem_init(&thdata[i].start, 0, 0);
        rtn = pthread_create(&thdata[i].th, NULL, thread_function, (void *) (&thdata[i]));
        if (rtn != 0) {
            fprintf(stderr, "pthread_create() #%0d failed for %d.", i, rtn);
            exit(EXIT_FAILURE);
        }
    }


    /* synchronization */
    for (i = 0; i < strlen(hello); i++) {
        sem_wait(&thdata[i].sync);
    }

    /* let thread write his letter */
    for (i = 0; i < strlen(hello); i++) {
        sem_post(&thdata[i].start);
        sem_wait(&thdata[i].sync);
    }

    /* join */
    for (i = 0; i < strlen(hello); i++) {
        pthread_join(thdata[i].th, NULL);
        sem_destroy(&thdata[i].sync);
        sem_destroy(&thdata[i].start);
    }


    free(thdata);
    exit(EXIT_SUCCESS);

}
/* ------------------------------------------------------------------------- */
		
Hello World! と表示するだけなのに、なぜこんなに長くなるのでしょう。無理に長く書いたのでしょうか。いいえ、そんなことはありませんよ。多くのプラットフェームで Hello World! と表示させるには、このように書いた方が良いと思います。それではプログラムの説明をしましょう。

ライブラリ
POSIX スレッドを使うプログラムでは pthread.h をインクルードします。このプログラムでは POSIX セマフォを使うので semaphore.h もインクルードします。これは伝統的に使われてきた System V IPC のセマフォとは違うものです。POSIX セマフォにはメモリベースとシステムベースの二種類あり、前者を名前無しセマフォ、後者を名前付きセマフォと言います。スレッドは同じメモリ空間を共有しますので名前無しセマフォを使うことができます (プロセス間でも名前無しセマフォを使うことができます。参考 - セマフォのプロセス共有属性)

コンパイル時にリンカオプションで -lpthread を指定します。

$ gcc thread_test.c -o hello -lpthread
$ ./hello
Hello World!
		
スレッドの生成
スレッドの生成には pthread_create() という関数を使います。この関数に pthread_t 型のスレッド変数、属性変数、スレッド関数と引数、それぞれのポインタを渡せば、スレッドが生成されます。

サンプルプログラムではスレッド関数が次のシグネチャで定義されています。

void *thread_function(void *thdata);
		
thread_function() をスレッドとして起動するのは次の部分です。

rtn = pthread_create(&thdata[i].th, NULL, thread_function, (void *) (&thdata[i]));
		
返値が 0 の場合は成功です。失敗した場合は直接エラーコードが返されます。

ここで注意しなければいけないことがあります。POSIX では生成と起動が区別されています。pthread_create() はスレッドを生成しますが、復帰時にスレッドが起動済みであることは保証していません。それでは pthread_create() は何をしているのでしょう。それを知るには glibc と Linux カーネルでどのように実装されているのかを調べる必要があります。後ほどそのあたりも少し覗いてみることにしましょう。

◆

pthread_create() が成功したからと言って、そのスレッドが起動済みであるとは限りません。つまり 'e' を表示するスレッドより前に 'H' を表示するスレッドを pthread_create() しても、'e' のスレッドが追い越さない保証はないのです。百歩譲って pthread_create() から復帰時にスレッドが起動しているとしましょう。今度は大丈夫でしょうか？残念ながらこれでもまだ完全ではありません。実際に 'H' の文字を表示しているのは putchar() 関数です。スレッドが起動し putchar() が標準出力に 'H' を印字するまでの間に、スレッドがコンテキストスイッチしてしまう可能性があります。

スレッドの優先度や実行時間などいろいろと考えることはありそうですが、結局は同期をとらないと 'Hello World!' の順番で文字が表示される確信を持てないのです。

スレッド間の同期
複数のスレッドが協調して仕事をする時には、お互いの呼吸を合わせる必要があります。人も同じですよね。重い物を一緒に運ぶ時は声を掛け合って、力を入れるタイミングを合わせます。めいめいがかってに持ち上げたのでは運ぶことができません。このようにお互いが協調して処理を行うことを同期を取ると言います。Hello World! の同期には名前無しセマフォを使うと良いでしょう。POSIX セマフォには次のようなインターフェースがあります。

int sem_init(sem_t *sem, int pshared, unsigned int value);
名前無しセマフォを初期化します。全てのスレッドが参照可能なメモリ領域に確保します (大域変数やヒープなど) pshared を 0 以外にした場合はプロセスで共有可能なセマフォとなります。プロセスで共有するセマフォは共有メモリ領域に配置しなければいけません (sem_init 内部では pshared を見ていません。引数で渡したセマフォオブジェクトが置かれたメモリが、プロセス内のメモリ空間か共有メモリかによってその性質が決まります)
int sem_post(sem_t *sem);
sem に 1 加算します。
int sem_wait(sem_t *sem);
sem > 0 なら sem から 1 減算します。sem が 0 なら呼び出したスレッドはブロックされます。
int sem_destroy(sem_t *sem);
セマフォオブジェクトを破壊します。
sem_init() はセマフォの初期化です。sem_wait() で相方からのかけ声を待ちます。相方は sem_post() でかけ声を送ります。Hello World! では main() はまず sem_wait(&sync) しています。ここでスレッドが起動されるのを待っているのです。スレッド側は sem_post(&sync) した後、こんどは main() からのかけ声を sem_wait(&start) で待ちます。main() は Hello World! の順番で sem_post(&start) - sem_wait(&sync) を繰り返します。

このように同期を取ることによってプラットフォーム毎の微妙なスケジューリングタイミングの違いによる誤動作を防ぎ、確実に Hello World! と表示を行うことができます。

◆

スレッド間の通信はどのように実装すれば良いのでしょうか。スレッドは同じメモリ空間を共有していますので、アドレスによりデータの受け渡しができます。通信で必要なのはデータの受け渡しと手順ですので、あとは手順があれば通信できますね。この手順の部分をセマフォで実現できます。スレッド A が前行程、スレッド B が後工程を担当するデータ処理があったとします。この場合スレッド B は sem_wait() で A の行程が終わるのを待ち、A は処理したデータを共通の領域に展開した後で sem_post() し、B へデータを引き継ぐといった具合です。

どのような場合でも名前無しセマフォが良いとは限りません。他の同期操作 (同期プリミティブ) もしくは POSIX メッセージキューを使用した方が良い場合もあります。スレッド間でどのような通信を行うのかによって最適な方法は変わります。

スレッドセーフ
スレッドプログラミングで気をつけなければいけないことがもう一つあります。ライブラリ関数の中には複数のスレッドコンテキストから呼ばれることを想定していないものがあります。例えば rand() は乱数を計算するための状態を大域変数に保持します。rand() から復帰する前に別のスレッドが入ってきた場合の動作は保証されません。

POSIX では スレッドセーフにしなくても良いとされている関数が規定されています。基本的にこれらの関数をスレッドコンテキストで使用することは推奨されません。

プログラムではライブラリ関数の putchar() を使用しています。putchar() はスレッドセーフな関数です。一方、目に見える動作は同じの putchar_unlocked() はスレッドセーフとしなくても良いとされています。当然スレッドコンテキストからは putchar() を使用すべきなのですが、両者の違いは何なのでしょうか。glibc 2.3.4 では次のように実装されています (libio/putchar.c、libio/putchar_u.c)


int
putchar (c)
     int c;
{
  int result;
  _IO_acquire_lock (_IO_stdout);
  result = _IO_putc_unlocked (c, _IO_stdout);
  _IO_release_lock (_IO_stdout);
  return result;
}


int
putchar_unlocked (c)
     int c;
{
  CHECK_FILE (_IO_stdout, EOF);
  return _IO_putc_unlocked (c, _IO_stdout);
}

		
最終的に _IO_putc_unlocked () を呼び出すのは同じなのですが、putchar() の方は呼び出す部分が _IO_acquire_lock() と _IO_release_lock() で一スレッドしか実行できないよう保護されています (これをシリアライズといいます) このようにして、複数のスレッドからの呼び出しがあっても、文字を出力する部分で想定しない動作が起きないよう作られています。

まとめ
POSIX スレッドを使うプログラムでは pthread.h をインクルードします。
gcc のリンカオプションで -lpthread を指定します。
ある処理について特定のスレッドの実行を先行させる必要がある時は同期を取ります。
ライブラリ関数がスレッドセーフかどうかを確認します。
タスクの階層
POSIX ではプロセスとスレッドを次のように定義しています。図 1 はこの関係を図示したものです。

プロセス
一つもしくはそれ以上のスレッドが実行されるアドレス空間とそれらのスレッドが必要とするシステムリソースです。
スレッド
プロセス内の単独の実行フローです。それぞれのスレッドは thread ID、スケジュール優先度、スケジュールポリシー、errno、スレッド特有のキーや値、実行フロー制御に必要なシステムリソースを持ちます。

図 1 プロセスとスレッドの関係

プロセス内のスレッドは同じメモリ空間を共有します。アドレスが分かれば他のスレッドが確保したヒープや自動変数にアクセスできます。またスレッドはプロセスが持つ、プロセス ID、親プロセス ID、プロセスグループ ID、ユーザ ID、グループ ID、カレントディレクトリ位置、ファイルデスクリプタなどのシステムリソースも共有します。

fork() により子プロセスが生成されると、子プロセスでは親プロセスと同じプログラムコードが実行されますが、ヒープやスタックなどのデータは親からコピーされた別のインスタンスが用意されます。以降、子プロセス側でのデータ変更が親から見えることはありません。

スレッドはプロセス内で生成される単独の実行フローです。スレッド生成時には fork() のようにヒープやスタックのインスタンスが別に用意されることはなく、そのプロセス内のリソースをそのまま利用できる状態で起動されます。

古いバージョンの Linux カーネルではマルチスレッドがサポートされておらず、ライブラリによりユーザモードで POSIX スレッドが実装されていました。つまりカーネルからはマルチスレッドプログラムもただのプロセスとしか見えていなかったのです。このような実装では、あるスレッドがシステムコールによりブロックされると全てのスレッドが停止してしまい、満足のいくアプリケーションを作ることはできません。ライブラリとカーネルの両方が対応して初めて、本当の意味での POSIX スレッドサポートと言えます。

Linux カーネルはスレッドの実装に LWP (Light Weight Process) を使用しています。LWP はスレッドに一対一に対応し、複数の LWP がアドレス空間やファイルデスクリプタを共有できます。リソースが共有されている場合、他の LWP が行ったリソース変更は透過的に見えます。LWP はそれぞれ単独にスケジュール優先度とスケジュールポリシーを持つことができます。これはスケジュールがプロセス単位ではなく、個々のスレッド毎に行われることを意味します。一つのスレッドがブロックされても、他のスレッドが停止することはありません。

◆

プロセスはカーネル上でスレッドグループとして表現されています。例えば getpid() について見てみましょう。POSIX ではスレッドはプロセス ID を共有することになっていました。従ってどのスレッドで getpid() しても同じ値が返るように実装されているはずです。実際はどのようになっているのでしょう。以下はカーネル 2.6.21.3 のコードです (kernel/timer.c)

/**
 * sys_getpid - return the thread group id of the current process
 *
 * Note, despite the name, this returns the tgid not the pid.  The tgid and
 * the pid are identical unless CLONE_THREAD was specified on clone() in
 * which case the tgid is the same in all threads of the same group.
 *
 * This is SMP safe as current->tgid does not change.
 */
asmlinkage long sys_getpid(void)
{
    return current->tgid;
}
		
戻り値の tgid はスレッドグループの識別子です。プロセスがスレッドグループというセマンティクスで処理されているのが分かりますね。

fork()
スレッドから fork() を呼ぶとどうなるのでしょうか。これも POSIX により動作が規定されています。スレッドコンテキストから fork() を呼んだ場合は、fork() を呼んだスレッドとプロセスメモリ空間、ファイルデスクプリタがコピーされます。他の実行中スレッドのコピーは作成されません。

例えば、プロセス上で A と B 二つのスレッドが実行中だったとします。スレッド B が fork() を呼んだ場合、スレッド A のスタックも含めて、プロセス上のメモリは全てコピーされます。しかし、生成された子プロセス上で実行されるのはスレッド B だけになります。

この時に注意しなければいけないのは、mutex (参考 - mutex) などの同期オブジェクトがコピーされた瞬間の状態を保持してしまうことです。たとえば B が fork() した時に A がある mutex をロックしていたとします。子プロセスのメモリ上では mutex がロックされた状態でコピーされるのですが、子プロセス上にスレッド A がいないので、永遠にロックが解除されません。スレッド B がそれをロックしようとするとデッドロックしてしまいます。

このようなデッドロックを避けるために pthread_atfork() というインターフェースが用意されています。pthread_atfork() を使うと fork() 実時時に呼び出されるハンドラを親子両方のプロセスに対して定義できます。

同期プリミティブ
初めてのプログラムではセマフォを使ってスレッド間の同期を取る例を見てみました。GNU/Linux にはセマフォ以外にもスレッド間の同期を取るための操作がいくつか用意されています。

ミューテックス (mutex)
複数スレッドからの共有データへのアクセスをシリアライズするための同期オブジェクトです。あるスレッドが獲得するとそのスレッドが離すまで他のスレッドは獲得できません。この文書では mutex を獲得 (have acquired)、またはロック (lock) すると表現します。どちらも同じ意味だとご理解ください。
セマフォ (semaphore)
初めてのスレッドプログラムで説明しました。POSIX では同期プリミティブの最小単位と定義されていますが実装によっては mutex の方が軽量です。
読み取り/書き込みロック (read-write lock)
読み取り/書き込みロックは共有リソースに対して、複数のスレッドからの読み取りもしくは排他的な書き込みロックを行うための操作です。あるスレッドによって読み取りロックされている時には、別のスレッドが読み取りロックすることはできますが、排他書き込みロックはできません。排他書き込みロックされている時には、読み取り、排他書き込みロック共にできません。
バリア (barrier)
複数のスレッドをあるタスクの完了に同期させたい時に使用する同期オブジェクトです。初めてのスレッドプログラムではスレッド関数の起動をセマフォにより同期させました。このような場合はバリアを使用することもできます。pthread_barrier_wait() は pthread_barrier_init() で指定した数のスレッドが pthread_barrier_wait() を呼ぶまでブロックされます。
条件変数
条件変数はある条件が真になるまで待つ方法を提供する同期オブジェクトです。条件をチェックする前に、関連付けられた mutex を獲得します。条件が真でなければ pthread_cond_wait() 呼び出せば、mutex のロック解除とスレッドのブロックを不可分に処理してくれます。ブロックされたスレッドは他のスレッドによりその条件が変更されるまで眠り続けます。
スピンロック
スピンロックは相互排他するための同期オブジェクトです。mutex との違いはロック待ちに futex() の FUTEX_WAIT を使わないことです。スピンロックはループにより繰り返しロックを試みます。マルチコア・プロセッサ環境で、相互排他する区間の処理時間が短い場合はmutex より効率良くシリアライズできます。
mutex (相互排他 : MUTual EXclusion)
mutex はその名前が示す通り排他制御を行うための同期オブジェクトです。pthread_mutex_lock() により mutex オブジェクトをロックすると、pthread_mutex_unlock() するまでは、他のスレッドはその mutex をロックできません。例えば mutex をロックする関数 pthread_mutex_lock() を呼び出すとブロックされます。

排他制御はどのような場合に必要となるのでしょうか。まずは操作が不可分 (atomic) であるということについて説明します。

不可分操作
図 2 のアプリケーション例をご覧ください。Thread A と Thread B は IPv4 アドレスを格納するための無符号 32 ビット整数変数 (last_address) を共有しています。Thread A と Thread B はそれぞれ一つの TCP コネクションを担当しています。そして、外部からパケットを受信する度に last_address に相手ホストの IP アドレスを書き込みます。このアプリケーション例では last_address に最後にパケットを受信した相手ホストの IP アドレスが書かれることになります。


図 2 アプリケーション例 (1)

さて、このアプリケーション例の場合、排他制御は必要でしょうか？

結論から言うとマシンアーキテクチャによって異なります。簡単に書くと 32 ビット値をアセンブラ 1 命令でメモリに書き込めない場合は排他制御が必要です。さらにメモリとデータバスを共有する SMP マシンの場合、アセンブラ 1 命令の操作であっても排他制御が必要となる場合があります。

ここで考慮しなければいけないのは、対象となる操作が不可分 (atomic) に実行できるかどうかです。不可分に行われる操作であれば mutex を使うまでもなく操作はシリアライズされます。図 2 のアプリケーション例では last_address への 32 ビット値の書き込みでした。x86 (IA-32 アーキテクチャ) の場合については、32 ビット境界にアライメントが調整されたアドレスへの書き込みはアトミックに行われることが保証されています (インテル、『ソフトウェアデベロッパーズマニュアル下巻』) つまり図 2 の場合 last_address のアドレスが 32 ビット境界にアライメント調整されているのであれば排他制御は不要です。これを保証付きアトミック操作といい、命令に LOCK プレフィックスを付けなくてもアトミックに実行されることが保証されています。x86 アーキテクチャでは次のアトミック操作がサポートされています。

保証付きアトミック操作 
1 バイトの読み取りまたは書き込み。16 ビット境界にアライメントが調整された 1 ワードの読み取りまたは書き込み。32 ビット境界にアライメントが調整された1 ダブルワードの読み取りまたは書き込み。

Pentium 以降のプロセッサでは 64 ビット境界にアライメントが調整された 1 クワッドワードの読み取りまたは書き込み。P6 以降のプロセッサでは、アライメントが調整されていなくてもキャッシュ上にある 16、32、64 ビットのアクセスもアトミックに実行されることが保証されています (Intel、"Software Developer's Mannual", Volume 3A)
バスロック
命令に LOCK プレフィックスを付けると、プロセッサは LOCK# 信号をアサートします。この出力信号がアサートされている間は、他のプロセッサやバス・エージェントがバス制御要求を出しても無視されます。
自動バスロック
明示的に LOCK しなくてもいくつかのクリティカルなメモリ操作を行う命令実行時には LOCK# がアサートされ、アトミック操作が保証されます。
◆

もう一つアプリケーション例を考えてみましょう。

図 3 で Thread A と Thread B はヒープに展開したテーブル上のレコードを更新します。Thread C はそのレコードを読み取ります。図 2 と同じくそれぞれのスレッドは TCP の接続を受け持ち、相手ホストからの指示をきっかけにして処理を行います。今 Thread A も Thread B も record[m] の更新をするよう相手ホストから指示を受けたとしましょう。Thread B の方が若干早かったため A に先んじてレコードの更新を開始します。


図 3 アプリケーション例 (2)

マシンは二つの CPU が搭載されてて、同時に二つのスレッドを実行できます。先に Thread B が id を変更しました。そして Thread B が name に文字列をコピーする途中で、Thread A が更新を開始します。ところが、Thread A は id を更新した直後に Thread C へコンテキストスイッチしてしまいました。Thread C はホストの指示によりレコードを読み取ります。読み取ったレコードは id が Thread A によって更新された値、id 以外は Thread B によって更新された値であり、データの一貫性が壊れてしまっています。

このアプリケーションから見ると id、name、ts は一揃いのデータであり、これらの更新と参照は不可分の処理です。ところがマシンは、これらのデータを不可分に変更することはできません。このような場合に mutex で排他制御を行い、アプリケーションの中ではこれらの更新、参照が同時に複数のスレッドから行われないようにします。

例えば更新は次のようなコードになるでしょう。読み取りも更新されないようロックしなければいけません。

pthread_mutex_lock(&lock);
    record[m].id = newid;
    strncpy(&record[m].name, new_name, MAXLEN);
    clock_gettime(CLOCK_REALTIME, &record[m].ts);
pthread_mutex_unlock(&lock);
		
実際のアプリケーションでは、複数のスレッドからの同時読み取りが問題とならない場合があります。この場合には読み取り/書き込みロックにより排他すると並列性がより高くなります。

mutex の実装
glibc 2.3.4 を題材に mutex の実装について簡単に説明します。mutex のロックはメモリを不可分にテスト＆セットする必要があるため、プロセッサに大きく依存します。また、ロック待ちはカーネルスケジューラの力を借りて行います。まず pthread_mutex_t の定義から見てみましょう (nptl/sysdeps/unix/sysv/linux/i386/bits/pthreadtypes.h)

/* Data structures for mutex handling.  The structure of the attribute
   type is not exposed on purpose.  */
typedef union
{
  struct
  {
    int __lock;
    unsigned int __count;
    int __owner;
    /* KIND must stay at this position in the structure to maintain
       binary compatibility.  */
    int __kind;
    unsigned int __nusers;
    int __spins;
  } __data;
  char __size[__SIZEOF_PTHREAD_MUTEX_T];
  long int __align;
} pthread_mutex_t;
		
pthread_mutex_t の定義ファイルはプロセッサ毎に分かれています。これは x86 の場合です。共用体で定義されていますが、実際の操作に使われるのは __data です。__lock はロック操作に使用する変数です。__count は mutex が PTHREAD_MUTEX_RECURSIVE_NP の時の再帰的なロック回数です。__owner はロックしているスレッドの ID です。__kind は mutex の属性のうちタイプ (type) と呼ばれるものです。glibc 2.3 では POSIX 標準で規定されているタイプのうち PTHREAD_MUTEX_FAST_NP、PTHREAD_MUTEX_ERRORCHECK_NP、PTHREAD_MUTEX_RECURSIVE_NP をサポートしています。

mutex のタイプ	説明
PTHREAD_MUTEX_FAST_NP

操作は軽量ですが、自身がロックしている mutex をさらにロックしようとするとデッドロックします。

PTHREAD_MUTEX_ERRORCHECK_NP

自身がロックしている mutex をさらにロックしようとするとエラー終了します (EDEADLK)

PTHREAD_MUTEX_RECURSIVE_NP

自身がロックしている mutex をさらにロックしようとすると、pthread_mutex_lock() は成功します。ロックした回数と同じだけアンロックしないとロックは解除されません。

__spins は LinuxThread との互換性のために用意された変数で、POSIX 非標準の PTHREAD_MUTEX_ADAPTIVE_NP が指定された時に、スピンロックのビジーウェイト回数を保持するために使います。

◆

初期化を行う pthread_mutex_init() の実装を見てみましょう (nptl/pthread_mutex_init.c)

static const struct pthread_mutexattr default_attr =
  {
    /* Default is a normal mutex, not shared between processes.  */
    .mutexkind = PTHREAD_MUTEX_NORMAL
  };


int
__pthread_mutex_init (mutex, mutexattr)
     pthread_mutex_t *mutex;
     const pthread_mutexattr_t *mutexattr;
{
  const struct pthread_mutexattr *imutexattr;

  assert (sizeof (pthread_mutex_t) <= __SIZEOF_PTHREAD_MUTEX_T);

  imutexattr = (const struct pthread_mutexattr *) mutexattr ?: &default_attr;

  /* Clear the whole variable.  */
  memset (mutex, '\0', __SIZEOF_PTHREAD_MUTEX_T);

  /* Copy the values from the attribute.  */
  mutex->__data.__kind = imutexattr->mutexkind & ~0x80000000;

  /* Default values: mutex not used yet.  */
  // mutex->__count  = 0;        already done by memset
  // mutex->__owner  = 0;        already done by memset
  // mutex->__nusers = 0;        already done by memset
  // mutex->__spins  = 0;        already done by memset

  return 0;
}
		
glibc-2.3 ではタイプ属性 (type) しか見ていません。__kind にこの属性が設定されます。glibc-2.5 ではプロトコル (protocol)、優先度シーリング (priority ceiling) 属性の設定も行われます (__kind をビット単位で分割して使用)

◆

mutex のロックはどのように行われるのでしょうか。さらに実装を見てみましょう (nptl/pthread_mutex_lock.c)

int
__pthread_mutex_lock (mutex)
     pthread_mutex_t *mutex;
{
  assert (sizeof (mutex->__size) >= sizeof (mutex->__data));

  pid_t id = THREAD_GETMEM (THREAD_SELF, tid);

  switch (__builtin_expect (mutex->__data.__kind, PTHREAD_MUTEX_TIMED_NP))
    {
      /* Recursive mutex.  */
    case PTHREAD_MUTEX_RECURSIVE_NP:
      /* Check whether we already hold the mutex.  */
      if (mutex->__data.__owner == id)
        {
          /* Just bump the counter.  */
          if (__builtin_expect (mutex->__data.__count + 1 == 0, 0))
            /* Overflow of the counter.  */
            return EAGAIN;

          ++mutex->__data.__count;

          return 0;
        }

      /* We have to get the mutex.  */
      LLL_MUTEX_LOCK (mutex->__data.__lock);

      mutex->__data.__count = 1;
      break;
		
PTHREAD_MUTEX_RECURSIVE_NP の場合は自身がロックしている mutex を再ロックすることが可能でした。__owner == id であれば、自身がロックしているので __count をインクリメントします。__count + 1 == 0 は __count のオーバフロー判定をしています。再ロックできるのはその型 (ここでは 32bit 無符号整数) の最大値回数までとなります。とは言っても __count + 1 == 0 が真となることはほとんどありません。プリフェッチキューに先読みした命令が無駄にならないよう最適化させるため、__builtin_expect() マクロでコンパイラにヒントを与えています。

再ロックは __count をインクリメントするだけで実際のロックは行われません。未ロックの場合は実際のロックを行う LLL_MUTEX_LOCK() が呼び出されます。

      /* Error checking mutex.  */
    case PTHREAD_MUTEX_ERRORCHECK_NP:
      /* Check whether we already hold the mutex.  */
      if (mutex->__data.__owner == id)
        return EDEADLK;

      /* FALLTHROUGH */

    default:
      /* Correct code cannot set any other type.  */
    case PTHREAD_MUTEX_TIMED_NP:
    simple:
      /* Normal mutex.  */
      LLL_MUTEX_LOCK (mutex->__data.__lock);
      break;
		
PTHREAD_MUTEX_ERRORCHECK_NP の場合、__owner == id で自身がロックしているかどうかを確認します。ロックしている時はエラー終了します (EDEADLK) ロックしていない時は通常の処理 (PTHREAD_MUTEX_FAST_NP) に合流します。

PTHREAD_MUTEX_FAST_NP は無条件に LLL_MUTEX_LOCK() を呼び出します。エラーチェックを行わない分軽いのですが、デッドロックの危険性があります。

    case PTHREAD_MUTEX_ADAPTIVE_NP:
      if (! __is_smp)
        goto simple;

      if (LLL_MUTEX_TRYLOCK (mutex->__data.__lock) != 0)
        {
          int cnt = 0;
          int max_cnt = MIN (MAX_ADAPTIVE_COUNT,
                             mutex->__data.__spins * 2 + 10);
          do
            {
              if (cnt++ >= max_cnt)
                {
                  LLL_MUTEX_LOCK (mutex->__data.__lock);
                  break;
                }

#ifdef BUSY_WAIT_NOP
              BUSY_WAIT_NOP;
#endif
            }
          while (LLL_MUTEX_TRYLOCK (mutex->__data.__lock) != 0);

          mutex->__data.__spins += (cnt - mutex->__data.__spins) / 8;
        }
      break;
    }
		
PTHREAD_MUTEX_ADAPTIVE_NP の部分は LinuxThread との互換性を確保するためのコードです。

  /* Record the ownership.  */
  assert (mutex->__data.__owner == 0);
  mutex->__data.__owner = id;
#ifndef NO_INCR
  ++mutex->__data.__nusers;
#endif

  return 0;
}
		
最後に __owner をセットして正常終了します。ロックと __owner のセットが不可分に行われなくても大丈夫なのか心配になる方がおられるかもしれません。でも大丈夫です。LLL_MUTEX_LOCK() がロック済みですので、他のスレッドがここへ割り込むことはありません。

次に LLL_MUTEX_LOCK() の中を見てみます。実際はアーキテクチャ毎に最適化されたコードが使用されます。例えば x86 の場合は nptl/sysdeps/unix/sysv/linux/i386/lowlevellock.h です。ここでは C 言語で書かれた nptl/sysdeps/generic/lowlevellock.h コードを引用します。

static inline void
__generic_mutex_lock (int *mutex)
{
  unsigned int v;

  /* Bit 31 was clear, we got the mutex.  (this is the fastpath).  */
  if (atomic_bit_test_set (mutex, 31) == 0)
    return;
		
引数の int *mutex には __lock が渡されます。*mutex は 31 ビット目がセットされているとロックされていることになります。しかし単純に以下のような操作では正しく動作しません。

if (*mutex & 0x80000000)
	*mutex |= 0x80000000;
		
ビットの確認とセットが不可分に実行されないと、別のスレッドが割り込むことがあるからです。そのため、ここでは atomic_bit_test_set() というビットテストとセットを不可分に行う操作が使われています。これは完全にアーキテクチャ依存で x86 の場合は BTS 命令に LOCK プレフィックスを付けたコードが sysdeps/i386/i486/bits/atomic.h に定義されています。

pthread_mutex_lock() はロックできるとただちに戻ります。ロックできなかった場合はロックしているスレッドがそれを pthread_mutex_unlock() するまでブロックされます。

  atomic_increment (mutex);

  while (1)
    {
      if (atomic_bit_test_set (mutex, 31) == 0)
        {
          atomic_decrement (mutex);
          return;
        }

      /* We have to wait now. First make sure the futex value we are
         monitoring is truly negative (i.e. locked). */
      v = *mutex;
      if (v <= 0)
        continue;

      lll_futex_wait (mutex, v);
    }
}
		
while(1) の中で lll_futex_wait() により mutex の値が変わるまで待機します。先に pthread_mutex_lock() を呼んだからといって、後から呼んだスレッドに先んじてロックできるとは限りません。mutex のロックが解除されても lll_futex_wait() からの復帰から atomic_bit_test_set() までが不可分に実行されないからです。

lll_futex_wait() は futex() システムコールにより実装されています。待機中のスレッドを起こす時にもこのシステムコールが使用されます。

◆

mutex のロック処理が分かりやすく書かれているのでこのコードを引用しましたが、実際には違うコードが動くことになります。nptl/sysdeps/unix/sysv/linux/i386/lowlevellock.h に定義された x86 用のアセンブラコードでは、*mutex が 0 であればフリー、1 であればロック中、1 より大きければロック待ちスレッドがいるというセマンティクスで処理されています。以下は glibc-2.5.1 のコードです。

#define lll_mutex_lock(futex) \
  (void) ({ int ignore1, ignore2;                                             \
            __asm __volatile (LOCK_INSTR "cmpxchgl %1, %2\n\t"                \
            "jnz _L_mutex_lock_%=\n\t"                      \
            ".subsection 1\n\t"                             \
            ".type _L_mutex_lock_%=,@function\n"            \
            "_L_mutex_lock_%=:\n"                           \
            "1:\tleal %2, %%ecx\n"                          \
            "2:\tcall __lll_mutex_lock_wait\n"              \
            "3:\tjmp 18f\n"                                 \
            "4:\t.size _L_mutex_lock_%=, 4b-1b\n\t"         \
            ".previous\n"                                   \
            LLL_STUB_UNWIND_INFO_3                          \
            "18:"                                           \
            : "=a" (ignore1), "=c" (ignore2), "=m" (futex)  \
            : "0" (0), "1" (1), "m" (futex)                 \
            : "memory"); })
		
このマクロが展開されたアセンブラコードを C 言語風に書くと以下の通りとなります。EAX レジスタと *futex の値を比較し、同じだったら *futex に ECX レジスタの値を書きます。この操作は LOCK プレフィックス付きの CMPXCHG 命令でアトミックに実行されます。EAX != *futex ですでにロックされている時は __lll_mutex_lock_wait() を呼び出してスリープします。

void lll_mutex_lock(int *futex)
{

    int eax = 0;
    int ecx = 1;

    if (eax == *futex) {
        *futex = ecx;
        return;
    } else {
        __lll_mutex_lock_wait(futex, FUTEX_WAIT, 1, NULL, NULL, 0);
    }

}
		
ライブラリを使用するアプリケーションにとっては、ロック変数のセマンティクスがどうであろうと気にする必要はありません。当然のことですが、POSIX で規定されているインターフェースの範囲を超えて、pthread_mutex_t のメンバ変数へアクセスし、内部処理に依存したコードを書くようなことがあってはいけません。

mutex の属性
mutex のタイプとして PTHREAD_MUTEX_FAST_NP、PTHREAD_MUTEX_ERRORCHECK_NP、PTHREAD_MUTEX_RECURSIVE_NP について説明しました。タイプ (type) は mutex の属性の一つです。mutex の属性を設定するには pthread_mutexattr_init() により属性オブジェクト (pthread_mutexattr_t) を初期化し、属性の設定を行った上で pthread_mutex_init() 時にそれを渡します。属性オブジェクトは mutex 初期化時に参照されるだけ永続的には参照されません。したがって、pthread_mutex_init() 後に属性オブジェクトを変更してもすでに初期化を終えた mutex の属性は変わりません。

POSIX ではタイプ (type) 以外にもいくつかの mutex 属性が定義されています。

優先度シーリング (priority ceiling)
優先度シーリングはその mutex をロックしたスレッドに与えられる最低限の優先度です。優先度逆転を防ぐために、優先度シーリングはその mutex をロックするスレッドの中で最も優先度が高いものと同じかそれ以上に設定されるべきです。glibc 2.3 にはこの属性がありません。glibc 2.5 では pthread_mutexattr_setprioceiling() によって設定します。
プロトコル属性 (protocol)
プロトコル属性は mutex の優先度継承方法を指定するための属性です。複数の異なるプロトコル属性を持つ mutex をロックしている場合は、継承した優先度のうち最も高いものがスレッドに設定されます。glibc 2.3 ではサポートされていません。glibc 2.5 では、初期化済みの属性オブジェクトに対して pthread_mutexattr_setprotocol() を実行することにより設定します。
プロトコル属性	説明
PTHREAD_PRIO_NONE

ロックによりスレッドの優先度が変更されることはありません。

PTHREAD_PRIO_INHERIT

ロックしようとしてブロックされたスレッドの優先度がロックしているスレッドより高い場合、ロックしているスレッドはブロックされたスレッドの優先度を引き継ぎます。

PTHREAD_PRIO_PROTECT

ロックすると設定されたシーリング値まで優先度が高められます。

プロセス共有属性 (process shared)
プロセス共有属性は mutex のスコープを決める属性です。POSIX では PTHREAD_PROCESS_SHARED はプロセス間で共有、PTHREAD_PROCESS_PRIVATE はプロセス内からのみアクセスすると定義されています。しかし glibc (2.3.4 / 2.5.1) では pthread_mutex_init() のなかでこの属性を見ていません。プロセス共有型の mutex になるのかどうかは、引数で渡されたメモリ領域の属性により決まります。例えば mmap() で MAP_SHARED を指定した領域に確保するとプロセス間で共有できます。この属性を持つ他の同期オブジェクトでも全く同様です。

2007 年 4 月に Linux Kernel のメーリングリストで興味深い提案が行われました。それまでの futex () システムコールはロック変数として渡されるメモリ領域が共有メモリでも動作するよう実装されていました。
共有メモリはプロセス毎にマップされている仮想アドレスが違います。futex では共有メモリ上にある状態変数を物理アドレスに変換して管理するのですが、対応する物理アドレスがページアウト/ページインの度に変わってしまいます。そこで vcache を利用して管理を行います。
マルチスレッドプログラミングでは多くの場合プライベートですので、そのような実装は冗長と言えます。提案によりプライベートに特化した futex() 処理が 2.6.22 から追加されています。glibc-2.7 において、カーネル側の変更に合わせて低レベルロック関数の実装が変更され、ロック変数がプライベートか共有なのかを futex() に対して明示するようになりました。コア数が多いプロセッサでマルチスレッドプログラミングの性能を追求したい時は glibc-2.7 以降を使うべきかもしれません。
タイプ属性 (type)
先ほど説明した属性です。同じ mutex を再ロックしようとした時の動作を決めます。初期化済みの属性オブジェクトに対して pthread_mutexattr_settype() を実行することにより設定します。
mutex のインターフェース
glibc では次の mutex インターフェースが定義されています。

int pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *mutexattr);
mutex を初期化します。mutexattr により初期化する mutex の属性を指定します。mutexattr が指定されない (NULL) の場合はデフォルトの属性が適用されます。mutex は静的に初期化することもできます。

pthread_mutex_t fastmutex = PTHREAD_MUTEX_INITIALIZER;
PTHREAD_MUTEX_FAST_NP タイプの mutex として静的に初期化します。より正確に言うと、POSIX では PTHREAD_MUTEX_INITIALIZER による初期化を pthread_mutex_init(&fastmutex, NULL) を実行したのと同等であると定義しています。つまりデフォルトの属性で初期化されます。

pthread_mutex_t recmutex = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;
PTHREAD_MUTEX_RECURSIVE_NP タイプの mutex として静的に初期化します。POSIX 非標準です。

pthread_mutex_t errchkmutex = PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP;
PTHREAD_MUTEX_ERRORCHECK_NP タイプの mutex として静的に初期化します。POSIX 非標準です。

ptread_mutex_init() は常に 0 を返します。

もし初期化されていない mutex を pthread_mutex_init() 以外の関数に与えた場合エラー終了します (EINVAL)
int pthread_mutex_lock(pthread_mutex_t *mutex);
mutex をロックします。すでに他のスレッドによってロックされている場合は、ロックが解除されるまでブロックされます。
int pthread_mutex_trylock(pthread_mutex_t *mutex);
mutex のロックを試みます。すでに他のスレッドによってロックされている場合は、関数がただちにエラー終了します (EBUSY)
int pthread_mutex_timedlock(pthread_mutex_t *restrict mutex, const struct timespec *restrict abs_timeout);
mutex をロックしようと試みます。abstime までにロックできなかった時はエラー終了します (ETIMEDOUT) (参考 - POSIX クロックとタイマー)
int pthread_mutex_unlock(pthread_mutex_t *mutex);
mutex のロックを解除します。
int pthread_mutex_destroy(pthread_mutex_t *mutex);
mutex オブジェクトを破壊します。この関数は mutex がどのスレッドからもロックされていないことを確認します。もしロックされていた場合エラー終了します (EBUSY)
int pthread_mutexattr_init(pthread_mutexattr_t *attr);
mutex 属性オブジェクトをデフォルト属性で初期化します。
int pthread_mutexattr_settype(pthread_mutexattr_t *attr, int kind);
int pthread_mutexattr_gettype(const pthread_mutexattr_t *attr, int *kind);
mutex 属性オブジェクトに mutex タイプを設定します。pthread_mutexattr_gettype() は設定された mutex タイプを取得します。
int pthread_mutexattr_setprioceiling(pthread_mutexattr_t *attr, int prioceiling);
int pthread_mutexattr_getprioceiling(const pthread_mutexattr_t *restrict attr, int *restrict prioceiling);
mutex 属性オブジェクトに mutex の Priorit Ceiling 値を設定します。pthread_mutexattr_setprioceiling() は設定されている Priority Ceiling 値を取得します。glibc 2.3 にはこのインターフェースがありません。
int pthread_mutexattr_setprotocol(pthread_mutexattr_t *attr, int protocol);
int pthread_mutexattr_getprotocol(const pthread_mutexattr_t *restrict attr, int *restrict protocol);
mutex 属性オブジェクトに mutex のプロトコル属性を設定します。pthread_mutexattr_getprotocol() は設定されているプロトコル属性を取得します。glibc 2.3 にはこのインターフェースがありません。
int pthread_mutexattr_setpshared(pthread_mutexattr_t *attr, int pshared);
int pthread_mutexattr_getpshared(const pthread_mutexattr_t *restrict attr, int *restrict pshared);
mutex 属性オブジェクトに mutex のプロセス共有属性を設定します。pthread_mutexattr_getpshared() は設定されている属性値を取得します。
POSIX セマフォ
セマフォは不可分操作でインクリメント ( + 1 ) できるカウンタです。また不可分操作で 0 より大きいかどうかを調べた上でデクリメント ( - 1 ) することもできます。デクリメントしようとした時にセマフォが 0 だとブロックされます。0 と 1 の二つの値で使えば mutex のようですが本質的には異なる種類の同期オブジェクトです。mutex と大きく違うのは次の点においてです。

二通り以上の状態を持つ
mutex はロックされている、ロックされていないの二通りの状態を持っていました。セマフォはデクリメント操作がブロックされるかどうかという観点では、0 か 0 より大きい状態の二通りしかありません。しかし、SEM_VALUE_MAX までインクリメントできるという観点では二通り以上の状態を持つと考えられます。
非同期キューへ応用することを考えてみましょう。キューへメッセージを送信する関数ではセマフォをインクリメント、受信する関数ではセマフォをデクリメントすれば、セマフォが持つ値が非同期キューに積まれたメッセージの数と一致することになります。メッセージが無ければセマフォをデクリメントする操作がブロックされますので非同期キューのセマンティクスとも合致します。
操作が排他的ではない
ロックされた mutex はロックしたスレッドだけがロックを解除できます。セマフォは操作するスレッドを排他しません。したがって、シリアライズしなければいけない処理やクリティカルセクションの保護には適しません。
優先度継承されない
操作が排他的ではないことからお分かりかと思います。pthread_mutex_unlock() と違い、どのスレッドが sem_post() (インクリメント) するのか明確ではないので優先度継承はできません。
インクリメント操作
セマフォのインクリメントは sem_post() により行います。glibc 2.5.1 の実装を見てみましょう (セマフォの操作については glibc 2.3 / 2.5 で大きな違いはありません) まずは sem_t 型の定義からです (ptl/sysdeps/unix/sysv/linux/i386/bits/semaphore.h)

#define __SIZEOF_SEM_T  16


/* Value returned if `sem_open' failed.  */
#define SEM_FAILED      ((sem_t *) 0)

/* Maximum value the semaphore can have.  */
#define SEM_VALUE_MAX   (2147483647)

typedef union
{
  char __size[__SIZEOF_SEM_T];
  long int __align;
} sem_t;
		
sem_t の定義はアーキテクチャ依存となっています。これは x86 の実装です。共用体として定義されていますが実際には整数型の変数として初期化されます。最大値の SEM_VALUE_MAX は INT_MAX と同じ値になります。

sem_init() の実装を見てみましょう (nptl/sem_init.c)

/* Semaphore variable structure.  */
struct sem
{
  unsigned int count;
};


int
__new_sem_init (sem, pshared, value)
     sem_t *sem;
     int pshared;
     unsigned int value;
{
  /* Parameter sanity check.  */
  if (__builtin_expect (value > SEM_VALUE_MAX, 0))
    {
      __set_errno (EINVAL);
      return -1;
    }

  /* Map to the internal type.  */
  struct sem *isem = (struct sem *) sem;

  /* Use the value the user provided.  */
  isem->count = value;

  /* We can completely ignore the PSHARED parameter since inter-process
     use needs no special preparation.  */

  return 0;
}
		
sem_init() では pshared を参照していないことが分かります。どのような確保されたメモリの属性 (プライベート/共有) によってプロセス間で共有されるかどうかが決まります。pshare を '0' 以外で指定しても、複数のプロセスからアクセス可能なメモリ上に確保されていなければ、プロセス間で共有することはできません (参考 - mutex のプロセス共有属性) プロセス間の同期処理には名前付きセマフォを使うこともできます (sem_open() のマニュアルを参照してください)

それではセマフォをインクリメントする sem_post() を見てみましょう (nptl/sysdeps/unix/sysv/linux/sem_post.c)

int
__new_sem_post (sem_t *sem)
{
  int *futex = (int *) sem;

  int nr = atomic_increment_val (futex);
  int err = lll_futex_wake (futex, nr);
  if (__builtin_expect (err, 0) < 0)
    {
      __set_errno (-err);
      return -1;
    }
  return 0;
}
		
非常にシンプルですね。atomic_increment_val() によって不可分にセマフォをインクリメントしています。同時に lll_futex_wake() によりインクリメント待ちスレッドを起こしています。

デクリメント操作
セマフォのデクリメントは sem_wait() により行います (nptl/sysdeps/unix/sysv/linux/sem_wait.c)

int
__new_sem_wait (sem_t *sem)
{
  /* First check for cancellation.  */
  CANCELLATION_P (THREAD_SELF);

  int *futex = (int *) sem;
  int err;

  do
    {
      if (atomic_decrement_if_positive (futex) > 0)
    return 0;

      /* Enable asynchronous cancellation.  Required by the standard.  */
      int oldtype = __pthread_enable_asynccancel ();

      err = lll_futex_wait (futex, 0);

      /* Disable asynchronous cancellation.  */
      __pthread_disable_asynccancel (oldtype);
    }
  while (err == 0 || err == -EWOULDBLOCK);

  __set_errno (-err);
  return -1;
}
		
atomic_decrement_if_positive() が不可分なデクリメント操作です。セマフォが 0 より大きくないとデクリメントすることはできません。デクリメントできれば直ちに復帰します。デクリメントできなかったスレッドは lll_futex_wait() により誰かが sem_post() してくれるまで眠りにつきます。mutex と同じく複数のスレッドが sem_post() 待ちになることができます。一回の sem_post() により起床するのは一スレッドだけ。どのスレッドが起きるかは非決定的です。

futex() の前後で __pthread_enable_asynccancel() / __pthread_disable_asynccancel() が呼び出されています。これは POSIX により sem_wait() がキャンセルポイント (後述) に指定されているからです。

セマフォのインターフェース
glibc では次の名前無しセマフォインターフェースが定義されています。

int sem_init(sem_t *sem, int pshared, unsigned int value);
名前無しセマフォを初期化します。全てのスレッドが参照可能なメモリ領域に確保します (大域変数やヒープなど) pshared を 0 以外にした場合はプロセスで共有可能なセマフォとなります。プロセスで共有するセマフォは共有メモリ領域に配置しなければいけません (sem_init 内部では pshared を見ていません。引数で渡したセマフォオブジェクトが置かれたメモリが、プロセス内のメモリ空間か共有メモリかによってその性質が決まります)
int sem_post(sem_t *sem);
sem に 1 加算します。
int sem_wait(sem_t *sem);
sem > 0 なら sem から 1 減算します。sem が 0 なら呼び出したスレッドはブロックされます。
int sem_trywait(sem_t *sem);
sem > 0 なら sem から 1 減算します。sem が 0 ならエラー終了します (EBUSY)
int sem_timedwait(sem_t *restrict sem, const struct timespec *restrict abs_timeout);
sem > 0 なら sem から 1 減算します。sem が 0 なら abstime までに待ちます。待っても sem > 0 にならなかった場合はエラー終了します (ETIMEDOUT) (参考 - POSIX クロックとタイマー)
int sem_destroy(sem_t *sem);
セマフォオブジェクトを破壊します。この関数は何も行いません。常に成功します (glibc 2.5.1)
読み取り/書き込みロック
読み取り/書き込みロックは共有リソースに対して、複数のスレッドからの読み取りもしくは、排他的な書き込みロックを行うための操作です。操作のほとんどが読み取りで、まれに書き込みが行われる共有リソースに適用すると効果的です。読み取りロックは複数のスレッドが同時に獲得でき、単純な相互排他よりも並列性が高い処理を行うことができます。書き込みロックは同時に一つのスレッドだけが獲得します。

具体的には図 4 の状態遷移によりロック操作が行われます。


図 4 読み取り/書き込みロック状態遷移

この状態遷移は概念的な理解を助けるために用意したものです。実際の glibc のコードがこのようなステートマシンを持っている訳ではありません。

空き
読み取り/書き込みロックは空いている状態です。読み取り/書き込みどちらのロックもただちに獲得できます。
読み取りロック
一つ以上のスレッドが読み取りロックを獲得している状態です。新たな読み取りロックはただちに獲得できます。つまり、読み取りロックを獲得するためのインターフェースである pthread_rwlock_rdlock() と pthread_rwlock_tryrdlock() は成功終了します。
書き込みロック要求があると書き込みロック待ち (1) へ遷移します。書き込みロックを獲得するためのインターフェースである pthread_rwlock_wrlock() はブロックされます。pthread_rwlock_trywrlock() は EBUSY でエラー終了します。
書き込みロック待ち (1)
一つ以上のスレッドが書き込みロックを待っている状態です。もしタイプ属性 (参考 - 読み取り/書き込みロックの属性) が PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP の場合、新たな読み取りロック要求は保留されます。つまり、pthread_rwlock_rdlock() はブロックされ、pthread_rwlock_tryrdlock() は EBUSY でエラー終了します (書き込みロックかつ読み取りロック待ち (1)へ遷移します)
全ての読み取りロックが解除された後、書き込みロック待ちスレッドの一つがロックを獲得します (書き込みロックへ遷移)
書き込みロック
一つのスレッドが書き込みロックを獲得している状態です。新たな読み取りロック要求はブロックされます (読み取りロック待ち) つまり、pthread_rwlock_rdlock() はブロックされ、pthread_rwlock_tryrdlock() はエラー終了します (EBUSY) 新たな書き込みロック要求もブロックされます (書き込みロック待ち (2) へ遷移) つまり、pthread_rwlock_wrlock() はブロックされ、pthread_rwlock_trywrlock() はエラー終了します (EBUSY)
ロックが解除される時に、書き込みロック待ちのスレッドがいなければ、読み取りロック待ちのスレッドが起床されます。言い換えると、全ての書き込みロック要求が充足されるまでは、読み取りロック要求は保留されます。
書き込みロック待ち (2)
他のスレッドが獲得している書き込みロックが解除されるのを待っている状態です。新たな読み込みロック要求はブロックされます (書き込みロックかつ読み取りロック待ち (2) へ遷移)
読み取りロック待ち
書き込みロック要求が全て充足され、ロックが解除されるのを待っている状態です。新たな書き込み要求はブロックされます (書き込みロックかつ読み取りロック待ち (2) へ遷移)
書き込みロックかつ読み取りロック待ち (1) 
書き込みロック待ち (1)で読み取りロック要求が保留された状態です。オレンジ色の矢印が二つあります。属性が PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP の場合はこの状態へ遷移する矢印、他の属性が指定されている場合は読み取りロック要求がブロックされないので、ループしている矢印です。
書き込みロックかつ読み取りロック待ち (2) 
書き込みロックを待っているスレッドと読み取りロックを待っているスレッドの両方がいる状態です。まず全ての書き込みロック要求が順番に処理されます。全ての書き込みロック要求が充足されたら、読み取りロックへ遷移します。
◆

読み取り/書き込みロックを上手く使うとパフォーマンスの向上が期待できます。しかし、実装を良く理解していないと思わぬ不具合に遭遇することがあります。注意しなければいけないのは以下の点です。

状態によって優先される操作が変わる
「GNU/Linux の読み取り/書き込みロックはデフォルトで読み取りロックが優先する」という記述を良く見かけます。これは正確な表現ではありません。タイプ属性 (type) を PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP 以外 (デフォルトでは PTHREAD_RWLOCK_DEFAULT_NP) で指定して初期化すると、図 4 の状態遷移図において 書き込みロック待ち (1) 状態でも読み取りロック要求は制限されません。

一方、どのようなタイプ (type) を指定しても、書き込みロックが解除される時は常に書き込みロック待ちスレッドが優先されます。無条件に読み取りロック要求が優先される訳ではないのです (参考 - pthread_rwlock_unlock() の実装)

書き込みロック待ち (1) 状態で読み取りロック要求を制限したい場合は、タイプ (type) に PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP を指定します。ただし、書き込みロック待ちスレッドがいる状態で、読み取りロックを再帰的に獲得しようとするとデッドロックするので注意が必要です (参考 - pthread_rwlock_rdlock() の実装)
優先度の逆転に注意する
読み取り/書き込みロックの操作では優先度継承が行われません。リアルタイムスケジューリングポリシー (後述) 下では優先度の逆転に注意しなければいけません。
ロック解除時のロックオーナチェックが行われない
pthread_rwlock_unlock() は呼び出したスレッドがロックオーナかどうかを確認しません。あるスレッドが獲得した書き込みロックを別のスレッドが解除できてしまいます。
読み込み/書き込みロックの実装
読み取り/書き込みロックの実装を見てみましょう。ここで引用したのは glibc-2.5.1 の実装です (glib-2.3.4 と glibc-2.5.1 の違いはありません) まずは pthread_rwlock_t の定義からです (nptl/sysdeps/unix/sysv/linux/i386/bits/pthreadtypes.h)

#if defined __USE_UNIX98 || defined __USE_XOPEN2K
/* Data structure for read-write lock variable handling.  The
   structure of the attribute type is not exposed on purpose.  */
typedef union
{
  struct
  {
    int __lock;
    unsigned int __nr_readers;
    unsigned int __readers_wakeup;
    unsigned int __writer_wakeup;
    unsigned int __nr_readers_queued;
    unsigned int __nr_writers_queued;
    /* FLAGS must stay at this position in the structure to maintain
       binary compatibility.  */
    unsigned int __flags;
    int __writer;
  } __data;
  char __size[__SIZEOF_PTHREAD_RWLOCK_T];
  long int __align;
} pthread_rwlock_t;
#endif
		
pthread_rwlock_t の定義ファイルはプロセッサ毎に分かれています。これは x86 の場合です。共用体で定義されていますが、実際の操作に使われるのは __data です。__nr_readers は読み取りロックを獲得しているスレッドの数です。__readers_wakeup は読み取りロック要求待ちに使う futex 変数です。__writer_wakeup は書き込みロック要求待ちに使う futex 変数です。__nr_readers_queued は読み取りロック要求待ちをしているスレッドの数です。__nr_writers_queued は書き込みロック要求待ちをしているスレッドの数です。__flags は属性です。__writer は書き込みロックを獲得しているスレッドのスレッド ID が格納されます。__lock は読み取り/書き込みロックの操作に使うロック変数です。

次に初期化を行う pthread_rwlock_init() を見てみましょう (nptl/pthread_rwlock_init.c)

static const struct pthread_rwlockattr default_attr =
  {
    .lockkind = PTHREAD_RWLOCK_DEFAULT_NP,
    .pshared = PTHREAD_PROCESS_PRIVATE
  };


int
__pthread_rwlock_init (rwlock, attr)
     pthread_rwlock_t *rwlock;
     const pthread_rwlockattr_t *attr;
{
  const struct pthread_rwlockattr *iattr;

  iattr = ((const struct pthread_rwlockattr *) attr) ?: &default_attr;

  rwlock->__data.__lock = 0;
  rwlock->__data.__flags
    = iattr->lockkind == PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP;
  rwlock->__data.__nr_readers = 0;
  rwlock->__data.__writer = 0;
  rwlock->__data.__readers_wakeup = 0;
  rwlock->__data.__writer_wakeup = 0;
  rwlock->__data.__nr_readers_queued = 0;
  rwlock->__data.__nr_writers_queued = 0;

  return 0;
}
		
glibc (2.3.4/2.5.1) では読み取り/書き込みロック同期オブジェクトの属性として、タイプ (type) と共有属性 (process shared) が定義されていますが、実際には共有属性 (process shared) は見ていません。読み取り/書き込みロックがプロセス間で共有されるかどうかは、確保されたメモリの属性に依存します。

mmap() で MAP_SHARED として確保した領域を pthread_rwlock_init() に渡せば、指定した共有属性 (process shared) に関わらずその読み取り/書き込みロックはプロセス間で共有されます (参考 - mutex のプロセス共有属性)

◆

注意しなければいけないのは __flags の初期化です。__flags には読み取り/書き込みロックのタイプ (type) が格納されます。 attr を指定しない (NULL を渡す) とデフォルト属性により PTHREAD_RWLOCK_DEFAULT_NP が指定されます。PTHREAD_RWLOCK_DEFAULT_NP = PTHREAD_RWLOCK_PREFER_READER_NP と定義されています (nptl/sysdeps/pthread/pthread.h)

type が PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP かどうかが確認されていますね。従って __flag のデフォルト値は 0 ということになります。

/* Read-write lock types.  */
#if defined __USE_UNIX98 || defined __USE_XOPEN2K
enum
{
  PTHREAD_RWLOCK_PREFER_READER_NP,
  PTHREAD_RWLOCK_PREFER_WRITER_NP,
  PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP,
  PTHREAD_RWLOCK_DEFAULT_NP = PTHREAD_RWLOCK_PREFER_READER_NP
};
		
繰り返しになりますが、PTHREAD_RWLOCK_PREFER_READER_NP が指定されても、glibc (2.3.4/2.5.1) では、読み取りロック要求が常に書き込みロック要求より優先されるわけではありません (参考 - pthread_rwlock_unlock())

__writer は書き込みロックを獲得しているスレッドのスレッド ID が格納されます。__writer == 0 の場合は書き込みロックオーナーはいないという意味を持ちます。当然ですが pthread_rwlock_unlock() 時にも 0 にリセットされます。

◆

それでは、読み取りロックを要求する pthread_rwlock_rdlock() の実装を見てみましょう。この関数には最適化されたアセンブラコードがアーキテクチャ毎に用意されています。例えば x86 の場合は nptl/sysdeps/unix/sysv/linux/i386/i486/pthread_rwlock_rdlock.S です。ここでは C で書かれた nptl/sysdeps/pthread/pthread_rwlock_rdlock.c を引用します。

/* Acquire read lock for RWLOCK.  */
int
__pthread_rwlock_rdlock (rwlock)
     pthread_rwlock_t *rwlock;
{
  int result = 0;

  /* Make sure we are along.  */
  lll_mutex_lock (rwlock->__data.__lock);
		
読み取り/書き込みロックを操作するためにロックします。

  while (1)
    {
      /* Get the rwlock if there is no writer...  */
      if (rwlock->__data.__writer == 0
          /* ...and if either no writer is waiting or we prefer readers.  */
          && (!rwlock->__data.__nr_writers_queued
              || rwlock->__data.__flags == 0))
        {
          /* Increment the reader counter.  Avoid overflow.  */
          if (__builtin_expect (++rwlock->__data.__nr_readers == 0, 0))
            {
              /* Overflow on number of readers.  */
              --rwlock->__data.__nr_readers;
              result = EAGAIN;
            }

          break;
        }
		
まず書き込みロック状態かどうかを判定します (__writer == 0) 書き込みロック中ではない場合は、空き (__nr_readers == 0) か読み取りロック、いずれかの状態ということになります。この時に読み取りロックを獲得できるかどうかは、指定したタイプ属性 (type) によって変わります。pthread_rwlock_init() の実装を思い出してください。__flags はタイプ (type) に PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP が指定された時だけ '1' (真) でした。

PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP
書き込みロック待ちのスレッドがいる (__nr_writers_queued > 0) と読み取りロックを獲得できない。
PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP 以外
書き込みロック待ちのスレッドがいても読み取りロックを獲得できる。
ここまでのフローで呼び出したスレッドが読み取りロックを獲得しているかどうかはチェックされませんでした。そもそも pthread_rwlock_t には読み取りロックを獲得しているスレッドの ID を列挙するリストなどが用意されていません。読み取りロックのされる度に __nr_readers がインクリメントされるだけです。

POSIX の規定には、

"A thread may hold multiple concurrent read locks on rwlock (that is, successfully call the pthread_rwlock_rdlock() function n times). If so, the application shall ensure that the thread performs matching unlocks (that is, it calls the pthread_rwlock_unlock() function n times)."

とありますので、読み取りロックが完全に解除されるには、ロックと同じ回数だけ pthread_rwlock_unlock() を呼ばなければいけません。

PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP を指定するとデッドロックの原因になるというのがお分かりいただけましたでしょうか。書き込みロック待ちスレッドがいる状態 (__nr_writers_queued > 0)で、すでに読み取りロックを獲得しているスレッドが pthread_rwlock_rdlock() を呼ぶとブロックされます。ブロックされたスレッドは read_rwlock_unlock() を呼べなくなるので永遠に読み取りロックが解除されません。

      /* Make sure we are not holding the rwlock as a writer.  This is
         a deadlock situation we recognize and report.  */
      if (__builtin_expect (rwlock->__data.__writer
                            == THREAD_GETMEM (THREAD_SELF, tid), 0))
        {
          result = EDEADLK;
          break;
        }
		
ロックできなかった場合の処理です。まず、自身が書き込みロックを獲得していないかを確認します (__writer == THREAD_GETMEM (THREAD_SELF, tid)) 獲得している場合、このままブロックするとデッドロックしますのでエラー終了します (EDEADLK)

書き込みロックの時だけ再帰ロックのチェックを行っているのは処理コストと関係があります。書き込みロックを獲得できるのは一つのスレッドだけですので一度確認するだけですみます。一方読み取りロックは複数のスレッドが獲得でき、その確認を行うのは大きなコストが必要となります。

      /* Remember that we are a reader.  */
      if (__builtin_expect (++rwlock->__data.__nr_readers_queued == 0, 0))
        {
          /* Overflow on number of queued readers.  */
          --rwlock->__data.__nr_readers_queued;
          result = EAGAIN;
          break;
        }
		
スレッドは読み取りロック待ちでブロックされます。読み取りロック待ちスレッドカウンタ (__nr_readers_queued) をインクリメントします。カウンタがオーバフローした場合はエラー終了します (EAGAIN)

      int waitval = rwlock->__data.__readers_wakeup;

      /* Free the lock.  */
      lll_mutex_unlock (rwlock->__data.__lock);
		
読み取りロック待ちのための futex() 変数を初期化し、操作ロックを解除します。


      /* Wait for the writer to finish.  */
      lll_futex_wait (&rwlock->__data.__readers_wakeup, waitval);

      /* Get the lock.  */
      lll_mutex_lock (rwlock->__data.__lock);

      --rwlock->__data.__nr_readers_queued;
    }  --- while(1) の末端 
		
lll_futex_wait() を呼び出し、書き込みロックが終了するのを待ちます。ロックが解除され lll_futex_wait() から戻ると再び読み取り/書き込みロックを操作するためのロックを獲得し、読み取りロックの獲得を試みます。


  /* We are done, free the lock.  */
  lll_mutex_unlock (rwlock->__data.__lock);

  return result;
}
		
読み取りロックを獲得したら、読み取り/書き込みロックを操作するためのロックを解除して終了します。

◆

次は、書き込みロックを要求する pthread_rwlock_wrlock() の実装を見てみましょう。この関数には最適化されたアセンブラコードがアーキテクチャ毎に用意されています。例えば x86 の場合は nptl/sysdeps/unix/sysv/linux/i386/i486/pthread_rwlock_wrlock.S です。ここでは C 言語で書かれた nptl/sysdeps/pthread/pthread_rwlock_wrlock.c を引用します。

/* Acquire write lock for RWLOCK.  */
int
__pthread_rwlock_wrlock (rwlock)
     pthread_rwlock_t *rwlock;
{
  int result = 0;

  /* Make sure we are along.  */
  lll_mutex_lock (rwlock->__data.__lock);
		
読み取り/書き込みロックを操作するためにロックします。

  while (1)
    {
      /* Get the rwlock if there is no writer and no reader.  */
      if (rwlock->__data.__writer == 0 && rwlock->__data.__nr_readers == 0)
        {
          /* Mark self as writer.  */
          rwlock->__data.__writer = THREAD_GETMEM (THREAD_SELF, tid);
          break;
        }
		
書き込みロックが空いていて (__writer == 0)、かつ読み取りロックも空いている (_nr_readers == 0) なら、書き込みロックを獲得します。__writer には書き込みロックを獲得したスレッドのスレッド ID を格納することになっていました (参考 - __writer の定義) THREAD_GETMEM はスレッド固有の情報が書かれたデータ領域 (Thread Local Storage) へアクセスするためのマクロです。当然ですがアーキテクチャ依存したコードになります (x86 の場合は nptl/sysdeps/i386/tls.h)

x86 と x86_64 では GDT (Global Description Table) を使用して　CPU (コア) 毎、スレッド毎のデータ領域を実現しています (Ulrich Drepper, Ingo Molnar, "The Native POSIX Thread Library for Linux")

      /* Make sure we are not holding the rwlock as a writer.  This is
         a deadlock situation we recognize and report.  */
      if (__builtin_expect (rwlock->__data.__writer
                            == THREAD_GETMEM (THREAD_SELF, tid), 0))
        {
          result = EDEADLK;
          break;
        }
		
他のスレッドが読み取り / 書き込みロックを獲得していて、ロックできなかった場合の処理です。まず、自身が書き込みロックを獲得していないかを確認します (__writer == THREAD_GETMEM (THREAD_SELF, tid)) 獲得している場合、このままブロックするとデッドロックしますのでエラー終了します (EDEADLK)

      /* Remember that we are a writer.  */
      if (++rwlock->__data.__nr_writers_queued == 0)
        {
          /* Overflow on number of queued writers.  */
          --rwlock->__data.__nr_writers_queued;
          result = EAGAIN;
          break;
        }
		
スレッドは書き込みロック待ちでブロックされます。書き込みロック待ちスレッドカウンタ (__nr_writers_queued) をインクリメントします。カウンタがオーバフローした場合はエラー終了します (EAGAIN)

      int waitval = rwlock->__data.__writer_wakeup;

      /* Free the lock.  */
      lll_mutex_unlock (rwlock->__data.__lock);
		
書き込みロック待ちのための futex() 変数を初期化し、読み取り/書き込みロックを操作するためのロックを解除します。

      /* Wait for the writer or reader(s) to finish.  */
      lll_futex_wait (&rwlock->__data.__writer_wakeup, waitval);

      /* Get the lock.  */
      lll_mutex_lock (rwlock->__data.__lock);

      /* To start over again, remove the thread from the writer list.  */
      --rwlock->__data.__nr_writers_queued;
    }  --- while(1) の末端 
		
lll_futex_wait() を呼び出し、読み取り/書き込みロックが終了するのを待ちます。ロックが解除され lll_futex_wait() から戻ると再び読み取り/書き込みロックを操作するためのロックを獲得し、読み取りロックの獲得を試みます。

  /* We are done, free the lock.  */
  lll_mutex_unlock (rwlock->__data.__lock);

  return result;
}
		
書き込みロックを獲得したら、読み取り/書き込みロックを操作するためのロックを解除して終了します。

◆

ロックを解除する pthread_rwlock_unlock() の実装を見てみましょう。この関数には最適化されたアセンブラコードがアーキテクチャ毎に用意されています。例えば x86 の場合は nptl/sysdeps/unix/sysv/linux/i386/i486/pthread_rwlock_unlock.S です。まずは C 言語で書かれた nptl/sysdeps/pthread/pthread_rwlock_unlock.c を引用します。

/* Unlock RWLOCK.  */
int
__pthread_rwlock_unlock (pthread_rwlock_t *rwlock)
{
  lll_mutex_lock (rwlock->__data.__lock);
  if (rwlock->__data.__writer)
    rwlock->__data.__writer = 0;
  else
    --rwlock->__data.__nr_readers;
  if (rwlock->__data.__nr_readers == 0)
    {
      if (rwlock->__data.__nr_writers_queued)
        {
          ++rwlock->__data.__writer_wakeup;
          lll_mutex_unlock (rwlock->__data.__lock);
          lll_futex_wake (&rwlock->__data.__writer_wakeup, 1);
          return 0;
        }
      else if (rwlock->__data.__nr_readers_queued)
        {
          ++rwlock->__data.__readers_wakeup;
          lll_mutex_unlock (rwlock->__data.__lock);
          lll_futex_wake (&rwlock->__data.__readers_wakeup, INT_MAX);
          return 0;
        }
    }
  lll_mutex_unlock (rwlock->__data.__lock);
  return 0;
}
		
最初に読み取り/書き込みロックを操作するためにロックします。次に __writer != 0 であれば書き込みロックを解除します (__writer = 0)

ロックオーナが確認されていないことに気づかれたのではないでしょうか。POSIX ではロックを獲得していないのに解除しようとするとエラー終了する (EPERM) と規定されています。しかし glibc の　NPTL 実装ではオーナのチェックは行われていません。これは glibc-2.6、glibc-2.7、glibc-2.8 でも同じです (glibc-2.9 以降は未確認)

このような実装になっている経緯は確認していませんが、読み取りロックは多数のスレッドが獲得します。もしオーナをチェックするとすればリストを用意することになるのですが、この関数が呼ばれる度にリストを検索してチェックしていたのでは大変なコストになってしまいます。せっかく読み取りの並列性を高めてもロックの解除が遅く、結局相互排他した方が早いというのでは話になりません。

それでは、書き込みロックぐらいはオーナを確認したら良いのではと思うかもしれません。linuxthread ではオーナチェックが行われていますが、glibc (2.3.4/2.5.1) の NPTL ではこれもチェックされません (glibc-2.6 ～ glibc-2.8 においてもチェックされていないことを確認。glibc-2.9 以降は未確認)

◆

linuxthread ベースの Vine Linux 4.2 と glibc-2.5 ベースの CentOS 5.2 で次のプログラムを動かしてみました。

#define _XOPEN_SOURCE 600

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <semaphore.h>
#include <pthread.h>


static pthread_barrier_t    barrier;
static pthread_rwlock_t     rwlk;
static sem_t                sem1;


void *writer(void *dummy)
{
    int                 error;

    pthread_barrier_wait(&barrier);

    error = pthread_rwlock_wrlock(&rwlk);
    if (error !=  0) {
        fprintf(stderr, "Thread (%lu) wrlock failed: %d\n", (unsigned long)pthread_self(), error);
        sem_post(&sem1);
        pthread_barrier_wait(&barrier);
        return (void *) NULL;
    }

    printf("Thread (%lu) acquired a writre-lock.\n", (unsigned long)pthread_self());

    sem_post(&sem1);
    pthread_barrier_wait(&barrier);

    return (void *) NULL;
}


void *other(void *dummy)
{

    int                 error;

    pthread_barrier_wait(&barrier);

    sem_wait(&sem1);
    printf("Thread (%lu) was waken up to unlock the writre-lock.\n", (unsigned long)pthread_self());

    error = pthread_rwlock_unlock(&rwlk);
    if (error != 0) {
        fprintf(stderr, "pthread_rwlock_unlock() failed: %s\n",
                            error == EPERM? "EPERM": "OTHER ERROR");

        pthread_barrier_wait(&barrier);
        return (void *) NULL;
    }

    printf("Thread (%lu) release the lock.\n", (unsigned long)pthread_self());

    error = pthread_rwlock_wrlock(&rwlk);
    if (error !=  0) {
        fprintf(stderr, "Thread (%lu) wrlock failed: %d\n", (unsigned long)pthread_self(), error);
        pthread_barrier_wait(&barrier);
        return (void *) NULL;
    }

    printf("Thread (%lu) acquired the writre-lock.\n", (unsigned long)pthread_self());
    pthread_barrier_wait(&barrier);

    return (void *) NULL;
}



int main (void)
{

    int                         rtn;
    pthread_t                   thw, tho;

    /* init semaphore */
    rtn = sem_init(&sem1, 0, 0);
    if (rtn != 0) {
        perror("sem_init");
        exit(EXIT_FAILURE);
    }

    /* init rwlock */
    rtn = pthread_rwlock_init(&rwlk, NULL);
    if (rtn != 0) {
        fprintf(stderr, "pthread_rwlock_init() failed for %d.\n", rtn);
        exit(EXIT_FAILURE);
    }

    /* init barrier */
    rtn = pthread_barrier_init(&barrier, NULL, 2);
    if (rtn != 0) {
        fprintf(stderr, "pthread_barrier_init() failed for %d.\n", rtn);
        exit(EXIT_FAILURE);
    }

    /* create thread */
    rtn = pthread_create(&thw, NULL, writer, (void *)NULL);
    if (rtn != 0) {
        fprintf(stderr, "pthread_create() - writer failed for %d.\n", rtn);
        exit(EXIT_FAILURE);
    }

    rtn = pthread_create(&tho, NULL, other, (void *)NULL);
    if (rtn != 0) {
        fprintf(stderr, "pthread_create() - other failed for %d.\n", rtn);
        exit(EXIT_FAILURE);
    }

    /* join */
    pthread_join(thw, NULL);
    pthread_join(tho, NULL);

    /* destroy resources */
    pthread_barrier_destroy(&barrier);
    pthread_rwlock_destroy(&rwlk);
    sem_destroy(&sem1);

    exit(EXIT_SUCCESS);

}
		
writer() と other() という二つのスレッドを生成します。バリア (barrier) でスレッドの起動に同期し、writer() は書き込みロックを獲得します。other() は writer() のロック獲得を sem_wait(&seml) で待ちます。writer() がロックしたら、other() はそのロックを解除します。そしてあらためて書き込みロックを要求します。other() が書き込みロックを獲得できたのであれば、other() が書き込みロックを解除したことになります。

Vine Linux 4.2 (linuxthread) の結果は次の通りでした。

$ ./rwlock_test
Thread (16386) acquired a writre-lock.
Thread (32771) was waken up to unlock the writre-lock.
pthread_rwlock_unlock() failed: EPERM
		
CentOS 5.2 (NPTL) の結果は次の通りでした。

$ ./rwlock_test
Thread (3086072720) acquired a writre-lock.
Thread (3075582864) was waken up to unlock the writre-lock.
Thread (3075582864) release the lock.
Thread (3075582864) acquired the writre-lock.
		
とは言え、CentOS 5.2 で man pthread_rwlock_unlock を見るとロックオーナでなければエラー終了 (EPERM) すると書かれています。glibc-2.3.4、glibc-2.5.1 ～ glibc-2.8 (glibc-2.4、glibc-2.9 以降は未確認) で EPERM が返ってくることはありませんが、ポータブルな実装を目指すのであれば、POSIX で規定されている通り pthread_rwlock_unlock() の返値をエラーチェックするべきだと思います。

◆

実際の x86 用のアセンブラコードがその通りになっているのかどうかも確認しましょう (nptl/sysdeps/unix/sysv/linux/i386/i486/pthread_rwlock_unlock.S)

#include <sysdep.h>
#include <lowlevelrwlock.h>


#define SYS_futex               240
#define FUTEX_WAIT              0
#define FUTEX_WAKE              1

#ifndef UP
# define LOCK lock
#else
# define LOCK
#endif


        .text

        .globl  __pthread_rwlock_unlock
        .type   __pthread_rwlock_unlock,@function
        .align  16
__pthread_rwlock_unlock:
        pushl   %ebx
        pushl   %edi

        movl    12(%esp), %edi

        /* Get the lock.  */
        movl    $1, %edx
        xorl    %eax, %eax
        LOCK
#if MUTEX == 0
        cmpxchgl %edx, (%edi)
#else
        cmpxchgl %edx, MUTEX(%edi)
#endif
        jnz     1f
		
ディスプレースメントの MUTEX は __lock のオフセットに一致します。pthread_rwlock_t はアーキテクチャ毎に定義ファイルが用意されています。バイナリレベルでのオフセットはビルド時に決定します。具体的には lowlevelrwlock.h がビルド時に生成され、その中でメンバ変数のオフセットが定義されています。lowlevelrwlock.h 中を見てみましょう。これは x86 アーキテクチャをターゲットに glibc-2.5.1 をビルドした時のものです (build-i486-linuxnptl/lowlevelrwlock.h)

#define MUTEX          0
#define NR_READERS     4
#define READERS_WAKEUP 8
#define WRITERS_WAKEUP 12
#define READERS_QUEUED 16
#define WRITERS_QUEUED 20
#define FLAGS          24
#define WRITER         28
		
__lock は読み取り/書き込みロック操作をシリアライズするための mutex です。__lock == 0 であれば空き、__lock == 1 であればロック中です。

コンペアアンドエクスチェンジ命令 (cmpxchgl r32, r/m32) は EAX レジスタと r/m32 の値を比較し、等しければ ZF をセットし r32 を r/m32 にロードする。等しくない場合は ZF をクリアし、r/m32 を EAX レジスタにロードします。ここでは、EDX = 1、EAX = 0 とした上で cmpxchg %edx, MUTEX(%edi) を実行しています。

コンペアアンドエクスチェンジ命令の前に LOCK プリフェックスが付けられています。バスロックによりアトミックな実行を保証するためのものなのですが、コア数が多いマシンほどスケーラビリティへの影響が大きくなります。そこで、MUTEX == 0 の場合は cmpxchgl %edx, (%edi) を実行してわずかでも性能を稼ぐよう工夫されています。

__lock のロックに成功したら ZF がセットされます。他のスレッドがすでにロックしていて、ロックできなかった時は先のコードにあるラベル 1 へ分岐します。

2:      cmpl    $0, WRITER(%edi)
        jne     5f
        subl    $1, NR_READERS(%edi)
        jnz     6f
		
読み取り/書き込みロックを操作するためのロックに成功しました。まず、__writer (WRITER (%edi)) が 0 か (書き込みロックが空いているか) を確認します。0 でなければ 5 へ分岐します。読み取り/書き込み、どちらのロックを解除するのにも、この関数 (pthread_rwlock_unlock(pthread_rwlock_t *rwlock)) が使われます。そして、呼び出し時にどちらのロックを解除するのかは明示されません。

__writer == 0 ならば書き込みロック中ではないので、この呼び出しは読み取りロック解除を要求していると見なします。読み取りロックは回数を記録しているだけでした。読み取りロックカウンタ __data.__nr_readers から 1 を引いて 6 へ分岐します。

5:      movl    $0, WRITER(%edi)
        movl    $1, %ecx
        leal    WRITERS_WAKEUP(%edi), %ebx
        movl    %ecx, %edx
        cmpl    $0, WRITERS_QUEUED(%edi)
        jne     0f
		
5 へ分岐したということは __writer != 0 ですので書き込みロック中です。__writer に 0 を代入して書き込みロックを解除します。呼び出したスレッドがロックオーナかどうかを確認していないのはこのコードでも同じです (参考 - pthread_rwlock_unlock() の C による実装)

書き込みロックを解除したら、ECX、EDX レジスタに 1 を、EBX レジスタに __data.__writer_wakeup (WRITERS_WAKEUP(%edi)) のアドレスを格納します。これは futex() システムコールの引数になります。x86 の場合、システムコールの引数とレジスタの対応は次の通り定義されています (ysdeps/unix/sysv/linux/i386/sysdep.h)

/* The original calling convention for system calls on Linux/i386 is
   to use int $0x80.  */
#ifdef I386_USE_SYSENTER
# ifdef SHARED
#  define ENTER_KERNEL call *%gs:SYSINFO_OFFSET
# else
#  define ENTER_KERNEL call *_dl_sysinfo
# endif
#else
# define ENTER_KERNEL int $0x80
#endif

/* Linux takes system call arguments in registers:

        syscall number  %eax         call-clobbered
        arg 1           %ebx         call-saved
        arg 2           %ecx         call-clobbered
        arg 3           %edx         call-clobbered
        arg 4           %esi         call-saved
        arg 5           %edi         call-saved

   The stack layout upon entering the function is:

        20(%esp)        Arg# 5
        16(%esp)        Arg# 4
        12(%esp)        Arg# 3
         8(%esp)        Arg# 2
         4(%esp)        Arg# 1
          (%esp)        Return address

   (Of course a function with say 3 arguments does not have entries for
   arguments 4 and 5.)

        ...............

		
EBX レジスタは一番目の引数になります。futex() の一番目の引数は状態変数のアドレスですね (ここでは &__writer_wakeup)

書き込みロック待ちのスレッドがいるかどうかが先に確認されます。__nr_writers_queued (WRITERS_QUEUED(%edi)) が 0 でなければ書き込みロック待ちスレッドいますので、ラベルの 0 へ分岐します。

読み取り/書き込みロックのタイプ属性 (type) に関係なく、書き込みロック解除時には書き込みロック待ちスレッドが優先されるのが分かりますね。

        /* If also no readers waiting nothing to do.  */
        cmpl    $0, READERS_QUEUED(%edi)
        je      6f

        movl    $0x7fffffff, %edx
        leal    READERS_WAKEUP(%edi), %ebx
		
書き込みロック待ちスレッドはいないようですので、読み取りロック待ちスレッドがいるかどうかを確認します。__nr_readers_queued (READERS_QUEUED(%edi)) == 0 かどうかチェックし 0 の (読み取りロック待ちスレッドがいない) 場合は 6 へ分岐します。

読み取りロック待ちスレッドがいる場合は EDX レジスタに $0x7fffffff (INTMAX)、EBX に __readers_wakeup のアドレスを格納します。これらのレジスタは futex() システムコールの引数になります。

0:      addl    $1, (%ebx)
        LOCK
#if MUTEX == 0
        subl    $1, (%edi)
#else
        subl    $1, MUTEX(%edi)
#endif
        jne     7f
		
書き込みロックを解除した後のフローです。EBX は、書き込みロック待ちスレッドがいる場合、書き込みロック待ち用の futex 変数、読み取りロック待ちスレッドがいる場合、読み取りロック待ち用の futex 変数のアドレスが格納されています。addl $1, (%ebx) で futex 変数に 1 が加算されています。

futex() システムコールを呼ぶ前に、mutex のロックを解除します。__lock (MUTEX(%edi)) から 1 を減算します。MUTEX == 0 の時の最適化は先ほどと同じですね。subl 命令を実行した結果 __lock が 0 にならなかった時 (異常ケース) は 7 へ分岐します。

8:      movl    $SYS_futex, %eax
        ENTER_KERNEL

        xorl    %eax, %eax
        popl    %edi
        popl    %ebx
        ret
		
EAX レジスタに futex() のシステムコール番号を格納し、ENTER_KERNEL でシステムコールを呼び出します。復帰したら EAX レジスタに戻り値 0 を格納しリターンします。

6:      LOCK
#if MUTEX == 0
        subl    $1, (%edi)
#else
        subl    $1, MUTEX(%edi)
#endif
        jne     3f

4:      xorl    %eax, %eax
        popl    %edi
        popl    %ebx
        ret
		
ラベル 6 は、書き込みロック解除後、読み取り/書き込みどちらのロック待ちスレッドもいなかった場合のフローです。__lock から 1 を減算してロックを解除しリターンします。subl 命令を実行した結果 __lock が 0 にならなかった時 (異常ケース) は 3 へ分岐します。

1:
#if MUTEX == 0
        movl    %edi, %ecx
#else
        leal    MUTEX(%edi), %ecx
#endif
        call    __lll_mutex_lock_wait
        jmp     2b
		
ラベル 1 は、読み取り/書き込みロックを操作するためのロックが獲得できなかった場合のフローです。他のスレッドがこの読み取り/書き込みロックを操作しているようですので、__lll_mutex_lock_wait() を呼び出し、ロックが解除されるのを待ちます。解除されロックを獲得したら __lll_mutex_lock_wait() から復帰しますので、ロック後の処理 (前のラベル 2 へ分岐します)

3:
#if MUTEX == 0
        movl    %edi, %eax
#else
        leal    MUTEX(%edi), %eax
#endif
        call    __lll_mutex_unlock_wake
        jmp     4b
		
ラベル 3 は、書き込みロック解除後、読み取り/書き込みどちらのロック待ちスレッドもいないので、__lock のロックを解除しようとしたのですが、__lock が 0 にならなかった (異常ケース) のフローです。__lll_mutex_unlock_wake() を呼び出してロックが解除されるのを待ちます。復帰したら解除されているのでリターンの処理が書かれたラベル 4 (既出) へ分岐します。

7:
#if MUTEX == 0
        movl    %edi, %eax
#else
        leal    MUTEX(%edi), %eax
#endif
        call    __lll_mutex_unlock_wake
        jmp     8b
		
ラベル 3 は、書き込みロック解除後、読み取り/書き込みいずれかのスレッドがいるので、futex() システムコールを呼び出す前に __lock のロックを解除しようとしたのですが、__lock が 0 にならなかった (異常ケース) のフローです。__lll_mutex_unlock_wake() を呼び出してロックが解除されるのを待ちます。復帰したら解除されているので、元の futex() を呼び出すフロー (ラベル 8 - 既出) へ分岐します。

読み取り/書き込みロックのインターフェース
glibc では次の読み取り/書き込みロックインターフェースが定義されています。

int pthread_rwlock_init(pthread_rwlock_t *rwlock, const pthread_rwlockattr_t *attr);
読み取り/書き込みロックオブジェクト (rwlock) を初期化します。attr により初期化する rwlock の属性を指定します。attr が指定されない (NULL) の場合はデフォルトの属性が適用されます。
int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
rwlock を読み取りロックします。すでに他のスレッドによって書き込みロックされている場合は、ロックが解除されるまでブロックされます。
int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
rwlock の読み取りロックを試みます。すでに他のスレッドによって書き込みロックされている場合は、関数がただちにエラー終了します (EBUSY)
int pthread_rwlock_timedrdlock(pthread_rwlock_t *restrict rwlock, const struct timespec *restrict abs_timeout);
読み取りロックを獲得しようと試みます。abstime までにロックできなかった時はエラー終了します (ETIMEDOUT) (参考 - POSIX クロックとタイマー)
int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
rwlock を書き込みロックします。すでに他のスレッドによって書き込みロックされている場合は、ロックが解除されるまでブロックされます。
int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);
rwlock の書き込みロックを試みます。すでに他のスレッドによって書き込みロックされている場合は、関数がただちにエラー終了します (EBUSY)
int pthread_rwlock_timedwrlock(pthread_rwlock_t *restrict rwlock, const struct timespec *restrict abs_timeout);
書き込みロックを獲得しようと試みます。abstime までにロックできなかった時はエラー終了します (ETIMEDOUT) (参考 - POSIX クロックとタイマー)
int pthread_rwlock_unlock(pthread_rwlock_t *rwlock);
rwlock のロックを解除します。
int pthread_rwlock_destroy(pthread_rwlock_t *rwlock);
rwlock オブジェクトを破壊します。glibc-2.3、glibc-2.5、glibc-2.6、glibc-2.7、glibc-2.8 では何も行われません (glibc-2.9 以降は未確認)
int pthread_rwlockattr_init(pthread_rwlockattr_t *attr);
読み取り/書き込みロック属性オブジェクト (attr) をデフォルト属性で初期化します。
int pthread_rwlockattr_setkind_np(pthread_rwlockattr_t *attr, int pref);
int pthread_rwlockattr_getkind_np(const pthread_mutexattr_t *attr, int *pref);
属性オブジェクトにタイプ (type) を設定します。pthread_rwlockattr_getkind_np() は設定されたタイプを取得します。pref に以下のいずれかを指定します。
タイプ属性	説明
PTHREAD_RWLOCK_PREFER_READER_NP

読み取りロック解除待ちの書き込みロック待ちスレッドがいる場合でも、読み取りロック要求がブロックされません。

PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP

読み取りロック解除待ちの書き込みロック待ちスレッドがいる場合、読み取りロック要求がブロックされます (pthread_rwlock_tryrdlock() の場合はエラー終了) 書き込みロック待ちのスレッドがいる時に、読み取りロックを再帰的にロックしようとするとデッドロックします。

PTHREAD_RWLOCK_PREFER_WRITER_NP

読み取りロック解除待ちの書き込みロック待ちスレッドがいる場合でも、読み取りロック要求がブロックされません。

int pthread_rwlockattr_setpshared(pthread_rwlockattr_t *attr, int pshared);
int pthread_rwlockattr_getpshared(const pthread_rwlockattr_t *attr, int *pshared);
属性オブジェクトに共有属性を設定します。pthread_rwlockattr_getpshared() は設定されている共有属性を取得します (参考 - mutex のプロセス共有属性)
バリア (barrier)
バリアは複数のスレッドをあるタスクの完了に同期させたい時に使用する同期オブジェクトです。pthread_barrier_wait() は pthread_barrier_init() で指定した数のスレッドが pthread_barrier_wait() を呼ぶまでブロックされます。これにより想定するスレッドが全て pthread_barrier_wait() の呼び出しまで達したことを確認することができます。

バリアはどのような用途で使われるのでしょうか。例えば、配列を処理するループをマルチスレッドプログラムで並列化するといった応用が考えられます。

バリアは排他機構も持っています。指定した呼び出し回数に達した時には、ブロックされていたスレッドが順次 pthread_barrier_wait() から復帰します。そのうちの一つだけ戻り値が PTHREAD_BARRIER_SERIAL_THREAD になります (他のスレッドには 0 が返されます) この返値をもらったスレッドだけが処理を行うようにすれば、そのセクションを排他的に実行できます。

バリアの操作では優先度継承が行われません。リアルタイムスケジューリングポリシー下では優先度の逆転に注意しなければいけません。

バリアの実装
バリアがどのように実装されているのか見てみましょう。ここで引用したのは glibc-2.5.1 の実装です。まずは pthread_barrier_t の定義からです (nptl/sysdeps/unix/sysv/linux/i386/bits/pthreadtypes.h)

/* POSIX barriers data type.  The structure of the type is
   deliberately not exposed.  */
typedef union
{
  char __size[__SIZEOF_PTHREAD_BARRIER_T];
  long int __align;
} pthread_barrier_t;
		
pthread_barrier_t の定義ファイルはプロセッサ毎に分かれています。これは x86 の場合です。実際の操作に使われる時には struct pthread_barrier キャストした上でアクセスされます。

/* Barrier data structure.  */
struct pthread_barrier
{
  unsigned int curr_event;
  int lock;
  unsigned int left;
  unsigned int init_count;
};
		
curr_event は pthread_barrier_wait() の呼び出し回数が指定したカウントに達するのを待つための futex 変数です。lock はバリアオブジェクトの操作に使うロック変数です。left は pthread_barrier_wait() の呼び出し回数のダウンカウンタです。呼び出しがある度にデクリメントされ left == 0 になると、待たされている他のスレッドが起こされます。init_count はカウンタの初期値が格納される変数です。

初期化を行う pthread_barrier_init() を見てみましょう (nptl/pthread_barrier_init.c)

int
pthread_barrier_init (barrier, attr, count)
     pthread_barrier_t *barrier;
     const pthread_barrierattr_t *attr;
     unsigned int count;
{
  struct pthread_barrier *ibarrier;

  if (__builtin_expect (count == 0, 0))
    return EINVAL;

  if (attr != NULL)
    {
      struct pthread_barrierattr *iattr;

      iattr = (struct pthread_barrierattr *) attr;

      if (iattr->pshared != PTHREAD_PROCESS_PRIVATE
          && __builtin_expect (iattr->pshared != PTHREAD_PROCESS_SHARED, 0))
        /* Invalid attribute.  */
        return EINVAL;
    }

  ibarrier = (struct pthread_barrier *) barrier;

  /* Initialize the individual fields.  */
  ibarrier->lock = LLL_LOCK_INITIALIZER;
  ibarrier->left = count;
  ibarrier->init_count = count;
  ibarrier->curr_event = 0;

  return 0;
}
		
pthread_barrier_init() には初期化するバリアオブジェクト (barrier)、属性 (attr)、指定呼び出し回数 (count) を渡します。count == 0 の場合エラー終了します (EINVAL) attr == NULL の場合デフォルト属性により初期化されます。glibc (2.3.4/2.5.1) ではバリア同期オブジェクトの属性として共有属性 (process shared) が定義されていますが、実際は共有属性を見ていません。バリアがプロセス間で共有されるかどうかは、確保されたメモリの属性に依存します。

mmap() で MAP_SHARED として確保した領域を pthread_barrier_init() に渡せば、指定した共有属性に関わらずそのバリアはプロセス間で共有されます (参考 - mutex のプロセス共有属性)

lock は LLL_LOCK_INITIALIZER で初期化されます。left、init_count には指定した呼び出し回数が格納されます。curr_event は 0 で初期化されます。

◆

pthread_barrier_wait() の実装を見てみましょう。この関数には最適化されたアセンブラコードがアーキテクチャ毎に用意されています。例えば x86 の場合は nptl/sysdeps/unix/sysv/linux/i386/i486/pthread_barrier_wait.S です。ここでは C 言語で書かれた nptl/sysdeps/pthread/pthread_barrier_wait.c を引用します。

/* Wait on barrier.  */
int
pthread_barrier_wait (barrier)
     pthread_barrier_t *barrier;
{
  struct pthread_barrier *ibarrier = (struct pthread_barrier *) barrier;
  int result = 0;

  /* Make sure we are alone.  */
  lll_lock (ibarrier->lock);
		
バリアオブジェクトを操作するためにロックします。

  /* One more arrival.  */
  --ibarrier->left;
		
呼び出し回数カウンタをデクリメントします。

  /* Are these all?  */
  if (ibarrier->left == 0)
    {
      /* Yes. Increment the event counter to avoid invalid wake-ups and
         tell the current waiters that it is their turn.  */
      ++ibarrier->curr_event;

      /* Wake up everybody.  */
      lll_futex_wake (&ibarrier->curr_event, INT_MAX);

      /* This is the thread which finished the serialization.  */
      result = PTHREAD_BARRIER_SERIAL_THREAD;
    }
		
left == 0 であれば、指定した呼び出し回数に達したということです。lll_futex_wake() を呼び、すでに待っている他のスレッドを起こします。このコード (glibc-2.5.1) は最後に呼び出したスレッドに対して PTHREAD_BARRIER_SERIAL_THREAD を返していますが、POSIX ではどのスレッドにこの返値が渡されるかは不定 (unspcified) と規定されています。ポータブルなコードを書く必要がある場合は、最後に pthread_barrier_wait() を呼んだスレッドに対して PTHREAD_BARRIER_SERIAL_THREAD が返されることを期待しないようにしてください。

  else
    {
      /* The number of the event we are waiting for.  The barrier's event
         number must be bumped before we continue.  */
      unsigned int event = ibarrier->curr_event;

      /* Before suspending, make the barrier available to others.  */
      lll_unlock (ibarrier->lock);

      /* Wait for the event counter of the barrier to change.  */
      do
        lll_futex_wait (&ibarrier->curr_event, event);
      while (event == ibarrier->curr_event);
    }
		
left != 0 であれば、まだ指定された呼び出し回数には達していません。まず futex() 状態変数の値をローカル変数へ保存します。そして、バリアオブジェクトを操作するためのロックを解除し、lll_futex_wait() を呼び出します。スレッドは指定した呼び出し回数に達するまでスリープします。

  /* Make sure the init_count is stored locally or in a register.  */
  unsigned int init_count = ibarrier->init_count;

  /* If this was the last woken thread, unlock.  */
  if (atomic_increment_val (&ibarrier->left) == init_count)
    /* We are done.  */
    lll_unlock (ibarrier->lock);

  return result;
}
		
ここでは、すでに指定した呼び出し回数に達していて、スリープしていたスレッドが次々と起床します。全てのスレッドが起床するまでロックは解除できません。スレッドが全て起床しないうちにロックを解除すると pthread_barrier_wait() が呼び出される恐れがあります。呼び出したスレッドにより left がデクリメントされると辻褄が合わなくなります。

起床したスレッドは、それぞれ一回だけ atomic_increment_val (&ibarrier->left) を実行します。結果が init_count に一致したのであれば最後に起きたスレッドということになりますのでロックを解除します。

lll_unlock() は低レベルのロック解除関数でオーナかどうかのチェックは行われません。

バリアのインターフェース
glibc では次のバリアロックインターフェースが定義されています。

int pthread_barrier_init(pthread_barrier_t *barrier, const pthread_barrierattr_t *attr, unsigned int count);
バリアオブジェクト (barrier) を初期化します。attr により初期化する barrier の属性を指定します。attr が指定されない (NULL) の場合はデフォルト属性が適用されます。count は pthread_barrier_wait() のブロックが解除される呼び出し回数です。
int pthread_barrier_wait(thread_barrier_t *barrier);
指定した呼び出し回数に達するまで待ちます。
int pthread_barrier_destroy(ed_barrier_t *barrier);
バリアオブジェクトを破壊します。スレッドが pthread_barrier_wait() で待っている場合はエラー終了します (EBUSY)
int pthread_barrierattr_init(pthread_barrierattr_t *attr);
バリア属性オブジェクト (attr) をデフォルト属性で初期化します。
int pthread_barrierattr_setpshared(pthread_barrierattr_t *attr, int pshared);
int pthread_barrierattr_getpshared(const pthread_barrierattr_t *attr, int *pshared);
属性オブジェクトに共有属性を設定します。pthread_barrierattr_getpshared() は設定されている属性値を取得します (参考 - mutex のプロセス共有属性)
条件変数
条件変数は、ある条件が真になるまで待つ方法を提供する同期オブジェクトです。条件をチェックする前に、関連付けられた mutex をロックします。条件をチェックし真でなければ pthread_cond_wait() を呼び出します。pthread_cond_wait() はロック解除とスレッドのブロックを不可分に処理します。ブロックされたスレッドは条件が真になるまで眠り続けます。

条件を真にするスレッドは、条件が真になったら明示的に pthread_cond_signal() か pthread_cond_broadcast() を呼び出して、スリープしているスレッドを起床させます。条件を真にするスレッドは待っているスレッドの優先度を継承しません。リアルタイムスケジューリングポリシー下では優先度の逆転に注意しなければいけません。

条件変数は C コンパイラが許容する任意の条件式をサポートします。特別なプリプロセッサを用意せず、ライブラリだけでこのような機能を実現しようとすると、多少アドホックな実装にならざるを得ません。これが条件変数に関する操作が他の同期オブジェクトのインターフェースと少し違う理由です。ここでは、説明のために簡単なサンプルプログラムを作成しました。

このプログラムでは thread1()、thread2() という二つのスレッドが生成されます。thread1() は大域変数の count を毎秒インクリメントします。thread2() は count が 8 になるまで条件変数で待ちます。

#define _XOPEN_SOURCE 600

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <time.h>
#include <pthread.h>

static pthread_mutex_t  mutex;
static pthread_cond_t   cond;
static unsigned int     count = 0;


void *thread1(void *dummy)
{

    int                 ret;
    struct timespec     req, res;

    req.tv_sec  = 1;
    req.tv_nsec = 0;

    while(1) {

        putchar('0');

        pthread_mutex_lock(&mutex);
        count++;
        pthread_mutex_unlock(&mutex);
		
thread1() では count をインクリメントします。もう一方の thread2() もこの count を参照しているので、排他的にインクリメントしなければいけません。

        if (count == 8)
            pthread_cond_signal(&cond);
		
pthread_cond_signal() は条件が真になるのを待っているスレッドを一つだけ起床させます。全てのスレッドを起こす時は、pthread_cond_broadcast() を使います。

        do {
            ret = nanosleep(&req, &res);
            req.tv_sec  = res.tv_sec;
            req.tv_nsec = res.tv_nsec;
        } while (ret != 0 && errno == EINTR);

        if (ret != 0) {
            perror("nanosleep()");
            return (void *) NULL;
        }
		
nanosleep() により一秒間スリープします。マルチスレッドプログラムでは sleep() や usleep() よりも nanosleep() の使用が推奨されます。glibc のバージョンによっては sleep() が alram() により実装されていることがあります。alarm() は指定秒後に SIGALRM をプロセスに対して配送するインターフェースですが、シグナルハンドラはプロセス全体で共通ですので、複数のスレッドから sleep() を呼ぶと、正しいタイミングで動作しない可能性があります。

nanosleep() はシステムコールとしてカーネルレベルで実装されています。またシグナルを使用しませんので、複数のスレッドから使用可能です。glibc-2.3.4 と glibc-2.5.1 では sleep()、usleep() とも nanosleep() を使用して実装されていますが、ポータビリティが要求されるプログラムでは、nanosleep() を使用することをお奨めします。

nanosleep() を使用した時は、リンカオプションに -lrt を指定します。

gcc -o condv_test condv_test.c -lpthread -lrt
		
        fflush(stdout);
    }


    return (void *) NULL;

}
		
標準出力をフラッシュしてループの先頭に戻ります。

◆

thread2() は条件変数により count が 8 になるまで待ちます。

void *thread2(void *dummy)
{

    while (1) {

        putchar('1');

        pthread_mutex_lock(&mutex);
        while (count  != 8) {
            putchar('2');
            pthread_cond_wait(&cond, &mutex);
            putchar('3');
        }
        count = 0;
        pthread_mutex_unlock(&mutex);

        putchar('4');

    }

    return (void *) NULL;
}
		
条件を評価する前に pthread_mutex_lock() で mutex をロックします。これは thread1() がインクリメント時にロックしていた mutex です。このように条件を評価するスレッドと、条件変化の元になる操作を行うスレッドの間で相互排他します。

ここでは count == 8 が真になるまで待つことになっていました。while( count != 8 ) なので、真でなければ pthread_cond_wait() が呼ばれます。引数で条件変数 (cond) と mutex が渡されていることに注目してください。条件変数は複数のスレッドが同じ条件変数で待つことを許しています。そのためには mutex のロック解除と cond の変更をアトミックに行う必要があります。ここでは、pthread_cond_wait() がその役割を果たします。

count == 8 が偽であったためスレッドはスリープします。mutex のロックが解除されているので thread1() が count を操作できます。また、他のスレッドが同じ条件変数で pthread_cond_wait() を呼び出すことができます。

pthread_cond_wait() からは mutex をロックした状態で復帰します。条件を変更したスレッドが mutex をロックしたままだと、pthread_cond_signal() が呼ばれても pthread_cond_wait() から復帰できません。thread1() は pthread_cond_signal() を呼ぶ前に mutex のロックを解除しています。

int main (void)
{

    int                         i, rtn;
    pthread_t                   th1, th2;


    /* init mutex */
    rtn = pthread_mutex_init(&mutex, NULL);
    if (rtn != 0) {
        fprintf(stderr, "pthread_mutex_init() failed for %d.\n", rtn);
        exit(EXIT_FAILURE);
    }


    /* init cond */
    rtn = pthread_cond_init(&cond, NULL);
    if (rtn != 0) {
        fprintf(stderr, "pthread_cond_init() failed for %d.\n", rtn);
        exit(EXIT_FAILURE);
    }


    /* create threads */
    rtn = pthread_create(&th1, NULL, thread1, (void *)NULL);
    if (rtn != 0) {
        fprintf(stderr, "pthread_create() - thread#1 failed for %d.\n", rtn);
        exit(EXIT_FAILURE);
    }


    /* create threads */
    rtn = pthread_create(&th2, NULL, thread2, (void *)NULL);
    if (rtn != 0) {
        fprintf(stderr, "pthread_create() - thread#2 failed for %d.\n", rtn);
        exit(EXIT_FAILURE);
    }


    /* join */
    pthread_join(th1, NULL);
    pthread_join(th2, NULL);

    pthread_cond_destroy(&cond);
    pthread_mutex_destroy(&mutex);

    exit(EXIT_SUCCESS);

}
		
状態変数は pthread_cond_init() により初期化します。このプログラムを実行した結果は次のようになります。

012000000034120000000034120000 ....
		
'0' を出力しているのは thread1() です。thread2() において '1' と '2' は pthread_cond_wait() の前、'3' と '4' は後です。'0' が 8 回出力されると thread2() が起床しています。

条件変数の属性
POSIX では条件変数にプロセス共有属性 (process shared) とクロック属性 (clock) が定義されています。

他の同期オブジェクト同様、glibc (2.3.4 / 2.5.1) でプロセス間で共有されるかどうかは確保されたメモリの属性に依存します。ただし、プロセス共有の場合は、条件変数に関連づけられた mutex の扱い方と pthread_cond_broadcast() の処理が異なるため、pthread_cond_init() においてこの属性値を参照しています。

mmap() で MAP_SHARED として確保した領域を pthread_cond_init() に渡せば、指定した共有属性に関わらずその条件変数はプロセス間で共有されます (参考 - mutex のプロセス共有属性)

◆

クロック属性は pthread_cond_timedwait() で使用するクロックを指定します。CLOCK_MONOTONIC か CLOCK_REALTIME を指定します。

pthread_cond_timedwait() は指定した時間、条件が真になるのを待つインターフェースです。同期オブジェクトには、指定した時刻までロックを待つインターフェースが用意されています。pthread_mutex_timedlock()、sem_timedwait()、pthread_rwlock_timedrdlock()、pthread_rwlock_timedwrlock() といった関数です。これらについては POSIX タイマーの項で説明します。

pthread_condattr_t がどのように定義されているのか見てみましょう。ここで引用したのは glibc-2.5.1 の実装です (nptl/sysdeps/unix/sysv/linux/i386/bits/pthreadtypes.h) glibc-2.3.4、glibc-2.6、glibc-2.7、glibc-2.8 でも同様に定義されています。

typedef union
{
  char __size[__SIZEOF_PTHREAD_CONDATTR_T];
  long int __align;
} pthread_condattr_t;
		
pthread_condattr_t の定義ファイルはプロセッサ毎に分かれています。これは x86 の場合です。実際の操作に使われる時には struct pthread_condattr キャストした上でアクセスされます。

/* Conditional variable attribute data structure.  */
struct pthread_condattr
{
  /* Combination of values:

     Bit 0  : flag whether coditional variable will be shareable between
              processes.

     Bit 1-7: clock ID.  */
  int value;
};


/* The __NWAITERS field is used as a counter and to house the number
   of bits which represent the clock.  COND_CLOCK_BITS is the number
   of bits reserved for the clock.  */
#define COND_CLOCK_BITS 1
		
pthread_condattr_t は整数変数 value で実装されています。Bit 0 はプロセス共有属性、Bit 1 - 7 はクロック ID です。COND_CLOCK_BITS はクロック属性を何ビット目に格納するのかを定義しています。

glibc-2.7、glibc-2.8 では COND_CLOCK_BITS に加えて COND_NWAITERS_SHIFT が定義されています。

/* The __NWAITERS field is used as a counter and to house the number
   of bits for other purposes.  COND_CLOCK_BITS is the number
   of bits needed to represent the ID of the clock.  COND_NWAITERS_SHIFT
   is the number of bits reserved for other purposes like the clock.  */
#define COND_CLOCK_BITS         1
#define COND_NWAITERS_SHIFT     1
		
クロック属性で指定できるのクロックは CLOCK_REALTIME と CLOCK_MONOTONIC の二種類しかありませんが、将来の拡張に備えて、何ビット目に格納するのかを指定する COND_NWAITERS_SHIFT とクロックの種類を指定するために必要となるビット数を指定する COND_CLOCK_BITS が定義されています。

条件変数の実装
条件変数がどのように実装されているのか見てみましょう。ここで引用したのは glibc-2.5.1 の実装です。まずは pthread_cond_t の定義からです (nptl/sysdeps/unix/sysv/linux/i386/bits/pthreadtypes.h)

/* Data structure for conditional variable handling.  The structure of
   the attribute type is not exposed on purpose.  */
typedef union
{
  struct
  {
    int __lock;
    unsigned int __futex;
    __extension__ unsigned long long int __total_seq;
    __extension__ unsigned long long int __wakeup_seq;
    __extension__ unsigned long long int __woken_seq;
    void *__mutex;
    unsigned int __nwaiters;
    unsigned int __broadcast_seq;
  } __data;
  char __size[__SIZEOF_PTHREAD_COND_T];
  __extension__ long long int __align;
} pthread_cond_t;
		
pthread_cond_t の定義ファイルはプロセッサ毎に分かれています。これは x86 の場合です。共用体で定義されていますが、実際の操作に使われるのは __data です。

lock は条件変数を操作するためのロック変数です。__futex は futex 変数です。__total_seq は pthread_cond_wait() の呼び出し回数のカウンタ。__wakeup_seq は pthread_cond_signal() の呼び出しカウンタ。__woken_seq は起床させられたスレッドの数。 pthread_cond_broadcast() により起床させられたスレッドの数。mutex は関連づけられている mutex へのポインタ。__nwaiters は条件変数で待っているスレッドの数とクロック属性を保持します。__broadcast_seq は pthread_cond_broadcast() の呼び出しカウンタです。

初期化を行う pthread_cond_init() を見てみましょう (nptl/pthread_cond_init.c) 条件変数の実装は一つの変数に複数の意味が与えられており、残念ながら大変分かりづらいコードになっています。

int
__pthread_cond_init (cond, cond_attr)
     pthread_cond_t *cond;
     const pthread_condattr_t *cond_attr;
{
  struct pthread_condattr *icond_attr = (struct pthread_condattr *) cond_attr;

  cond->__data.__lock = LLL_MUTEX_LOCK_INITIALIZER;
  cond->__data.__futex = 0;
  cond->__data.__nwaiters = (icond_attr != NULL
                             && ((icond_attr->value & (COND_CLOCK_BITS << 1)) >> 1));
  cond->__data.__total_seq = 0;
  cond->__data.__wakeup_seq = 0;
  cond->__data.__woken_seq = 0;
  cond->__data.__mutex = (icond_attr == NULL || (icond_attr->value & 1) == 0 ? NULL : (void *) ~0l);
  cond->__data.__broadcast_seq = 0;

  return 0;
}
		
pthread_cond_init() には初期化する条件変数オブジェクト (cond)、属性 (cond_attr) を渡します。cond_attr == NULL の場合、デフォルト属性により初期化されます。

__lock は LLL_LOCK_INITIALIZER で初期化されます。__nwaiters の一ビット目にはクロック属性が書き込まれます。__mutex には条件変数のプロセス共有属性が 1 であれば NULL、そうでなければマジックナンバーの ~1 が書き込まれます。

◆

pthread_cond_wait() の実装を見てみましょう。この関数には最適化されたアセンブラコードがアーキテクチャ毎に用意されています。例えば x86 の場合は nptl/sysdeps/unix/sysv/linux/i386/i486/pthread_cond_wait.S です。ここでは C 言語で書かれた nptl/sysdeps/pthread/pthread_cond_wait.c を引用します。

nt
__pthread_cond_wait (cond, mutex)
     pthread_cond_t *cond;
     pthread_mutex_t *mutex;
{
  struct _pthread_cleanup_buffer buffer;
  struct _condvar_cleanup_buffer cbuffer;
  int err;

  /* Make sure we are along.  */
  lll_mutex_lock (cond->__data.__lock);

  /* Now we can release the mutex.  */
  err = __pthread_mutex_unlock_usercnt (mutex, 0);
  if (__builtin_expect (err, 0))
    {
      lll_mutex_unlock (cond->__data.__lock);
      return err;
    }
		
条件変数オブジェクトを操作するためのロックを獲得します。

  /* We have one new user of the condvar.  */
  ++cond->__data.__total_seq;
  ++cond->__data.__futex;
  cond->__data.__nwaiters += 1 << COND_CLOCK_BITS;
		
呼び出し回数カウンタ (__total_seq) と futex 変数 (__futex) をインクリメントします。__nwaiters の一ビット目にはクロック属性が保持されています。上位ビットには条件変数で待っているスレッドの数が保持されます (1 << COND_CLOCK_BITS が加算されていくので、一ビット目は常に保持される) この変数は pthread_cond_destroye() によって使われます。オブジェクトを破壊する前に、その条件変数で待っているスレッド全てがそのオブジェクトを手放すまで待たなければいけません。pthread_cond_destroy() では lll_futex_wait (&cond->__data.__nwaiters, nwaiters) が実行され、pthread_cond_wait() では、最後に起床したスレッドが lll_futex_wake (&cond->__data.__nwaiters, 1); を実行します。

  /* Remember the mutex we are using here.  If there is already a
     different address store this is a bad user bug.  Do not store
     anything for pshared condvars.  */
  if (cond->__data.__mutex != (void *) ~0l)
    cond->__data.__mutex = mutex;
		
コメント文と処理内容が一致していません。プロセス共有属性で 共有 (shared) が指定された場合、pthread_cond_init() において __mutex には ~01 が書かれます。条件変数がプロセス間で共有される場合は __mutex には関連づけられた mutex のアドレスは書かずに、そのセマンティクスを保ちます。

共有属性が プライベート (private) の時は mutex のアドレスを保持します。

  /* Prepare structure passed to cancellation handler.  */
  cbuffer.cond = cond;
  cbuffer.mutex = mutex;

  /* Before we block we enable cancellation.  Therefore we have to
     install a cancellation handler.  */
  __pthread_cleanup_push (&buffer, __condvar_cleanup, &cbuffer);
		
pthread_cond_wait() はキャンセルポイントに指定されています。キャンセルハンドラに渡す cbuffer を初期化して、__pthread_cleanup_push() によりキャンセルハンドラを登録します。

  /* The current values of the wakeup counter.  The "woken" counter
     must exceed this value.  */
  unsigned long long int val;
  unsigned long long int seq;
  val = seq = cond->__data.__wakeup_seq;
  /* Remember the broadcast counter.  */
  cbuffer.bc_seq = cond->__data.__broadcast_seq;
		
状態変数の現在値を保存します。val と seq は pthread_cond_signal() から起床する時のレースコンディションを避けるために使います。bc_seq は pthread_cond_broadcast() が呼ばれたかどうかを判定するために使います。

  do
    {
      unsigned int futex_val = cond->__data.__futex;

      /* Prepare to wait.  Release the condvar futex.  */
      lll_mutex_unlock (cond->__data.__lock);

      /* Enable asynchronous cancellation.  Required by the standard.  */
      cbuffer.oldtype = __pthread_enable_asynccancel ();

      /* Wait until woken by signal or broadcast.  */
      lll_futex_wait (&cond->__data.__futex, futex_val);

      /* Disable asynchronous cancellation.  */
      __pthread_disable_asynccancel (cbuffer.oldtype);

      /* We are going to look at shared data again, so get the lock.  */
      lll_mutex_lock (cond->__data.__lock);

      /* If a broadcast happened, we are done.  */
      if (cbuffer.bc_seq != cond->__data.__broadcast_seq)
        goto bc_out;

      /* Check whether we are eligible for wakeup.  */
      val = cond->__data.__wakeup_seq;
    }
  while (val == seq || cond->__data.__woken_seq == val);

  /* Another thread woken up.  */
  ++cond->__data.__woken_seq;
		
スリープする前に __lock のロックを解除し、非同期キャンセルを有効にします。他のスレッドにより pthread_cond_signal() か pthread_cond_broadcast() が呼ばれると lll_futex_wait() から復帰します。

まず、非同期キャンセルを無効にします。どちらの関数が呼ばれたのかを判定しなければいけません。pthread_cond_broad() であれば、__broadcast_seq が保存している値と一致しません。

cbuffer.bc_seq != cond->__data.__broadcast_seq であれば、無条件に起床しても良いので bc_out に分岐します。

そうでなければ pthread_cond_signal() が呼ばれたことになります。__wakeup_seq が保存していた値 (seq) と違いかつ __woken_seq と __wakeup_seq の値が違う場合は起床できますので while ループを抜けます。

起床した回数をカウントしている __woken_seq をインクリメントします。

 bc_out:

  cond->__data.__nwaiters -= 1 << COND_CLOCK_BITS;

  /* If pthread_cond_destroy was called on this varaible already,
     notify the pthread_cond_destroy caller all waiters have left
     and it can be successfully destroyed.  */
  if (cond->__data.__total_seq == -1ULL
      && cond->__data.__nwaiters < (1 << COND_CLOCK_BITS))
    lll_futex_wake (&cond->__data.__nwaiters, 1);

  /* We are done with the condvar.  */
  lll_mutex_unlock (cond->__data.__lock);

  /* The cancellation handling is back to normal, remove the handler.  */
  __pthread_cleanup_pop (&buffer, 0);

  /* Get the mutex before returning.  */
  return __pthread_mutex_cond_lock (mutex);
}
		
pthread_cond_broadcast() と共通の終了処理です。まず、条件変数で待っているスレッド数のカウンタをデクリメントします。__total_seq の値が -1ULL の場合、すでに pthread_cond_destroy() が呼ばれたことを意味します。その関数を呼んだスレッドは __nwaiters で待っていますので、自分が最後に起床するスレッドなのであれば lll_futex_wake() を呼んで起床させます。

最後に __lock のロックを解除しキャンセルハンドラ適用範囲の末端を指定します。復帰する前に mutex をロックします。

◆

pthread_cond_signal() の実装を見てみましょう。この関数には最適化されたアセンブラコードがアーキテクチャ毎に用意されています。例えば x86 の場合は nptl/sysdeps/unix/sysv/linux/i386/i486/pthread_cond_signal.S です。ここでは C 言語で書かれた nptl/sysdeps/pthread/pthread_cond_signal.c を引用します。

int
__pthread_cond_signal (cond)
     pthread_cond_t *cond;
{
  /* Make sure we are alone.  */
  lll_mutex_lock (cond->__data.__lock);

  /* Are there any waiters to be woken?  */
  if (cond->__data.__total_seq  >cond->__data.__wakeup_seq)
    {
      /* Yes.  Mark one of them as woken.  */
      ++cond->__data.__wakeup_seq;
      ++cond->__data.__futex;

      /* Wake one.  */
      if (! __builtin_expect (lll_futex_wake_unlock (&cond->__data.__futex, 1,
                                                     1, &cond->__data.__lock),
                                                     0))
        return 0;

      lll_futex_wake (&cond->__data.__futex, 1);
    }

  /* We are done.  */
  lll_mutex_unlock (cond->__data.__lock);

  return 0;
}
		
pthread_cond_signal() は、条件変数で待っているスレッドの一つを起床させます。まず待っているスレッドがいるのかどうかを判定します (cond->__data.__total_seq >cond->__data.__wakeup_seq)

そして、__wakeup_seq と __futex をインクリメントした上で待っているスレッドを起床します。lll_futex_wake_unlock() は条件変数で待っているスレッドの起床と、条件変数を操作するためのロックの解除をアトミックに実行する関数です。x86 アーキテクチャ用の lll_futex_wake_unlock() は定義されていませんが、同じ内容が nptl/sysdeps/unix/sysv/linux/i386/i486/pthread_cond_signal.S にハードコードされています。

この機会に、futex() がどのように実装されているのか簡単に見てみましょう。参考にしたのはカーネルバージョン 2.6.21.3 のコードです。まず futex() のインターフェースから確認しておきましょう。futex() のシグネチャは次の通り定義されています。

int futex(int *uaddr, int op, int val, const struct timespec *timeout,
          int *uaddr2, int val3);
		
lll_futex_wake_unlock() の呼び出しは次の通り引数が渡されます。

futex(&cond->__data.__futex, FUTEX_WAKE_OP, 1, 1, &cond->__data.__lock,
          FUTEX_OP_CLEAR_WAKE_IF_GT_ONE);
		
sys_futex() は次の通り実装されています (kernel/futex.c)

asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
                          struct timespec __user *utime, u32 __user *uaddr2,
                          u32 val3)
{
        struct timespec t;
        unsigned long timeout = MAX_SCHEDULE_TIMEOUT;
        u32 val2 = 0;

        if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
                if (copy_from_user(&t, utime, sizeof(t)) != 0)
                        return -EFAULT;
                if (!timespec_valid(&t))
                        return -EINVAL;
                if (op == FUTEX_WAIT)
                        timeout = timespec_to_jiffies(&t) + 1;
                else {
                        timeout = t.tv_sec;
                        val2 = t.tv_nsec;
                }
        }
        /*
         * requeue parameter in 'utime' if op == FUTEX_REQUEUE.
         */
        if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE)
                val2 = (u32) (unsigned long) utime;

        return do_futex(uaddr, op, val, timeout, uaddr2, val2, val3);
}
		
渡されたアドレスがアクセスできるかなどを確認した上で do_futex() が呼ばれます。do_futex() は次の通り実装されています (kernel/futex.c)

long do_futex(u32 __user *uaddr, int op, u32 val, unsigned long timeout,
                u32 __user *uaddr2, u32 val2, u32 val3)
{
        int ret;

        switch (op) {
        case FUTEX_WAIT:
                ret = futex_wait(uaddr, val, timeout);
                break;
        case FUTEX_WAKE:
                ret = futex_wake(uaddr, val);
                break;
        case FUTEX_FD:
                /* non-zero val means F_SETOWN(getpid()) & F_SETSIG(val) */
                ret = futex_fd(uaddr, val);
                break;
        case FUTEX_REQUEUE:
                ret = futex_requeue(uaddr, uaddr2, val, val2, NULL);
                break;
        case FUTEX_CMP_REQUEUE:
                ret = futex_requeue(uaddr, uaddr2, val, val2, &val3);
                break;
        case FUTEX_WAKE_OP:
                ret = futex_wake_op(uaddr, uaddr2, val, val2, val3);
                break;
        case FUTEX_LOCK_PI:
                ret = futex_lock_pi(uaddr, val, timeout, val2, 0);
                break;
        case FUTEX_UNLOCK_PI:
                ret = futex_unlock_pi(uaddr);
                break;
        case FUTEX_TRYLOCK_PI:
                ret = futex_lock_pi(uaddr, 0, timeout, val2, 1);
                break;
        default:
                ret = -ENOSYS;
        }
        return ret;
}
		
ここで指定されたオペレーションに応じて分岐します。今回は FUTEX_WAKE_OP なので futex_wake_op() が呼ばれます。futex_wake_op() は次の通り実装されています (kernel/futex.c)

/*
 * Wake up all waiters hashed on the physical page that is mapped
 * to this virtual address:
 */
static int
futex_wake_op(u32 __user *uaddr1, u32 __user *uaddr2,
              int nr_wake, int nr_wake2, int op)
{
        union futex_key key1, key2;
        struct futex_hash_bucket *hb1, *hb2;
        struct list_head *head;
        struct futex_q *this, *next;
        int ret, op_ret, attempt = 0;

retryfull:
        down_read(&current->mm->mmap_sem);

        ret = get_futex_key(uaddr1, &key1);
        if (unlikely(ret != 0))
                goto out;
        ret = get_futex_key(uaddr2, &key2);
        if (unlikely(ret != 0))
                goto out;

        hb1 = hash_futex(&key1);
        hb2 = hash_futex(&key2);

retry:
        double_lock_hb(hb1, hb2);

        op_ret = futex_atomic_op_inuser(op, uaddr2);
		
futex_atomic_op_inuser() が __lock のロック解除を行う関数です。後でこの関数の内容に触れます op には最初に渡した FUTEX_OP_CLEAR_WAKE_IF_GT_ONE が対応することを憶えておいてください。op_ret には __lock > 1 を評価したブール値かエラー値が返されます。評価した後 __lock には 0 が代入されます (XCHG 命令により評価と 0 の代入がアトミックに実行されます) futex_atomic_op_inuser() はアーキテクチャ毎に実装されています。

        if (unlikely(op_ret < 0)) {
                u32 dummy;

                spin_unlock(&hb1->lock);
                if (hb1 != hb2)
                        spin_unlock(&hb2->lock);

#ifndef CONFIG_MMU
                /*
                 * we don't get EFAULT from MMU faults if we don't have an MMU,
                 * but we might get them from range checking
                 */
                ret = op_ret;
                goto out;
#endif

                if (unlikely(op_ret != -EFAULT)) {
                        ret = op_ret;
                        goto out;
                }

                /*
                 * futex_atomic_op_inuser needs to both read and write
                 * *(int __user *)uaddr2, but we can't modify it
                 * non-atomically.  Therefore, if get_user below is not
                 * enough, we need to handle the fault ourselves, while
                 * still holding the mmap_sem.
                 */
                if (attempt++) {
                        if (futex_handle_fault((unsigned long)uaddr2,
                                                attempt)) {
                                ret = -EFAULT;
                                goto out;
                        }
                        goto retry;
                }

                /*
                 * If we would have faulted, release mmap_sem,
                 * fault it in and start all over again.
                 */
                up_read(&current->mm->mmap_sem);

                ret = get_user(dummy, uaddr2);
                if (ret)
                        return ret;

                goto retryfull;
        }
		
futex_atomic_op_inuser() からエラーコードが返ってきた時の処理です。x86 の場合は op に指定したオペレーションコードが未定義、uaddr2 へのアクセスができない時に -EFAULT を返すエラーパスがあります。

        head = &hb1->chain;

        list_for_each_entry_safe(this, next, head, list) {
                if (match_futex (&this->key, &key1)) {
                        wake_futex(this);
                        if (++ret => nr_wake)
                                break;
                }
        }
		
条件変数で待っているスレッドを nr_wake だけ起床させます。今回は 1 を指定していたので一つのスレッドを起こすだけです。pthread_cond_signal() ですので当然ですね。

        if (op_ret > 0) {
                head = &hb2->chain;

                op_ret = 0;
                list_for_each_entry_safe(this, next, head, list) {
                        if (match_futex (&this->key, &key2)) {
                                wake_futex(this);
                                if (++op_ret => nr_wake2)
                                        break;
                        }
                }
                ret += op_ret;
        }
		
op_ret が真であれば __lock で待っているスレッドを起床させます。条件変数を操作する前に __lock をロックしているので __lock の値は 1 です。もし __lock で待っているスレッドがいれば __lock > 1 です。従って待っているスレッドがいる時はそれを起床させます。

        spin_unlock(&hb1->lock);
        if (hb1 != hb2)
                spin_unlock(&hb2->lock);
out:
        up_read(&current->mm->mmap_sem);
        return ret;
}
		
futex_atomic_op_inuser() の実装も見てみましょう。この関数はアーキテクチャ毎に実装されています (include/asm-i386/futex.h)

static inline int
futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
{
        int op = (encoded_op >> 28) & 7;
        int cmp = (encoded_op >> 24) & 15;
        int oparg = (encoded_op << 8) >> 20;
        int cmparg = (encoded_op << 20) >> 20;
        int oldval = 0, ret, tem;
        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
                oparg = 1 << oparg;

        if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
                return -EFAULT;

        pagefault_disable();

        if (op == FUTEX_OP_SET)
                __futex_atomic_op1("xchgl %0, %2", ret, oldval, uaddr, oparg);
        else {
#ifndef CONFIG_X86_BSWAP
                if (boot_cpu_data.x86 == 3)
                        ret = -ENOSYS;
                else
#endif
                switch (op) {
                case FUTEX_OP_ADD:
                        __futex_atomic_op1(LOCK_PREFIX "xaddl %0, %2", ret,
                                           oldval, uaddr, oparg);
                        break;
                case FUTEX_OP_OR:
                        __futex_atomic_op2("orl %4, %3", ret, oldval, uaddr,
                                           oparg);
                        break;
                case FUTEX_OP_ANDN:
                        __futex_atomic_op2("andl %4, %3", ret, oldval, uaddr,
                                           ~oparg);
                        break;
                case FUTEX_OP_XOR:
                        __futex_atomic_op2("xorl %4, %3", ret, oldval, uaddr,
                                           oparg);
                        break;
                default:
                        ret = -ENOSYS;
                }
        }

        pagefault_enable();


        if (!ret) {
                switch (cmp) {
                case FUTEX_OP_CMP_EQ: ret = (oldval == cmparg); break;
                case FUTEX_OP_CMP_NE: ret = (oldval != cmparg); break;
                case FUTEX_OP_CMP_LT: ret = (oldval < cmparg); break;
                case FUTEX_OP_CMP_GE: ret = (oldval >= cmparg); break;
                case FUTEX_OP_CMP_LE: ret = (oldval <= cmparg); break;
                case FUTEX_OP_CMP_GT: ret = (oldval > cmparg); break;
                default: ret = -ENOSYS;
                }
        }
        return ret;
}
		
__futex_atomic_op1() の定義を見てみましょう。

#define __futex_atomic_op1(insn, ret, oldval, uaddr, oparg) \
  __asm__ __volatile (                                          \
"1:     " insn "\n"                                             \
"2:     .section .fixup,\"ax\"\n\
3:      mov     %3, %1\n\
        jmp     2b\n\
        .previous\n\
        .section __ex_table,\"a\"\n\
        .align  8\n\
        .long   1b,3b\n\
        .previous"                                              \
        : "=r" (oldval), "=r" (ret), "+m" (*uaddr)              \
        : "i" (-EFAULT), "0" (oparg), "1" (0))
		
__futex_atomic_op1("xchgl %0, %2", ret, oldval, uaddr, oparg) を実行すると、oldval に *uaddr が代入されます。uaddr は futex() の 5 番目の引数、条件変数を操作するためのロック変数 (__lock) でしたね。

encoded_op には futex() の 6 番目の引数が渡されます。今回は 6 番目の引数として FUTEX_OP_CLEAR_WAKE_IF_GT_ONE を渡しました。このマクロは glibc 2.5.1 では nptl/sysdeps/unix/sysv/linux/i386/i486/pthread_cond_signal.S に定義されています。

#define FUTEX_OP_CLEAR_WAKE_IF_GT_ONE   ((4 << 24) | 1)
		
これより cp、cmp、oparg、cmparg の計算は以下の結果になります。

FUTEX_OP_CLEAR_WAKE_IF_GT_ONE = 0x04000001
op                            = 0x00000000
cmp                           = 0x00000004
oparg                         = 0x00000000
cmparg                        = 0x00000001
		
オペレーションコードは次の通り定義されています (include/linux/futex.h)

#define FUTEX_OP_SET            0       /* *(int *)UADDR2 = OPARG; */
#define FUTEX_OP_ADD            1       /* *(int *)UADDR2 += OPARG; */
#define FUTEX_OP_OR             2       /* *(int *)UADDR2 |= OPARG; */
#define FUTEX_OP_ANDN           3       /* *(int *)UADDR2 &= ~OPARG; */
#define FUTEX_OP_XOR            4       /* *(int *)UADDR2 ^= OPARG; */

#define FUTEX_OP_OPARG_SHIFT    8       /* Use (1 << OPARG) instead of OPARG.  */

#define FUTEX_OP_CMP_EQ         0       /* if (oldval == CMPARG) wake */
#define FUTEX_OP_CMP_NE         1       /* if (oldval != CMPARG) wake */
#define FUTEX_OP_CMP_LT         2       /* if (oldval < CMPARG) wake */
#define FUTEX_OP_CMP_LE         3       /* if (oldval <= CMPARG) wake */
#define FUTEX_OP_CMP_GT         4       /* if (oldval > CMPARG) wake */
#define FUTEX_OP_CMP_GE         5       /* if (oldval >= CMPARG) wake */
		
オペレーションは FUTEX_OP_CMP_GT です。つまり futex() を呼んだコンテキスト上で表現すると __lock > 1 が評価され、そのブール値が返されることになります。

__lock > 1 が __lock で待っているスレッドがいるかどうかのチェックに使われていて、必要に応じてスレッドを起床させているのは futex_wake_op() のところで見た通りです。

このようにして lll_futex_wake_unlock() により、条件変数に関連付けられた mutex でスリープしているスレッドをひとつ起床させると同時に、条件変数の操作ロックの解除も行われます。なお、この関数がエラー終了した場合、普通に lll_futex_wake() と lll_mutex_unlock() を呼び出した後復帰します。以下 pthread_cond_signal() の最後の部分を再掲載します。

      lll_futex_wake (&cond->__data.__futex, 1);
    }

  /* We are done.  */
  lll_mutex_unlock (cond->__data.__lock);

  return 0;
}
		
◆

pthread_cond_broadcast() の実装を見てみましょう。この関数には最適化されたアセンブラコードがアーキテクチャ毎に用意されています。例えば x86 の場合は nptl/sysdeps/unix/sysv/linux/i386/i486/pthread_cond_broadcast.S です。ここでは C 言語で書かれた nptl/sysdeps/pthread/pthread_cond_broadcast.c を引用します。

int
__pthread_cond_broadcast (cond)
     pthread_cond_t *cond;
{
  /* Make sure we are alone.  */
  lll_mutex_lock (cond->__data.__lock);
		
条件変数を操作するためにロックします。

  /* Are there any waiters to be woken?  */
  if (cond->__data.__total_seq > cond->__data.__wakeup_seq)
    {
      /* Yes.  Mark them all as woken.  */
      cond->__data.__wakeup_seq = cond->__data.__total_seq;
      cond->__data.__woken_seq = cond->__data.__total_seq;
		
__total_seq > __wakeup_seq であれば、この条件変数で待っているスレッドがいます。それらを全て起床させますので、__wakeup_seq と __woken_seq に __total_seq を代入します。

      cond->__data.__futex = (unsigned int) cond->__data.__total_seq * 2;
      int futex_val = cond->__data.__futex;
      /* Signal that a broadcast happened.  */
      ++cond->__data.__broadcast_seq;
		
futex 変数をセットします。呼び出し回数カウンタの __broadcast_seq をインクリメントします。

      /* We are done.  */
      lll_mutex_unlock (cond->__data.__lock);
		
操作ロックを解除します。

      /* Do not use requeue for pshared condvars.  */
      if (cond->__data.__mutex == (void *) ~0l)
        goto wake_all;
		
プロセス共有設定の場合、関連付けられた mutex は操作しません。

      /* Wake everybody.  */
      pthread_mutex_t *mut = (pthread_mutex_t *) cond->__data.__mutex;

      /* XXX: Kernel so far doesn't support requeue to PI futex.  */
      if (__builtin_expect (mut->__data.__kind & PTHREAD_MUTEX_PRIO_INHERIT_NP,
                            0))
        goto wake_all;
		
関連付けられた mutex のプロトコル属性が PTHREAD_PRIO_INHERIT の場合は、次の futex_requeue をスキップします。カーネルが優先度継承を行う futex の FUTEX_CMP_REQUEUE をサポートしていないからです (この部分の処理は glibc 2.6 ～ 2.8 でも同じです)

      /* lll_futex_requeue returns 0 for success and non-zero
         for errors.  */
      if (__builtin_expect (lll_futex_requeue (&cond->__data.__futex, 1,
                                               INT_MAX, &mut->__data.__lock,
                                               futex_val), 0))
        {
          /* The requeue functionality is not available.  */
        wake_all:
          lll_futex_wake (&cond->__data.__futex, INT_MAX);
        }
		
FUTEX_REQUEUE は「獣の群れの暴走 (thundering herd)」と呼ばれる問題を避けるための futex オペレーションです。起床させるスレッドが多く、それらのスレッドがすぐにクリティカルセクションに入る場合に FUTEX_WAKE を使うと大変大きなコストを必要とします。

pthread_cond_wait() のコードを思い出してください。

do
    {
      unsigned int futex_val = cond->__data.__futex;

      /* Prepare to wait.  Release the condvar futex.  */
      lll_mutex_unlock (cond->__data.__lock);

      /* Enable asynchronous cancellation.  Required by the standard.  */
      cbuffer.oldtype = __pthread_enable_asynccancel ();

      /* Wait until woken by signal or broadcast.  */
      lll_futex_wait (&cond->__data.__futex, futex_val);

      /* Disable asynchronous cancellation.  */
      __pthread_disable_asynccancel (cbuffer.oldtype);

      /* We are going to look at shared data again, so get the lock.  */
      lll_mutex_lock (cond->__data.__lock);

      /* If a broadcast happened, we are done.  */
      if (cbuffer.bc_seq != cond->__data.__broadcast_seq)
        goto bc_out;

      /* Check whether we are eligible for wakeup.  */
      val = cond->__data.__wakeup_seq;
    }
  while (val == seq || cond->__data.__woken_seq == val);

  /* Another thread woken up.  */
  ++cond->__data.__woken_seq;
		
仮に FUTEX_WAKE で起床させると lll_futex_wait() のところでブロックされていたスレッドが一斉に起床します。そして操作ロックを獲得しようとします。結局、ロックできるのはひとつのスレッドだけですので、多くのスレッドは再びスリープすることになります。

このような不効率な操作が繰り返し行われると、システム全体のパフォーマンスが大きく損なわれることになります。そこで、futex() には FUTEX_REQUEUE という操作が用意されました。lll_futex_requeue() は __futex で待っていたスレッドを二番目の引数で指定された数だけ起床させます。上のコードでは 1 (一つのスレッド) が指定されていますね。その他のスレッドは __lock の待ちキューへ再キューされます。

FUTEX_REQUEUE には問題があり、glibc-2.3.2、カーネル 2.6.6 以前のシステムで pthread_cond_broadcast() を使うと、レーシングによりシステムがハングアップすることがあります。現在の lll_futex_requeue() は FUTEX_CMP_REQUEUE (カーネル 2.6.7 以降) が指定されるようになっています。

lll_futex_requeue() が失敗した場合は lll_futex_wake() により全てのスレッドを起床させます。

      /* That's all.  */
      return 0;
    }

  /* We are done.  */
  lll_mutex_unlock (cond->__data.__lock);

  return 0;
}
		
操作ロックを解除して終了します。

条件変数のインターフェース
glibc では次の条件変数インターフェースが定義されています。

int pthread_cond_init(pthread_cond_t *restrict cond, const pthread_condattr_t *restrict attr);
条件変数オブジェクト (cond) を初期化します。attr により初期化する cond の属性を指定します。attr が指定されない (NULL) の場合はデフォルトの属性が適用されます。
int pthread_cond_wait(pthread_cond_t *restrict cond, pthread_mutex_t *restrict mutex);
条件変数で待ちます。
int pthread_cond_timedwait(pthread_cond_t *restrict cond, pthread_mutex_t *restrict mutex, const struct timespec *restrict abstime);
条件変数で abstime まで待ちます。abstime までに起床できなかった時はエラー終了します (ETIMEDOUT) (参考 - POSIX クロックとタイマー)
int pthread_cond_signal(pthread_cond_t *cond);
条件変数で待っているスレッドを一つ起床させます。
int pthread_cond_broadcast(pthread_cond_t *cond);
条件変数で待っているスレッドを全て起床させます。
int pthread_cond_destroy(pthread_cond_t *cond);
条件変数オブジェクトを破壊します。待っているスレッドがいる場合はエラー終了します (EBUSY) pthread_cond_signal() か pthread_cond_broadcast() により起床中の場合は、それが終わるまで待ちます (glibc 2.5.1)
int pthread_condattr_init(pthread_condattr_t *attr);
条件変数属性オブジェクト attr をデフォルト属性で初期化します。
int pthread_condattr_destroy(pthread_condattr_t *attr);
条件変数属性オブジェクトを破壊します。
int pthread_condattr_setclock(pthread_condattr_t *attr, clockid_t clock_id);
int pthread_condattr_getclock(const pthread_condattr_t *restrict attr, clockid_t *restrict clock_id);
属性オブジェクトにクロック属性を設定します。pthread_condattr_getclock() は設定されている属性値を取得します (参考 - 条件変数のクロック属性)
int pthread_condattr_setpshared(pthread_condattr_t *attr, int pshared);
int pthread_condattr_getpshared(const pthread_condattr_t *restrict attr, int *restrict pshared);
属性オブジェクトに共有属性を設定します。pthread_condattr_getpshared() は設定されている属性値を取得します (参考 - mutex のプロセス共有属性)
スピンロック
スピンロックは相互排他するための同期オブジェクトです。mutex との違いはロック待ちに futex() の FUTEX_WAIT を使わないことです。スピンロックはループにより繰り返しロックを試みます。マルチコア・プロセッサ環境で、相互排他する区間の処理時間が短い場合はmutex より効率良くシリアライズできます。

スピンロックの実装
スピンロックがどのように実装されているのか見てみましょう。ここで引用したのは glibc-2.5.1 のコードです。まずは pthread_spinlock_t の定義からです (nptl/sysdeps/unix/sysv/linux/i386/bits/pthreadtypes.h)

/* POSIX spinlock data type.  */
typedef volatile int pthread_spinlock_t;
		
定義ファイルはプロセッサ毎に分かれています。これは x86 の場合です。pthread_spinlock_t は整数型として定義されています。

初期化を行う pthread_spin_init() を見てみましょう。この関数には最適化されたアセンブラコードがアーキテクチャ毎に用意されています。例えば x86 の場合は nptl/sysdeps/i386/pthread_spin_unlock.S です。

        .globl  pthread_spin_unlock
        .type   pthread_spin_unlock,@function
        .align  16
pthread_spin_unlock:
        movl    4(%esp), %eax
        movl    $1, (%eax)
        xorl    %eax, %eax
        ret
        .size   pthread_spin_unlock,.-pthread_spin_unlock

        /* The implementation of pthread_spin_init is identical.  */
        .globl  pthread_spin_init
pthread_spin_init = pthread_spin_unlock
		
pthread_spin_init と pthread_spin_unlock は同じコードになります。スピンロックオブジェクトのポインタが渡されるので、そのアドレスに即値 1 を書き込んでいます。EAX には常に返値が 0 入ります。

次に pthread_spin_lock() を見てみましょう。この関数には最適化されたアセンブラコードがアーキテクチャ毎に用意されています。例えば x86 の場合は nptl/sysdeps/i386/pthread_spin_lock.c です。

#ifndef LOCK_PREFIX
# ifdef UP
#  define LOCK_PREFIX   /* nothing */
# else
#  define LOCK_PREFIX   "lock;"
# endif
#endif


int
pthread_spin_lock (lock)
     pthread_spinlock_t *lock;
{
  asm ("\n"
       "1:\t" LOCK_PREFIX "decl %0\n\t"
       "jne 2f\n\t"
       ".subsection 1\n\t"
       ".align 16\n"
       "2:\trep; nop\n\t"
       "cmpl $0, %0\n\t"
       "jg 1b\n\t"
       "jmp 2b\n\t"
       ".previous"
       : "=m" (*lock)
       : "m" (*lock));

  return 0;
}
		
展開すると次のアセンブラコードになります。

       push   %ebp
       mov    %esp,%ebp
       mov    0x8(%ebp),%eax
 1:    lock decl (%eax)
       jne    2f
       pop    %ebp
       xor    %eax,%eax
       ret
       nop
 2:    pause
       cmpl   $0x0,(%eax)
       jg     1b
       jmp    2b
		
まずスピンロックオブジェクトをデクリメントします。結果が 0 であればロック取得成功です。0 になるには元々の値が 1 である必要があります。pthread_spin_init() で 1 を書き込んでいたことを思い出してください。0 にならなかったらラベル 2 へ分岐します。ここでスピンロックオブジェクトが 0 より大きく (つまり 1) になるまでループします。

jg 1b でラベル 1 へ分岐したからといって、必ずロックできる訳ではありません。他のスレッドが先にデクリメントしてしまうかもしれないからです。その場合は再びラベル 2 へ分岐します。

◆

スピンロックウェイトループに PAUSE という命令が置かれています。これはスピンロックウェイト用に用意された命令で、インテルハイパースレッディングをサポートしているプロセッサのパフォーマンスを改善することができます。

スピンロックウェイトループから抜ける時に、プロセッサは大きなパフォーマンスペナルティを負うことがあります。なぜならばメモリオーダ違反の可能性が検出され、パイプラインのフラッシュが起きるからです。PAUSE 命令はプロセッサにスピンロックウェイトであるというヒントを与えるために導入されました。これによりメモリオーダ違反を避け、パイプラインのフラッシュを避けることができます。また PAUSE 命令はスピンロックウェイトループをパイプラインから排除し、必要以上に電力を消費しないようにします (参考 - Intel, "Architectures Software Developer's Manual", Volume 3A)

PAUSE は Pentium 4 以降のプロセッサに実装されています。それ以前のプロセッサが NOP (No Operation) と解釈するマシンコードがアサインされています。

◆

pthread_spin_trylock() の実装を見てみましょう。この関数には最適化されたアセンブラコードがアーキテクチャ毎に用意されています。例えば x86 の場合は nptl/sysdeps/i386/i486/pthread_spin_trylock.S です。

#ifdef UP
# define LOCK
#else
# define LOCK lock
#endif

        .globl  pthread_spin_trylock
        .type   pthread_spin_trylock,@function
        .align  16
pthread_spin_trylock:
        movl    4(%esp), %edx
        movl    $1, %eax
        xorl    %ecx, %ecx
        LOCK
        cmpxchgl %ecx, (%edx)
        movl    $EBUSY, %eax
#ifdef HAVE_CMOV
        cmovel  %ecx, %eax
#else
        jne     0f
        movl    %ecx, %eax
0:
#endif
        ret
        .size   pthread_spin_trylock,.-pthread_spin_trylock
		
pthread_spin_lock() の時は DEC 命令でしたが、pthread_spin_trylock() は CMPXCHG 命令でスピンロックオブジェクトが 1 かどうかのテストと 0 のセットをアトミックに実行しています。

スピンロックのインターフェース
glibc では次のスピンロックインターフェースが定義されています。

int pthread_spin_init(pthread_spinlock_t *lock, int pshared);
スピンロックオブジェクト (lock) を初期化します。POSIX では pshared に PTHREAD_PROCESS_SHARED を指定するとスピンロックオブジェクトがプロセス間で共有されると規定されています。しかし glibc の pthread_spin_init() では pshared を見ていません。引数で渡したスピンロックオブジェクトが置かれたメモリが、プロセス内のメモリ空間か共有メモリかによってその性質が決まります。
int pthread_spin_destroy(pthread_spinlock_t *lock);
スピンロックオブジェクト (lock) を破壊します。実際は何も行われません (glibc 2.5.1)
int pthread_spin_lock(pthread_spinlock_t *lock);
スピンロックを獲得します。すでにロック済みだった時はロックできるまでブロックされます。
int pthread_spin_trylock(pthread_spinlock_t *lock);
スピンロックを獲得します。すでにロック済みだった時はエラー終了します (EBUSY)
int pthread_spin_unlock(pthread_spinlock_t *lock);
スピンロックのロックを解除します。
POSIX クロックとタイマー
POSIX クロックとタイマー (POSIX clocks and timers) は POSIX 1003.1b で導入された ANSI C 非標準のオプション機能です。マルチスレッドプログラムやリアルタイムアプリケーションで使用されることを想定した高精度のクロックおよびタイマー機能を提供します。

このインターフェースのために、ナノ秒の精度を持つ timespec 構造体が定義されました。しかし、実際の分解能はカーネルの実装に依存します。バージョン 2.6.16 より前の Linux カーネルでは jiffy をベースに POSIX クロックが実装されていました。jiffy のチックは 10 [msec] 周期ですので、リアルタイムアプリケーションに適用するには十分な分解能とは言えません。

/* POSIX.1b structure for a time value.  This is like a `struct timeval' but
   has nanoseconds instead of microseconds.  */
struct timespec
  {
    __time_t tv_sec;            /* Seconds.  */
    long int tv_nsec;           /* Nanoseconds.  */
  };
		
バージョン 2.6.16 で hrtimers (high resolution timers) が追加され、POSIX クロックとタイマーもこれをベースとした実装になりました (参考 - hrtimers の実装) The Open Group が発行している POSIX と Linux の互換性に関するホワイトペーパにも POSIX タイマーに関する記述があります。

Vine Linux 4.2 (2.6.16) と CentOS 5.2 (2.6.18) で POSIX クロックの分解能を調べてみました。


#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>


int main (void)
{

        struct timespec         res;

        res.tv_sec  = 0;
        res.tv_nsec = 0;

        if (clock_getres(CLOCK_REALTIME, &res) != 0) {
                perror("clock_getres()");
        }
        printf("clock_getres() CLOCK_REALTIME   : %010lu --- %010lu\n",
                res.tv_sec, res.tv_nsec);

        if (clock_getres(CLOCK_MONOTONIC, &res) != 0) {
                perror("clock_getres()");
        }
        printf("clock_getres() CLOCK_MONOTONIC  : %010lu --- %010lu\n",
                res.tv_sec, res.tv_nsec);

}
		
Vine Linux 4.2 で実行します。

$ gcc -o gcc -o clock_resolution clock_resolution.c  -lrt
$ ./clock_resolution
clock_getres() CLOCK_REALTIME   : 0000000000 --- 0010000000
clock_getres() CLOCK_MONOTONIC  : 0000000000 --- 0010000000
		
CentOS 5.2 で実行します。

$ gcc -o gcc -o clock_resolution clock_resolution.c  -lrt
$ ./clock_resolution
clock_getres() CLOCK_REALTIME   : 0000000000 --- 0000999848
clock_getres() CLOCK_MONOTONIC  : 0000000000 --- 0000999848
		
Vine Linux は 10 [msec]、CentOS は約 1 [msec] の分解能です。このようにカーネルのバージョンによって大きく異なりますので、POSIX クロックとタイマー機能を使ったプログラムを作る際にはサポートされているクロックの分解能に注意しなければいけません。

POSIX クロックとタイマーには次のインターフェースが用意されます。

システムコール	説明
clock_gettime()

POSIX クロック値を得ます。

clock_settime()

POSIX クロックをセットします。

clock_getres()

POSIX タイマーの分解能を得ます。

timer_create()

POSIX クロックをベースに新しい POSIX タイマーを作成します。

timer_gettime()

POSIX タイマー値を得てインクリメントします。

timer_settime()

POSIX タイマーをセットしインクリメントします。

timer_getoverrun()

POSIX タイマーがオーバーランした回数を得ます。

timer_delete()

POSIX タイマーを削除します。

clock_nanosleep()

POSIX クロックを基準にスレッドをスリープします。

Linux カーネルはクロックとして CLOCK_REALTIME と CLOCK_MONOTONIC をサポートしています。

CLOCK_REALTIME
システムの仮想的なリアルタイムクロックです。絶対的な時刻を表現しますので、例えば NTP などの外部タイムソースによるシステム時刻変更の影響を受けます。分解能は 999,848 [nsec] ～ 10 [msec] です。clock_gettime() により得られる時刻は xtime (kernel/time.c) の値です。
CLOCK_MONOTONIC
システムの仮想的なリアルタイムクロックです。システムが起動してからの相対的な時刻を表現します。システム時刻変更の影響を受けません。分解能は 999,984 [nsec] ～ 10 [msec] です。clock_gettime() により得られる時刻は xtime + wall_to_monotonic (kernel/time.c) です。
xtime と wall_to_monotonic はカーネルの大域変数として定義されています。以下はカーネル 2.6.21.3 のコードです (kernel/timer.c)

/*
 * The current time
 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
 * at zero at system boot time, so wall_to_monotonic will be negative,
 * however, we will ALWAYS keep the tv_nsec part positive so we can use
 * the usual normalization.
 */
struct timespec xtime __attribute__ ((aligned (16)));
struct timespec wall_to_monotonic __attribute__ ((aligned (16)));

EXPORT_SYMBOL(xtime);
		
CLOCK_REALTIME と CLOCK_MONOTONIC の違いはシステム時刻変更の影響を受けるかどうかです。例えば次のようなプログラムを試してみましょう。このプログラムは一秒おきに CLOCK_REALTIME、CLOCK_MONOTONIC、gettimeofday() の値を表示します。

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>
#include <sys/time.h>


int main (void)
{

	struct timespec		req, res;
	struct timespec		clck;
	struct timeval		tval;

	req.tv_sec  = 1;
	req.tv_nsec = 0;

	while(1) {

		if (clock_gettime(CLOCK_REALTIME, &clck) != 0) {
			perror("clock_gettime()");
		}
		printf("clock_gettime() CLOCK_REALTIME  : %010lu\n", clck.tv_sec);

		if (clock_gettime(CLOCK_MONOTONIC, &clck) != 0) {
			perror("clock_gettime()");
		}
		printf("clock_gettime() CLOCK_MONOTONIC : %010lu\n", clck.tv_sec);

		if (gettimeofday(&tval, NULL) != 0) {
			perror("clock_gettime()");
		}
		printf("gettimeofday()                  : %010lu\n\n", tval.tv_sec);

		nanosleep(&req, &res);

	}

}
		
コンパイルして実行します。

$ gcc -o clock_test clock_test.c -lrt
$ ./clock_test

clock_gettime() CLOCK_REALTIME  : 1248448988
clock_gettime() CLOCK_MONOTONIC : 0000017931
gettimeofday()                  : 1248448988

clock_gettime() CLOCK_REALTIME  : 1248448989
clock_gettime() CLOCK_MONOTONIC : 0000017932
gettimeofday()                  : 1248448989
        .......
		
ここで date コマンドにより日付を変更してみます。

clock_gettime() CLOCK_REALTIME  : 1248448990
clock_gettime() CLOCK_MONOTONIC : 0000017933
gettimeofday()                  : 1248448990

clock_gettime() CLOCK_REALTIME  : 1662559200
clock_gettime() CLOCK_MONOTONIC : 0000017934
gettimeofday()                  : 1662559200

clock_gettime() CLOCK_REALTIME  : 1662559201
clock_gettime() CLOCK_MONOTONIC : 0000017935
gettimeofday()                  : 1662559201
        .......
		
CLOCK_REALTIME と gettimeofday() が変更の影響を受けました。

◆

同期オブジェクトには、指定した時刻までロックを待つインターフェースが用意されています。具体的には pthread_mutex_timedlock()、sem_timedwait()、pthread_rwlock_timedrdlock()、pthread_rwlock_timedwrlock() といった関数です。例えば mutex の場合、POSIX では次のインターフェースが規定されています。

int pthread_mutex_timedlock(pthread_mutex_t *restrict mutex,
                            const struct timespec *restrict abs_timeout);
		
この関数を呼ぶと mutex をロックしようとします。しかし、他のスレッドがすでにロックしていた時は abs_timeout まで待ちます。それでもロックできなかった場合はエラー終了します (ETIMEDOUT) ここで abs_timeout に指定する時刻は CLOCK_REALTIME がベースとなります。

他の sem_timedwait()、pthread_rwlock_timedrdlock()、pthread_rwlock_timedwrlock() でも abs_timeout に指定する時刻は CLOCK_REALTIME ベースになります。条件変数はクロック属性に CLOCK_REALTIME か CLOCK_MONOTONIC を指定します。pthread_cond_timedwait() 指定されたクロックを基準に動作します。

◆

例として pthread_mutex_timedlock() のプリミティブな操作を提供する __lll_timedlock_wait() の実装を見てみましょう。この関数には最適化されたアセンブラコードがアーキテクチャ毎に用意されています。例えば x86 の場合は __lll_mutex_timedlock_wait - nptl/sysdeps/unix/sysv/linux/i386/i486/lowlevellock.S です。ここでは C 言語で書かれた nptl/sysdeps/unix/sysv/linux/lowlevellock.c を引用します。glibc 2.5.1 から引用しました。

int
__lll_timedlock_wait (int *futex, const struct timespec *abstime)
{
  /* Reject invalid timeouts.  */
  if (abstime->tv_nsec < 0 || abstime->tv_nsec => 1000000000)
    return EINVAL;

  do
    {
      struct timeval tv;
      struct timespec rt;

      /* Get the current time.  */
      (void) __gettimeofday (&tv, NULL);

      /* Compute relative timeout.  */
      rt.tv_sec = abstime->tv_sec - tv.tv_sec;
      rt.tv_nsec = abstime->tv_nsec - tv.tv_usec * 1000;
      if (rt.tv_nsec < 0)
        {
          rt.tv_nsec += 1000000000;
          --rt.tv_sec;
        }

      /* Already timed out?  */
      if (rt.tv_sec < 0)
        return ETIMEDOUT;

      /* Wait.  */
      int oldval = atomic_compare_and_exchange_val_acq (futex, 2, 1);
      if (oldval != 0)
        lll_futex_timed_wait (futex, 2, &rt);
    }
  while (atomic_compare_and_exchange_bool_acq (futex, 2, 0) != 0);

  return 0;
}
		
POSIX で規定されたインターフェースが絶対時刻を指定することになっていたのに対し、lll_futex_timed_wait() の第三引数は最大何ナノ秒まで待つのかをtimespec 構造体で指定します。このため __gettimeofday() を呼び出して現在時刻を取得し、abstime との差を計算することにより最大待ち時間を計算しています。

見た通り __gettimeofday() の呼び出しと最大待ち時間の計算がアトミックに処理されていません。__gettimeofday() で tv に時刻が格納された直後に割り込まれると、想定よりも長く待ってしまうことがあります。タイミングが重要となる処理を行う場合は注意が必要です。回避策としては、リアルタイムスケジューリングポリシーで高い優先度を与えるなどの方法が考えられます。

機器や設定によっては、最初の電源投入時にシステムクロックが修正されることがあります。CLOCK_REALTIME ベースで処理を行っていると、突然時刻が進んだり退行したりすることになります。タイミングと処理内容によっては思わぬ不具合の原因となることがあるので注意が必要です。

スレッドの属性
スレッドはそれぞれ属性を持ちます。属性オブジェクト (pthread_attr_t) をそれぞれの属性に関連づけられたインターフェースにより設定した上で、pthread_create() の引数で渡します。次の属性がサポートされています。

デタッチ状態 (detachstate)
スレッドが合流可能な状態 (PTHREAD_CREATE_JOINABLE) で生成されるのか、デタッチ状態 (PTHREAD_CREATE_DETACHED) で生成されるのかを指定します。デフォルト値は PTHREAD_CREATE_JOINABLE です。
合流可能な状態の場合、別のスレッドが pthread_join() を呼び出すことによって、そのスレッドの終了に同期して終了コードを取得することができます。スレッドの資源の一部はスレッドが終了した後も確保されたまま残り、そのスレッドに対して pthread_join() が呼び出された時に解放されます。
デタッチ状態の場合、pthread_join() によりスレッドの終了に同期することはできません。スレッドの資源は終了時ただちに解放されます。合流可能な状態で生成されたスレッドは pthread_detach() を呼び出してデタッチスレッドに変更することができます。
スケジューリングポリシー (schedpolicy)
スレッドのスケジューリングポリシーを指定します。SCHED_OTHER (リアルタイムではないスケジューリング) 、 SCHED_RR (ラウンドロビン方式のリアルタイムスケジューリング) 、 SCHED_FIFO (FIFO 方式のリアルタイムスケジューリング) のいずれかを指定します。デフォルト値は SCHED_OTHER です。スレッド生成後に pthread_setschedparam() を用いて変更することができます。
スケジューリングパラメータ (schedparam)
スレッドのスケジューリングパラメータを指定する。glibc (2.3.4 / 2.5.1) ではリアルタイムスケジューリング時の優先度になります。デフォルト値は 0 です。スレッド生成後に pthread_setschedparam() を用いて変更することができます。
スケジューリングの継承 (inheritsched)
pthread_create() 時にスケジューリングポリシーとスケジューリングパラメータ属性を親スレッドから継承するかどうかを指定します。継承する (PTHREAD_INHERIT_SCHED) が指定された時は親スレッドの属性を引き継ぎます。属性オブジェクトの設定値は無視されます。明示的な指定 (PTHREAD_EXPLICIT_SCHED) が指定された時は、属性オブジェクトで指定した値が設定されます。デフォルト値は PTHREAD_EXPLICIT_SCHED です。
スコープ (scope)
スケジューリングの競合が行われる範囲を指定します。システム上の全てのスレッドと競合する PTHREAD_SCOPE_SYSTEM か、プロセス内の全てのスレッドと競合する PTHREAD_SCOPE_PROCESS を指定します。デフォルト値は PTHREAD_SCOPE_SYSTEM です。
スタックアドレス (stackaddr)
スレッドが使用するスタックのアドレスを指定します。
スタックサイズ (stacksize)
スレッドに対して確保されるスタックのサイズを指定します。
スタック (stack)
スタックのアドレスとサイズの両方を指定します。
保護サイズ (guardsize)
スタックの保護領域のサイズを指定します。
pthread_create() の実装
(つづく)

スレッドスケジューリング
スケジューリングポリシー
優先度
スコープ
スケジューリングインターフェース
デタッチ状態
スタック
シグナルとスレッド
キャンセル
用語
参考文献
The Open Group, IEEE Std 1003.1, 2004
高林 哲、鵜飼 文敏、佐藤 祐介、浜地 慎一郎、首藤 一幸、『BINARY HACKS』、初版第一刷、オライリー・ジャパン、2006 年
Daniel P. Bovet, Marco Cesati, "Understanding the LINUX KERNEL", 3rd Edition, O'Reilly Media, 2005.
インテル、『IA-32 ソフトウェア・デベロッパーズ・マニュアル』、上巻、基本アーキテクチャ、2004 年
インテル、『IA-32 ソフトウェア・デベロッパーズ・マニュアル』、中巻 A、命令セット A-M、2004 年
インテル、『IA-32 ソフトウェア・デベロッパーズ・マニュアル』、中巻 A、命令セット N-Z、2004 年
インテル、『IA-32 ソフトウェア・デベロッパーズ・マニュアル』、下巻、システムプログラミングガイド、2004 年
Intel, "Intel 64 and IA-32 Architectures Software Developer's Manual", Volume 1, Basic Architecture, 2009
Intel, "Intel 64 and IA-32 Architectures Software Developer's Manual", Volume 2A, Instruction Set Reference A-M, 2009
Intel, "Intel 64 and IA-32 Architectures Software Developer's Manual", Volume 2B, Instruction Set Reference N-Z, 2009
Intel, "Intel 64 and IA-32 Architectures Software Developer's Manual", Volume 3A, System Programming Guid, Part1, 2009
Intel, "Intel 64 and IA-32 Architectures Software Developer's Manual", Volume 3B, System Programming Guid, Part2, 2009
山崎 傑、『オペレーティングシステム入門』、初版、CQ 出版社、2005 年
Randall Hyde (著)、鵜飼 文敏 (監訳)、後藤正徳 (監訳)、まつもとゆきひろ (監訳)、『Write Great Code Vol.1』、初版第三刷、毎日コミュニケーションズ、2007 年
Urich Drepper, Ingo Molnar, "The Native POSIX Thread Library for Linux", 2005
Thomas Gleixner, Douglas Niehaus, "Hrtimers and Beyond: Transforming the Linux Time", Proceedings of the Linux Symposium, Volume One, pp. 333 - 346, Ottawa, Ontario, Canada, 2006
C. Douglass Locke, Ph.D., "POSIX and Linux Application Compatibility Designe Rules", Version 1.0, 2006
Copyright (c) 2009 Hiroki Takada All Rights Reserved.
</pre>
