<pre>
#include <stdio.h>
#ifndef DEBUG
    #define DEBUG_LOG(...)
#else
    #define DEBUG_LOG(...)  do { printf("%s:%s(%d) : ", __FILE__, __func__, __LINE__); printf(__VA_ARGS__); printf("\n"); } while(0)
#endif
</pre>
