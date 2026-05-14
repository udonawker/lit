## 20260514 [14.43 検索と整列の関数](https://satowiki.github.io/merry/SEMI_C/SECTION14/s14_07/s14_07_4.html)
```
#include <stdio.h>
#include <stdlib.h>

#define DATA_NUM (3)
#define DATA_SIZE (64)
typedef struct {
    int addr;
    char* dataptr;
} MAP;

static char apc_data[DATA_NUM][DATA_SIZE] = {"a\0", "b\0", "c\0"};
static int search_comp(const void* addr, const void* map) {
    printf("search = %d target =%d\n", *((int*)addr), ((MAP*)map)->addr);
    return *((int*)addr) == ((MAP*)map)->addr ? 0 : -1;
}

static MAP maps[DATA_NUM] = {{1, apc_data[0]}, {2, apc_data[1]}, {3, apc_data[2]}};

int main(void){
    int target = 3;
    MAP* map_search = NULL;
    
    map_search = (MAP*)bsearch(&target, maps, DATA_NUM + 1, sizeof(MAP), search_comp);
    if (map_search != NULL) {
        printf("found %s\n", map_search->dataptr);
    } else {
        printf("not found\n");
    }
    
    return 0;
}
```

## 20260514 [【C言語】bsearch関数の使い方](https://daeudaeu.com/c-bsearch/)
```
/* 比較関数 */
int compare(const void *p_data1, const void *p_data2) {
    int ret;
    const int *p_int1 = p_data1;
    const int *p_int2 = p_data2;

    printf("%d と %d の比較\n", *p_int1, *p_int2);

    if (*p_int1 < *p_int2) {
        ret = -1;
    } else if (*p_int1 > *p_int2) {
        ret = 1;
    } else {
        ret = 0;
    }

    return ret;

}


int main(void) {

    int i;

    int array[10] = {
        8, 1, 9, 6, 7, 3, 5, 0, 2, 4
    };
    
    int key;
    int *result;

    /* bsearch実行前にソート */
    printf("[ソート開始]\n");
    qsort(&array[0], 10, sizeof(array[0]), compare);
    
    /* 探索するデータを7に設定 */
    key = 7;
    printf("[探索開始]\n");
    result = bsearch(&key, &array[0], 10, sizeof(array[0]), compare);

    /* 探索結果を表示 */
    if (result != NULL) {
        printf("%dは配列の中に存在します\n", key);
        printf("%dはアドレス%pに存在します\n", key, result);
        printf("%dはソート後の配列の第%ld要素に存在します\n", key, result - &array[0]);
    } else {
        printf("%dは配列の中に存在しません\n", key);
    }

    return 0;
}
```
