## [プログラムがクラッシュしたときにスタックトレースを自動的に生成する方法](https://www.it-swarm-ja.tech/ja/c%2B%2B/%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%A0%E3%81%8C%E3%82%AF%E3%83%A9%E3%83%83%E3%82%B7%E3%83%A5%E3%81%97%E3%81%9F%E3%81%A8%E3%81%8D%E3%81%AB%E3%82%B9%E3%82%BF%E3%83%83%E3%82%AF%E3%83%88%E3%83%AC%E3%83%BC%E3%82%B9%E3%82%92%E8%87%AA%E5%8B%95%E7%9A%84%E3%81%AB%E7%94%9F%E6%88%90%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95/957386881/)
## [プログラムcrashesのときにスタックトレースを自動的に生成する方法](https://python5.com/q/jhqmomib)

<pre>
#include &lt;stdio.h&gt;
#include &lt;execinfo.h&gt;
#include &lt;signal.h&gt;
#include &lt;stdlib.h&gt;
#include &lt;unistd.h&gt;


void handler(int sig) {
  void *array[10];
  size_t size;

  // get void*'s for all entries on the stack
  size = backtrace(array, 10);

  // print out all the frames to stderr
  fprintf(stderr, "Error: signal %d:\n", sig);
  backtrace_symbols_fd(array, size, STDERR_FILENO);
  exit(1);
}

void baz() {
 int *foo = (int*)-1; // make a bad pointer
  printf("%d\n", *foo);       // causes segfault
}

void bar() { baz(); }
void foo() { bar(); }


int main(int argc, char **argv) {
  signal(SIGSEGV, handler);   // install our handler
  foo(); // this will call foo, bar, and baz.  baz segfaults.
}
</pre>



<br>
<br>
<br>

## [glibc でバックトレースを表示する方法(その2)](https://pyopyopyo.hatenablog.com/entry/20171106/p1)

## コード
### プロトタイプ宣言
<pre>
extern "C" void dump_backtrace(FILE *fp, const char *format);
</pre>
です．extern "C" をつけているので C言語でも C++からでも利用できます<br>
### 実装
<pre>
#include &lt;execinfo.h&gt;
#include &lt;strings.h&gt;
#include &lt;stdio.h&gt;
extern "C" void
dump_backtrace(FILE *fp, const char *format)
{
    void *trace[128];
    int n = backtrace(trace, sizeof(trace) / sizeof(trace[0]));
    char **strings = backtrace_symbols(trace, n);
    if (!strings) {
	perror("backtrace_symbols() returns NULL");
	return;
    }
    size_t demangled_sz = 1024;
    char *demangled_str = (char*)malloc(demangled_sz);
    if (!demangled_str) {
	perror("malloc() returns NULL");
	return;
    }
    int j;
    for (j = 0; j < n; j++) {
        //  strings[j] には "ファイル名 ( シンボル名 + オフセット) アドレス" という形式の文字列が格納されてるので
        //  "("　から "+"　の部分を探して，シンボル名を切り出す
	char *start  = index(strings[j], '(');
	char *offset = index(start, '+');
	if (offset - start > 1) {
            // シンボル名が見つかった場合は demangle する
	    *start = '\0';
	    *offset = '\0';
	    char *symbol = (start+1);
	    char *ret = abi::__cxa_demangle(symbol, demangled_str, &demangled_sz, NULL);
	    if (ret) {
		demangled_str = ret;
	    } else {
		ret = NULL;
	    }
	    char tmp[1024*4];
	    const char *tail = tmp + sizeof(tmp);
	    char *cur = tmp;
	    cur += snprintf(cur, tail-cur, strings[j]);
	    cur += snprintf(cur, tail-cur, "(%s+%s)", ret?ret:"", (offset+1));
	    fprintf(fp, format, tmp);
	} else {
            // シンボル名が見つからない場合は，そのまま何も変換せず，出力
	    fprintf(fp, format, strings[j]);
	}
    }
    free(demangled_str);
    free(strings);
}
</pre>

### 使い方
使用方法は関数を呼ぶだけです．たとえばバックトレースを /dev/stderr に出力する場合は<br>
<pre>
  dump_backtrace(stderr, "%s\n");
</pre>
ファイルに出力する場合，たとえばファイル名が log.txt の場合は<br>
<pre>
  FILE *fp = fopen("log.txt", "w");
  if (fp) {
   dump_backtrace(fp, "%s\n");
   fclose(fp);
  }
</pre>

### abi::__cxa_demangle() について
abi::__cxa_demangle() は気をつけないとメモリリークします．<br>
abi::__cxa_demangle() の定義は以下の通りですが<br>
<pre>
char* abi::__cxa_demangle 	( 	const char *  	mangled_name,
		char *  	output_buffer,
		size_t *  	length,
		int *  	status	 
	) 
</pre>
ここで戻り値に注意しないと memory leak します<br>

戻り値は

* demangle に成功した場合は realloc(output_buffer) の結果
* demangle に失敗した場合は NULL

になります．この点を考慮していないコード，たとえば以下のコードはメモリリークする場合があります<br>

<pre>
// メモリリークする可能性があるコード(その1)
size_t sz = 128;
char *buf = malloc(sz):
abi::__cxa_demangle ("シンボル名", buf, &sz, NULL);
free(buf);
</pre>
このコードは，abi::__cxa_demangle ()が内部で realloc(buf) を実行し， バッファのアドレスがbufから別アドレスに変わった場合にメモリリークします．<br>

<pre>
// メモリリークする可能性があるコード(その2)
size_t sz = 128;
char *buf = malloc(sz):
buf = abi::__cxa_demangle ("シンボル名", buf, &sz, NULL);
free(buf);
</pre>
abi::__cxa_demangle ()はdemangle に失敗するとNULLを返します．つまり buf がNULLに置き換わります．結果，末尾の free(buf)では mallocで確保したメモリが開放できず メモリリークします．<br>
<br>
abi::__cxa_demangle の戻り値が NULL か 非NULLか判定するとこれらのリークを回避できます<br>
<pre>
// 正しい使い方の例
size_t sz = 128;
char *buf = malloc(sz):
char *ret = abi::__cxa_demangle ("シンボル名", buf, &sz, NULL);
if (ret) {
    buf = ret;
}
free(buf);
</pre>
