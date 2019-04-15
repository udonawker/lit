引用 
[grepの-oオプションと-Pオプションの組み合わせが便利](http://greymd.hatenablog.com/entry/2014/09/27/154305 "grepの-oオプションと-Pオプションの組み合わせが便利")

<pre>
$ paste <(cat score | grep -oP '[^\d]+') <(cat score | grep -oP '\d+') | xargs -n 2
</pre>
上記のようにgrepコマンドを叩いていたら「-oPってオプションなに？」と言われたので。<br/>
<br/>

# grep -oPって？

**-oオプションとは**

