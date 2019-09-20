引用<br/>
[ファイルの読み書きにmmapを使ってみる](https://corgi-lab.com/programming/c-lang/use-mmap/)<br/>

## mmapを使ったwrite
### サンプルプログラム

mmapを使うための作法でちょくちょくつまずきましたが、以下のプログラムで読み出せました。ポイントはマッピングするときのサイズをページサイズの整数倍にすることでしょうか。<br/>

<pre>
#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
 
#define FILE_SIZE 1024
 
int main(void) {
    int fd;
    char *map;
    long page_size, map_size;
 
    fd = open("testFile", O_RDONLY);
 
    if(fd < 0) {
        printf("Error : can't open file\n");
        return -1;
    }
 
    /* ページサイズからマッピング時のサイズを計算 */
    page_size = getpagesize();
    map_size = (FILE_SIZE / page_size + 1) * page_size;
 
    /* メモリ上にマッピング。今回は文字列データとして扱えるようにする */
    map = (char*)mmap(NULL, map_size, PROT_READ, MAP_SHARED, fd, 0);
 
    if (mmap == MAP_FAILED) {
        printf("Error : mmap failed\n");
        return -1;
    }
 
    /* ファイルの中身をはき出す */
    printf("%s", map);
    
    close(fd);
    munmap(map, map_size);
 
    return 0;
}
</pre>

### 実行結果

<pre>
$ gcc read_test.c -o read_test
$ ./read_test
This is test file for using mmap.
mmap is useful for read/write file.
</pre>

## mmapを使ったwrite
### サンプルプログラム

<pre>
#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <string.h>
 
#define FILE_SIZE 1024
 
int main(void) {
    int fd;
    char *map;
    char c = 0;
    long page_size, map_size;
 
    fd = open("writeFile", O_CREAT | O_RDWR, 0666);
    if(fd < 0) {
        printf("Error : can't open file\n");
        return -1;
    }
 
    page_size = getpagesize();
    map_size = (FILE_SIZE / page_size + 1) * page_size;
 
    /* 下処理 */
    lseek(fd, map_size, SEEK_SET);
    write(fd, &c, sizeof(char));
    lseek(fd, 0, SEEK_SET);
 
    map = (char*)mmap(NULL, map_size, PROT_WRITE, MAP_SHARED, fd, 0);
 
    if(map == MAP_FAILED) {
        printf("Error : mmap failed\n");
        return -1;
    }
 
    strcat(map, "This is test file for using mmap.\n");
    strcat(map, "mmap is useful for read/write file.\n");
 
    /* メモリとファイルを同期させる */
    msync(map, map_size, 0);
 
    close(fd);
    munmap(map, map_size);
 
    return 0;
}
</pre>

注意点としては、ファイル作成時に下処理が必要になることと、ファイルの実体に書き込むためにmsyncを呼ぶ必要があるということです。<br/>
逆に、msyncを呼ぶまではファイルに書き込まれないため、最後に1発だけ呼ぶようにすればディスクへのI/Oを減らせます。<br/>

### 実行結果

<pre>
$ gcc write_test.c -o write_test
$ ./write_test
$ cat writeFile
This is test file for using mmap.
mmap is useful for read/write file.
</pre>

### まとめ

mmapを初めて使ってみましたが、一度マッピングしてしまえばあとは普通のメモリと同じように扱えるので便利ですね。<br/>
特にファイルのwriteに関しては処理のオーバーヘッドを減らしたりするのに役立ちそうです。<br/>

書き込み時の前処理はftruncate関数で置き換えることもできるようです。こちらの方が関数1つで前処理が完結するので便利かも…。<br/>
