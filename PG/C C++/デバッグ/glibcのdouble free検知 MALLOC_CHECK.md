## [glibcのdouble free検知](https://blog.cles.jp/item/3622)

C 言語についていろいろ調べていて、わざとダブルフリーするようなプログラムを書くと glibc がスタックトレースを吐いて ABORT することに気づきました。バリバリ C を使う人にとっては当たり前の挙動なのかもしれませんが、プログラミングの道には最初から Java で入ってしまったので、メモリ管理を自分でやる言語をほとんどメインで使ったことがない自分にとっては興味深い挙動でした。<br>

### test.c

<pre>
#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;

int main(){
  int *i = malloc(sizeof(int));
  free(i);
  free(i);
  return 0;
}
</pre>

例えば上記のようなプログラムを実行すると下記のような出力になるようです。<br>

<pre>
$ gcc test.c
$ ./a.out
 *** glibc detected *** ./a.out: double free or corruption (fasttop): 0x09ae0008 ***
======= Backtrace: =========
/lib/libc.so.6[0x2215a5]
/lib/libc.so.6(cfree+0x59)[0x2219e9]
./a.out[0x804840a]
/lib/libc.so.6(__libc_start_main+0xdc)[0x1cde9c]
./a.out[0x8048321]
======= Memory map: ========
00199000-001b4000 r-xp 00000000 08:02 53674048   /lib/ld-2.5.so
001b4000-001b5000 r-xp 0001a000 08:02 53674048   /lib/ld-2.5.so
001b5000-001b6000 rwxp 0001b000 08:02 53674048   /lib/ld-2.5.so
001b8000-0030a000 r-xp 00000000 08:02 53674260   /lib/libc-2.5.so
0030a000-0030c000 r-xp 00152000 08:02 53674260   /lib/libc-2.5.so
0030c000-0030d000 rwxp 00154000 08:02 53674260   /lib/libc-2.5.so
0030d000-00310000 rwxp 0030d000 00:00 0
003e1000-003ec000 r-xp 00000000 08:02 53674904   /lib/libgcc_s-4.1.2-20080825.so.1
003ec000-003ed000 rwxp 0000a000 08:02 53674904   /lib/libgcc_s-4.1.2-20080825.so.1
009f8000-009f9000 r-xp 009f8000 00:00 0          [vdso]
08048000-08049000 r-xp 00000000 08:02 40763512   /tmp/a.out
08049000-0804a000 rw-p 00000000 08:02 40763512   /tmp/a.out
09ae0000-09b01000 rw-p 09ae0000 00:00 0          [heap]
b7f1e000-b7f1f000 rw-p b7f1e000 00:00 0
b7f31000-b7f32000 rw-p b7f31000 00:00 0
bfc55000-bfc6a000 rw-p bffea000 00:00 0          [stack]
Aborted
</pre>

ちなみにこの挙動についてはMALLOC_CHECK_で調整できるようです。<br>
### man malloc 3
<pre>
Recent versions of Linux libc (later than 5.4.23) and GNU libc (2.x) include a malloc implementation which is tunable via environment variables. When MALLOC_CHECK_ is set, a special (less efficient) implementation is used which is designed to be tolerant against simple errors, such as double calls of free() with the same argument, or overruns of a single byte (off-by-one bugs). Not all such errors can be protected against, however, and memory leaks can result. If MALLOC_CHECK_ is set to 0, any detected heap corruption is silently ignored and an error message is not generated; if set to 1, the error message is printed on stderr, but the program is not aborted; if set to 2, abort() is called immediately, but the error message is not generated; if set to 3, the error message is printed on stderr and program is aborted. This can be useful because otherwise a crash may happen much later, and the true cause for the problem is then very hard to track down.
</pre>

ということで、 MALLOC_CHECK_ を変えて実行するとこんな感じ。<br>

<pre>
$ MALLOC_CHECK_=0 ./a.out
$ MALLOC_CHECK_=1 ./a.out
malloc: using debugging hooks
 *** glibc detected *** ./a.out: free(): invalid pointer: 0x09aec008 ***
$ MALLOC_CHECK_=2 ./a.out
Aborted
$ MALLOC_CHECK_=3 ./a.out
malloc: using debugging hooks
 *** glibc detected *** ./a.out: free(): invalid pointer: 0x08799008 ***
======= Backtrace: =========
/lib/libc.so.6[0x224f4c]
/lib/libc.so.6(cfree+0xdb)[0x221a6b]
./a.out[0x804840a]
/lib/libc.so.6(__libc_start_main+0xdc)[0x1cde9c]
./a.out[0x8048321]
======= Memory map: ========
00199000-001b4000 r-xp 00000000 08:02 53674048   /lib/ld-2.5.so
001b4000-001b5000 r-xp 0001a000 08:02 53674048   /lib/ld-2.5.so
001b5000-001b6000 rwxp 0001b000 08:02 53674048   /lib/ld-2.5.so
001b8000-0030a000 r-xp 00000000 08:02 53674260   /lib/libc-2.5.so
0030a000-0030c000 r-xp 00152000 08:02 53674260   /lib/libc-2.5.so
0030c000-0030d000 rwxp 00154000 08:02 53674260   /lib/libc-2.5.so
0030d000-00310000 rwxp 0030d000 00:00 0
003e1000-003ec000 r-xp 00000000 08:02 53674904   /lib/libgcc_s-4.1.2-20080825.so.1
003ec000-003ed000 rwxp 0000a000 08:02 53674904   /lib/libgcc_s-4.1.2-20080825.so.1
00bed000-00bee000 r-xp 00bed000 00:00 0          [vdso]
08048000-08049000 r-xp 00000000 08:02 40763512   /tmp/a.out
08049000-0804a000 rw-p 00000000 08:02 40763512   /tmp/a.out
08799000-087ba000 rw-p 08799000 00:00 0          [heap]
b7f9c000-b7f9d000 rw-p b7f9c000 00:00 0
b7faf000-b7fb0000 rw-p b7faf000 00:00 0
bf9fc000-bfa11000 rw-p bffea000 00:00 0          [stack]
Aborted
</pre>
