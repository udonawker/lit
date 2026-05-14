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
