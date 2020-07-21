cppreference.com<br>
## [vprintf, vfprintf, vsprintf, vsnprintf, vprintf_s, vfprintf_s, vsprintf_s, vsnprintf_s](https://ja.cppreference.com/w/c/io/vfprintf)
<br>

MSDN<br>
## [vsprintf, _vsprintf_l, vswprintf, _vswprintf_l, __vswprintf_l](https://docs.microsoft.com/ja-jp/cpp/c-runtime-library/reference/vsprintf-vsprintf-l-vswprintf-vswprintf-l-vswprintf-l?view=vs-2019)
<br>

## [IBM vsprintf() — 引数データのバッファーへの出力](https://www.ibm.com/support/knowledgecenter/ja/ssw_ibm_i_73/rtref/vsprtf.htm)
<pre>
#include &lt;stdarg.h&gt;
#include &lt;stdio.h&gt;
 
void vout(char *string, char *fmt, ...);
char fmt1 [] = "%s  %s  %s\n";
 
int main(void)
{
   char string[100];
 
   vout(string, fmt1, "Sat", "Sun", "Mon");
   printf("The string is:  %s¥n", string);
}
 
void vout(char *string, char *fmt, ...)
{
   va_list arg_ptr;
 
   va_start(arg_ptr, fmt);
   vsprintf(string, fmt, arg_ptr);
   va_end(arg_ptr);
}
 
/******************  Output should be similar to: ****************
 
The string is:  Sat  Sun  Mon
*/
</pre>
