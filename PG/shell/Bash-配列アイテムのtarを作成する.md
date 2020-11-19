## [Bash-配列アイテムのtarを作成する](https://python5.com/q/dlxozblu)

圧縮されたtar( tar.gz )に追加したいファイルとディレクトリを含む配列があります。もともと私は配列をループして各アイテムをtarに追加することを計画していました。<br>
<pre>
tar czf my_app.tar.gz

for app_item in "${app_items[@]}"
do
    tar rzf my_app.tar.gz $app_item
done
</pre>

この問題は、圧縮されたアーカイブでのみ発生します。最初に非圧縮アーカイブを作成して使用し、後でループが実行されたときに圧縮することを提案します。<br>
<pre>
tar cf my_app.tar --files-from /dev/null
for app_item in "${app_items[@]}"
do
    tar rf my_app.tar "$app_item"
done
gzip my_app.tar
</pre>

スペースを含むファイル名でもうまく機能するように見える完全に異なるアプローチ(ただし、改行を含むファイル名では機能しないため、それほど一般的ではありません):<br>
<pre>
tar cfz my_app.tgz --files-from <(printf "%s\n" "${app_items[@]}")
</pre>

そして、これを行うさらに別の方法(ファイル名の改行やその他のものでも機能します):<br>
<pre>
eval tar cfz my_app.tgz $(printf "%q " "${app_items[@]}")
</pre>

ただし、evalの場合と同様に、何を渡すかを知っておく必要があります。信頼できないソースからのものはないことを知っておく必要があります。そうしないと、セキュリティの問題が発生する可能性があるため、一般的には避けることをお勧めします。<br>
