引用<br/>
[mmapというファイルやデバイスをメモリーにマップするシステムコールの解説](https://www.ncaq.net/2018/01/19/10/27/30/)<br/>

# mmapというファイルやデバイスをメモリーにマップするシステムコールの解説

## 概要

mmapとは,ファイルやデバイスをメモリーにマップするシステムコールです.<br/>
一応mmapはPOSIXに含まれているシステムコールです.<br/>
しかし,POSIXに定義されている動作はごく一部で,特にflags引数に指定できるのは`MAP_FIXED`, `MAP_PRIVATE`, `MAP_SHARED`の3つしかなく,無名ページもサポートしていません.<br/>
それぞれのUNIXが独自に拡張しており,ゆるい共通APIを持っていますが厳格な規格にはなっていないようです.<br/>

## mmapの引数

mmapの引数を軽く説明します.<br/>

* `void* addr`: カーネルがメモリのどの位置にアドレスを配置するかヒントを設定できる,通常NULLで動かす
* `size_t length`: 確保するページのサイズ
* `int prot`: ページが実行可能,書き込み可能,読み込み可能かを論理和でモード指定する
* `int flags`: 色々な設定を論理和で行う
* `int fd`: ファイルディスクリプタ
* `off_t offset`: ファイルをどの部分から読み込むかのオフセット

## flagsの意味のある非推奨ではないフラグ

flagsには互換性のために現在は使われなくなったり,非推奨になったフラグがとても多いため,Manに書かれているもので非推奨ではない,現在使う意義のあるものだけを抽出してみます.<br/>

* `MAP_SHARED`: マッピングを共有して,更新がファイルをマッピングしている他のプロセスに見えるようになる,マップ元のファイルが変更されるとマップ領域も更新される
* `MAP_PRIVATE`: マッピングをプライベートにして,同じファイルをマッピングしている他のプロセスに更新が見えなくなる,マップ元のファイルが変更されてもマップ領域が変更されるかは規定されていない
* `MAP_ANONYMOUS`: マッピングがファイルと関連付けされなくなる
* `MAP_GROWSDOWN`: マッピングをメモリ上で逆順に行う
* `MAP_HUGETLB`: 大きいページサイズを使用する
* `MAP_LOCKED`: メモリがスワップ領域にページングされるのを防ぐ
* `MAP_NORESERVE`: スワップ空間の予約を行わない,これを選択した場合,書き込み時に物理メモリに空きがないとSIGSEGVを受け取ることがある
* `MAP_POPULATE`: ファイルマッピングの場合ファイルが先読みされるので,アクセス時にページフォールトしなくなる
* `MAP_UNINITIALIZED`: 無名ページのクリアを行わない,カーネルの設定で有効になっていないと効果を発揮しない,セキュリティを犠牲にパフォーマンスが向上する

## ファイルマッピングと無名マッピング
引数`flags`に`MAP_ANONYMOUS`を指定せずに,引数`fd`にファイルオープン関数`open`の返り値を渡した場合,mmapはファイルマッピングモードとなり,SHAREDモードの場合マッピングされた領域に書き込みされた場合ファイルを更新します.<br/>
引数`offset`はファイルを何処から読み込むというオフセットに使われます.<br/>

引数`flags`に`MAP_ANONYMOUS`を論理和で指定した場合,mmapはファイルを使わずに無名マッピングモードになり,Linuxの場合`fd`と`offset`は無視されます.<br/>
しかし,他の実装は`MAP_ANONYMOUS`を使う場合`fd`を`-1`にすることを要求する可能性があるため,移植性のため`fd`には`-1`を指定するべきでしょう.<br/>
`offset`はどうするべきか書いてなかったのですが多分`0`で良いでしょう.<br/>
この無名マッピングモードでマップされたメモリ領域をanonymous メモリーと呼ぶことがあります.<br/>

## SHAREDモードとPRIVATEモード
`MAP_SHARED`を指定するとmmapはSHAREDモードとなり,そのマッピングに対する更新は同じファイルをマッピングしている他のプロセスにも見えるようになります.<br/>
これは簡易的なプロセス間通信に使うことができます.<br/>
`MAP_PRIVATE`を使うと,マッピングはそれぞれのプロセス間で独立します.<br/>
forkしたりしてプロセスを分けると,更新は共有されないということです.<br/>
かと言って全てがコピーされて複製されるわけではなく,コピーオンライトを使って,変更が行われたときのみコピーされます.<br/>

## mmapを使ってabcと書かれているファイルのbをdに変えるサンプルコード

manにかかれていたサンプルコードはエラー処理などが長かったので簡単なサンプルコードを書きました.<br/>
C99です.<br/>

<pre>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/stat.h>

int main() {
    int fd = open("abc.txt", O_RDWR);
    struct stat stat_buf;
    fstat(fd, &stat_buf);
    char* addr = mmap(NULL, stat_buf.st_size, PROT_WRITE, MAP_SHARED, fd, 0);
    addr[1] = 'd';
    return 0;
}
</pre>

## mallocはどのようにmmapを使っているか
mallocの著名な実装は,メモリ領域を確保するためにmmapの無名マッピングモードを使っています.<br/>
glibc-2.26の/malloc/malloc.cを見てみました.<br/>
以下のマクロが定義されて使われていました.<br/>

<pre>
#define MMAP(addr, size, prot, flags) \
__mmap((addr), (size), (prot), (flags)|MAP_ANONYMOUS|MAP_PRIVATE, -1, 0)
</pre>
 
forkした後,他のプロセスがページ内容を変更した時に,それぞれのメモリ領域を独立させる必要があるので,匿名目マッピングモードかつPRIVATEモードになっています.<br/>
 
## msync
 
msyncはファイルをマップしたメモリーと同期させるシステムコールです.<br/>
これも一応POSIXにあります.<br/>
mmapでマップされたファイルの更新は非同期に行われることがあるので,これを使えば同期的に行うことが可能です.<br/>

## munmap
mmapでのマップを解除します.<br/>
これも一応POSIXにあります.<br/>
プロセスが終了した時に自動的にアンマップされるので,メモリ管理を提供したりするプログラムを書く場合以外は気にしなくても良さそうですね.<br/>
解除された領域にアクセスした場合SIGSEGVが発生します.<br/>

## 参考文献

* [Man page of MMAP](https://linuxjm.osdn.jp/html/LDP_man-pages/man2/mmap.2.html)
* [The Open Group Base Specifications Issue 7, 2016 Edition](http://pubs.opengroup.org/onlinepubs/9699919799/)
* [ラージページについての考察 | iSUS](https://www.isus.jp/hpc/large-page-considerations/)
* [スワップ空間について](https://docs.oracle.com/cd/E19504-01/805-1753/6j1n2ina7/index.html)
* [Linuxのメモリの本当の必要量を考える(メモ) – Chienomi](http://chienomi.reasonset.net/archives/livewithlinux/732)
* [cgroupsとメモリ資源と関係を勉強する前に、Linuxの仮想記憶周りを読む... - Qiita](https://qiita.com/akachochin/items/cbda5d83ec220295add5)
