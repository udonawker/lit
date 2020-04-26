[Ubuntu16.04にffmpegをインストールしたメモ](https://www.komee.org/entry/2018/02/01/163958)<br>

__インストール__ <br>
<pre>
$ sudo add-apt-repository ppa:jonathonf/ffmpeg-3
$ sudo apt update
$ sudo apt install ffmpeg libav-tools x264 x265
</pre>
__バージョン確認__ <br>
<pre>
$ ffmpeg -version
</pre>
