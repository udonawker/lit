ディレクトリ配下全て
<pre>
$ find <target_dir> -type f -exec md5sum {} \;
$ find <target_dir> -type f | xargs md5sum
</pre>

該当ディレクトリ階層のみ
<pre>
$ find <target_dir> -type f -maxdepth 1 | xargs md5sum
</pre>
