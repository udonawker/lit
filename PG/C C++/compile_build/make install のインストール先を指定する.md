## [make install のインストール先を指定する](http://shocrunch.hatenablog.com/entry/2014/12/04/204242)

<pre>
$ make DESTDIR=/you/want/spacify/path install
</pre>

例えば<br>
<pre>
download
├── origvim
│   ├── farsi
│   ├── libs
│   ├── nsis
│   ├── pixmaps
│   ├── runtime
│   └── src
└── vimoutput
</pre>

こんなディレクトリ構成で<br>

<pre>
[host@~/download/origvim] $ make; make install DESTDIR=~/download/vimoutput install
</pre>

なんてすると、<br>

<pre>
download/vimoutput
└── usr
    └── local
        ├── bin
        └── share
</pre>

という感じに配置してくれます。<br>
