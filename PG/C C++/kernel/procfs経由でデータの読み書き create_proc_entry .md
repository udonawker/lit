引用 [procfs経由でデータの読み書き](https://kernhack.hatenablog.com/entry/20100315/1268662409) <br/>

今日はprocfs経由でデータの読み書きしようというのをやってみました。<br/>
ここを参考にしました。<br/>
[The Linux Kernel Module Programming Guide](http://www.linuxtopia.org/online_books/Linux_Kernel_Module_Programming_Guide/x773.html)<br/>
こんな感じの動作になります。<br/>

<pre>
lisa:~# cat /proc/proc_test 
Hello, World
lisa:~# echo -n "foobarbaz" > /proc/proc_test 
lisa:~# cat /proc/proc_test 
foobarbaz
</pre>

Makefileはこれです。<br/>

<pre>
&lt;BUILD_DIR := $(shell pwd)
VERBOSE = 0
KERNDIR    := /lib/modules/$(shell uname -r)/build

obj-m := proc_test.o

#proc_test-objs := proc_test.o

all:
	make -C $(KERNDIR) SUBDIRS=$(BUILD_DIR) KBUILD_VERBOSE=$(VERBOSE) modules

clean:
	rm -f *.o
	rm -f *.ko	
	rm -f *.mod.c
	rm -f *~
</pre>

そして実装はこちらです。<br/>

<pre>
#include &lt;linux/module.h&gt;
#include &lt;linux/kernel.h&gt;
#include &lt;linux/types.h&gt;
#include &lt;linux/fs.h&gt;
#include &lt;linux/proc_fs.h&gt;
#include &lt;linux/stat.h&gt;
#include &lt;linux/string.h&gt;
#include &lt;asm/uaccess.h&gt;

MODULE_DESCRIPTION("proc file system test");
MODULE_AUTHOR("masami256");
MODULE_LICENSE("GPL");

static const char const module_name[] = "proc_test";

static int proc_test_read(char *page, char **start, off_t off,
		  int count, int *eof, void *data);

static int proc_test_write(struct file *file, const char __user *buffer,
		    unsigned long count, void *data);

static struct proc_dir_entry *pdir_entry;

static int proc_test_init(void)
{
	printk(KERN_INFO "%s\n", __FUNCTION__);

	pdir_entry = create_proc_entry(module_name, 0644, NULL);
	if (!pdir_entry) {
		remove_proc_entry(module_name, NULL);
		return -EFAULT;
	}

	pdir_entry-&gt;mode = S_IRUGO;
	pdir_entry-&gt;gid = 0;
	pdir_entry-&gt;uid = 0;
	pdir_entry-&gt;read_proc = (read_proc_t *) proc_test_read;
	pdir_entry-&gt;write_proc = (write_proc_t *) proc_test_write;

	return 0;
}

static void proc_test_cleanup(void)
{
	printk(KERN_INFO "%s\n", __FUNCTION__);
	remove_proc_entry(module_name, NULL);
}

static char proc_test_buf[256] = "Hello, World";

static int proc_test_read(char *page, char **start, off_t off,
		  int count, int *eof, void *data)
{
	int len = 0;

	len = sprintf(page, "%s\n", proc_test_buf);
	*peof = 1;

	return len;
}


static int proc_test_write(struct file *file, const char __user *buffer,
		    unsigned long count, void *data)
{
	if (count &gt; 256)
		return -EINVAL;

	if (!buffer)
		return -EINVAL;
	
	memset(proc_test_buf, 0x0, sizeof(proc_test_buf));
	if (copy_from_user(proc_test_buf, buffer, count))
		return -EFAULT;

	return count;
}


module_init(proc_test_init);
module_exit(proc_test_cleanup);

</pre>

最初と最後で必ずするのは、procfsへの登録と解除で、create_proc_entry()とremove_proc_entry()を使います。<br/>
これらの2番目の引数は、以下のようにparentとなっているので、/proc直下にファイルを作る分にはNULLで大丈夫です。<br/>
直下にしか作ってないので試してないですが・・・<br/>

<pre>
struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
                                         struct proc_dir_entry *parent)
</pre>

procファイルシステムで使う構造体はstruct proc_dir_entryで、これのメンバ変数、read_procとwrite_procに関数を設定してあげます。<br/>
この構造体はinclude/linux/proc_fs.hで以下の用にtypedefされてます。<br/>

<pre>
typedef int (read_proc_t)(char *page, char **start, off_t off,
                          int count, int *eof, void *data);
typedef int (write_proc_t)(struct file *file, const char __user *buffer,
                           unsigned long count, void *data);
</pre>

ちなみに、read_proc()はfs/proc/generic.cの__proc_file_read()から呼ばれます。<br/>
write_procは同ファイルのproc_file_write()からです。<br/>
カーネルモジュールとしてロードするので、insmodすれば/procに/proc/proc_testが出来て、rmmodすれば無くなります。<br/>
