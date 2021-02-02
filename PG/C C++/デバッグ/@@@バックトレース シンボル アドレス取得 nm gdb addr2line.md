## [* .soファイルで関数アドレスを関数にマップする方法](https://stackoverflow.com/questions/7556045/how-to-map-function-address-to-function-in-so-files)

したがって、-g（または-rdynamic）を使用してコンパイルした場合は、幸運です。次のことができるはずです。<br>
```
$ # get the address in the ELF so using objdump or nm
$ nm libtst.so | grep myfunc
0000073c T myfunc5
$ # get the (hex) address after adding the offset 
$ # from the start of the symbol (as provided by backtrace_syms())
$ python -c 'print hex(0x0000073c+0x2b)'
0x767
$ # use addr2line to get the line information, assuming any is available            
addr2line -e libtst.so 0x767
```

または、gdbを使用します。<br>
```
$ gdb libtst.so
(gdb) info address myfunc
Symbol "myfunc" is at 0x073c in a file compiled without debugging. # (Faked output)
(gdb) info line *(0x073c+0x2b)
Line 27 of "foo.cpp" starts at address 0x767 <myfunc()+21> and ends at 0x769 <something>. # (Faked output)
```
また、ライブラリを削除したが、後で使用するためにデバッグシンボルを隠しておいた場合は、backtrace_syms（）によってELFオフセットのみが出力され、シンボル名は出力されない可能性があります（元の質問ではそうではありません）。この場合、gdbを使用する方が、他のコマンドラインツールを使用するよりも間違いなく便利です。これを行ったと仮定すると、次のようにgdbを呼び出す必要があります（たとえば）。<br>
```
$ gdb -s debug/libtst.debug -e libtst.so
```

---

```
objdump -x --disassemble -l <objfile>
```
これは、とりわけ、マシンコードのコンパイルされた各命令を、それが由来するCファイルの行とともにダンプする必要があります<br>

---

実行時eu-addr2line（ライブラリを自動的に検索してオフセットを計算します）：<br>

```
//-------------------------------------
#include <sys/types.h>
#include <unistd.h>

int i;
#define SIZE 100
void *buffer[100];

int nptrs = backtrace(buffer, SIZE);

for (i = 1; i < nptrs; ++i) {
    char syscom[1024];
    syscom[0] = '\0';
    snprintf(syscom, 1024, "eu-addr2line '%p' --pid=%d > /dev/stderr\n", buffer[i], getpid());
    if (system(syscom) != 0)
        fprintf(stderr, "eu-addr2line failed\n");
}
```

`--debuginfo-path=...`デバッグファイルが別の場所にある場合（ビルドIDなどと一致する場合）は、オプションを固定します。<br>

`eu-addr2line` elfutilsディストリビューションのパッケージに含まれています。<br>

