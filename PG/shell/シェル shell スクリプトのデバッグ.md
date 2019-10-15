## デバッグする

シェルスクリプトをデバッグするオプションは sh も bash も csh も tcsh もすべて同じ -x です。<br/>
スクリプトの先頭の [シェバン](https://ja.wikipedia.org/wiki/%E3%82%B7%E3%83%90%E3%83%B3_(Unix))<br/>

<pre>
#!/bin/sh
</pre>

になにが書いてあるかによります。<br/>
sh と書いてあって、スクリプト名が script.sh とすれば<br/>

<pre>
$ sh -x script.sh
</pre>

でデバッグモードで起動できます。<br/>
特にシングルステップということはありませんが、通常表示されない実行文が表示されます。<br/>

