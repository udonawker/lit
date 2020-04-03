commit3<br>
commit2<br>
commit1<br>

### 3と2をまとめて2とする

■<br>
<pre>
$ git log --oneline
AAAA commit 3
BBBB commit 2
CCCC commit 1
</pre>

■<br>
<pre>
$ git reset --soft HEAD^ // git reset --soft BBBB
</pre>

■<br>
<pre>
$ git add .
</pre>

■<br>
<pre>
$ git commit --amend
</pre>

■<br>
<pre>
$ git log --oneline
BBBB commit 2
CCCC commit 1
</pre>
