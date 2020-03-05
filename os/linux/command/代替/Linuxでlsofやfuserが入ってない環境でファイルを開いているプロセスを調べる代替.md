[Linuxでlsofやfuserが入ってない環境でファイルを開いているプロセスを調べる](https://orebibou.com/2018/07/linux%E3%81%A7lsof%E3%82%84fuser%E3%81%8C%E5%85%A5%E3%81%A3%E3%81%A6%E3%81%AA%E3%81%84%E7%92%B0%E5%A2%83%E3%81%A7%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E9%96%8B%E3%81%84%E3%81%A6%E3%81%84/)<br/>

たまーに、指定したファイルを使用しているプロセスを調べたいということがある。<br/>
そういうとき、大体はlsofやfuserで対象のプロセスを調べるのだけど、そういったツールが入ってない+インストールができない、めんどくさいといった場合、どうやって調べればいいのだろう。<br/>
Linux(というか、UNIX系OS共通だと思う)の場合、/proc配下にあるプロセスIDのフォルダの中にある各種ファイルやフォルダに使用しているファイルへのシンボリックリンクが貼られている(fdだったらstdoutやstderrといったファイルディスクリプタに。例として、「cmd &gt; /path/to/xxx」と実行しているプロセスの場合なら、/proc/&lt;pid&gt;/fd/nは/path/to/xxxへのシンボリックリンクになっている)ので、fd,cwdフォルダ配下を調べてやればいい。<br/>

<pre>
ls -la /proc/*/{cwd,fd} | grep -C 10 'filepath' # lsの場合
find /proc/*/ -type l -printf '%p => %l\n' 2&gt;/dev/null | grep -E '/proc/&#91;0-9&#93;+' | grep filepath # findの場合(こっちのほうがおすすめ)
</pre>

<pre>
blacknon@BS-PUB-UBUNTU-01:~$ ps -ef | grep tail
blacknon 14783 11210  0 09:21 pts/2    00:00:00 tail -F ./test.txt
blacknon 14785  8689  0 09:21 pts/1    00:00:00 grep --color=auto tail
blacknon@BS-PUB-UBUNTU-01:~$ find /proc/*/ -type l -printf '%p => %l\n' 2>/dev/null | grep -E '/proc/&#91;0-9&#93;+' | grep test.txt # findの場合(こっちのほうがおすすめ)
/proc/14783/task/14783/fd/3 =&gt; /home/blacknon/test.txt
/proc/14783/fd/3 => /home/blacknon/test.txt
</pre>
