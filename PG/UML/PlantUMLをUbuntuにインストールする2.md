[Ubuntu上にPlantUMLをインストール](http://www.aise.ics.saitama-u.ac.jp/~gotoh/InstallPlantUMLonUbuntu.html)<br/>

<pre>
$ sudo apt-get update
$ sudo apt-get install default-jre
$ sudo apt-get install default-jdk
$ sudo apt-get install doxygen
$ sudo apt-get install doxygen-gui
$ sudo apt-get install graphviz
$ sudo apt-get install plantuml
</pre>

### PlantUMLの利用法
PlantUMLの記法でかかれたファイルが example.puml とするならば、以下のコマンドで図の生成ができる<br/>
<pre>
% plantuml example.puml
</pre>
