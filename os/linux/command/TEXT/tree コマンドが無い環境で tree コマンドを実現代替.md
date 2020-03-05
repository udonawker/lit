[tree コマンドが無い環境で tree コマンドを実現](https://qiita.com/yone098@github/items/bba8a42de6b06e40983b)<br/>

## find と sed で代替

<pre>
pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'
</pre>

<pre>
find . -print | sort | sed 's;[^/]*/;|---;g;s;---|; |;g'
</pre>

ディレクトリのみ
<pre>
ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
</pre>
