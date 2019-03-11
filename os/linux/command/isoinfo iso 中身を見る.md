引用 
 [ループバックマウントなしで iso イメージファイルの中身をみるには](http://d.hatena.ne.jp/kyagi/20080601/1212313444 "ループバックマウントなしで iso イメージファイルの中身をみるには")
<br/>
<pre>
$ sudo mount -o loop xxx.iso /mnt/iso
$ cd /mnt/iso && ls -l 
</pre>
<pre>
$ isoinfo -l -i xxx.iso | less
</pre>
