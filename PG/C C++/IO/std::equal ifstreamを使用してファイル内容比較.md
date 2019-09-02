引用<br/>
[ファイルの比較](https://www.wabiapp.com/WabiSampleSource/windows/file_compere.html "ファイルの比較")<br/>

<pre>
#include <stdio.h>
#include <tchar.h>
#include <iostream>
#include <fstream>
 
 
 
/*
    ファイルの比較
*/
void compere_file
(
      std::wstring oFile1
    , std::wstring oFile2
)
{
    std::ifstream ifstr1( oFile1.c_str(), std::ios::binary );
    std::ifstream ifstr2( oFile2.c_str(), std::ios::binary );
 
    // ファイルの比較
    if ( std::equal( std::istreambuf_iterator<char>( ifstr1 )
        , std::istreambuf_iterator<char>(), std::istreambuf_iterator<char>( ifstr2 ) ) ) {
        std::wcout << L"一致しました" << std::endl;
    }
    else {
        std::wcout << L"一致しませんでした" << std::endl;
    }
}
 
 
 
int _tmain
(
      int argc
    , _TCHAR* argv[]
)
{
    // 標準出力にユニコード出力する
    setlocale( LC_ALL, "Japanese" );
 
    // ファイルを比較する
    compere_file( L"file1.txt", L"file2.txt" );
 
    // 正常終了
    return( 0 );
}
</pre>
