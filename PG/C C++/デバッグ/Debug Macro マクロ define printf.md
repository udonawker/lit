<pre>
#include &lt;stdio.h&gt;
#ifndef DEBUG
    #define DEBUG_LOG(...)
#else
    #define DEBUG_LOG(...)  do { printf("%s:%s(%d) : ", __FILE__, __func__, __LINE__); printf(__VA_ARGS__); printf("\n"); } while(0)
#endif
</pre>

## [printf デバッグ（デバッグプリント）の書き方](https://hangstuck.com/cpp-debug-printf/#toc8)

```
#ifndef MY_DEBUG_H_INCLUDED
#define MY_DEBUG_H_INCLUDED

#define DEBUG_BUILD  // enable debug print.

#ifdef DEBUG_BUILD
# define DEBUG_PUTS(str) puts(str)
# define DEBUG_PRINTF(fmt, ...)  printf(fmt, __VA_ARGS__);                   
#else
# define DEBUG_PUTS(str)
# define DEBUG_PRINTF(fmt, ...)
#endif

#endif
```

```
#define DEBUG_BUILD

#ifdef DEBUG_BUILD
# define DEBUG_PRINTF(fmt, ...) \
     printf("file : %s, line : %d, func : %s, " fmt, \
                      __FILE__, __func__, __LINE__, ## __VA_ARGS__);
#else
# define DEBUG_PRINTF(fmt, ...)
#endif
```
