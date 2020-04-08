### sed
<pre>
#out.datの2行目取得
#sed -n 行番号P 対象ファイル
sed -n 2P out.dat
</pre>

### awk
<pre>
#out.datの2行目取得
#awk 'NR==行番号' 対象ファイル
awk 'NR==2' out.dat
</pre>

### bash
<pre>
#out.datの2行目取得
#head -n 行番号 対象ファイル | tail -n 1
head -n 2 out.data | tail -n 1
</pre>
