こちらの紹介記事のとおりにdockerサーバを構築できました。<br/>
http://kuttsun.blogspot.jp/2017/09/docker-plantuml.html<br/>

Visual Studio Code上では、拡張機能の説明ページに従って、以下の設定が必要でした。<br/>

<pre>
"plantuml.server": "http://localhost:13080/",
"plantuml.render": "PlantUMLServer",
</pre>
??
<pre>
"plantuml.server": "http://localhost:13080/plantuml",
"plantuml.render": "PlantUMLServer",
</pre>

[WindowsでDocker環境を試してみる](https://qiita.com/fkooo/items/d2fddef9091b906675ca)<br/>
[Dockerの基本機能と全体像のイメージを整理してみる](https://qiita.com/fkooo/items/d2fddef9091b906675ca)<br/>
