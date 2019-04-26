<pre>
[root ~]# ls -l aaa.txt
-rw-r--r-- 1 root root 0  4月 26 15:33 aaa.txt
[root ~]# date -d $(date -Iseconds -r aaa.txt) "+%Y%m%d_%H%M%S"
20190426_153352
</pre>

<pre>
オプション	説明
-d 【日時】	指定した日時を表示する
--date=【日時】	指定した日時を表示する
-f 【ファイル】	【ファイル】から読み込んだ日時を表示する
--file=【ファイル】	【ファイル】から読み込んだ日時を表示する
-I【TIMESPEC】	【TIMESPEC】で指定した項目をISO 8601書式で表示する。【TIMESPEC】に指定できるのは以下の通り
・hours
・minutes
・date
・seconds
・ns
--iso-8601=【TIMESPEC】	【TIMESPEC】で指定した項目をISO 8601書式で表示する。【TIMESPEC】に指定できるのは以下の通り
・hours
・minutes
・date
・seconds
・ns
-r 【ファイル】	【ファイル】の最終更新日時を表示する
--reference=【ファイル】	【ファイル】の最終更新日時を表示する
-R	RFC 2822書式で表示する
--rfc-2822	RFC 2822書式で表示する
--rfc-3339=【TIMESPEC】	【TIMESPEC】で指定した項目をISO 3339書式で表示する。【TIMESPEC】に指定できるのは以下の通り
・date
・seconds
・ns
-s 【日時】	【日時】をコンピュータの日時として設定する
--set=【日時】	【日時】をコンピュータの日時として設定する
-u	UTCで表示する
--utc	UTCで表示する
--universal	UTCで表示する
--help	ヘルプを表示する
--version	バージョン情報を表示する
</pre>
