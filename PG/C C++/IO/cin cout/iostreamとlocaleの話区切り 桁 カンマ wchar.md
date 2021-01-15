## [iostreamとlocaleの話](https://takmaru.wordpress.com/2010/12/03/iostream%E3%81%A8locale%E3%81%AE%E8%A9%B1/)

標準出力へ簡単に文字を出力するには、<br>
<pre>
cout << “Hello World!!” << endl;
</pre>
とすればいい。<br>

似たようなものに`wcout`というものもある。<br>
これは`cout`の`wchar_t`（ワイド文字列）版である。<br>
（・・・と私は思っている^^;）<br>
なので、<br>
<pre>
wcout << L”Hello World!!” << endl;
</pre>
というように、ワイド文字列を扱うことができる。<br>
しかし、<br>
<pre>
wcout << L”こんにちは！！” << endl;
</pre>
とすると正しく表示されない。<br>
<pre>
wcout << “こんにちは！！” << endl;
</pre>
だが、これは（マルチバイト文字列）問題なく表示される。<br>
<br>
**･･･何故か？**<br>
<br>
どうもワイド文字列を正しく扱うには、localeの設定が必要なようである。<br>
<pre>
wcout.imbue(locale(“”, locale::ctype));
wcout << L”こんにちは！！” << endl;
</pre>
とすれば、正しく表示される。<br>
だが逆に、マルチバイト文字列は正しく表示されなくなるので注意。<br>
また、`locale::ctype`というのがないと、数字がカンマ区切り付きで表示されるので注意。<br>
<pre>
wcout.imbue(locale(“”));
wcout << 1000 << endl;
</pre>
この場合、「1,000」と表示されてしまう。<br>

以下のようにして、全ての`iostream`オブジェクトに`locale`の設定を適用することもできる。<br>
<pre>
locale::global(locale(“”, locale::ctype));
</pre>
