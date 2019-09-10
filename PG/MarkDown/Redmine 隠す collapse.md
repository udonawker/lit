[Redmine 2.2新機能紹介: チケットやWikiでテキスト折り畳み](http://blog.redmine.jp/articles/2_2/collapsed-text/ "http://blog.redmine.jp/articles/2_2/collapsed-text/")<br/>
<br/>

## Redmine 2.2新機能紹介: チケットやWikiでテキスト折り畳み

Redmine 2.2よりWikiマクロ {{collapse}} が追加され、チケットやWiki内でテキストを折り畳んで表示できるようになりました。<br/>
{{collapse}} マクロ内に記述された内容は普段は折り畳まれた状態になっており、「表示」リンクをクリックすると表示されます。<br/>
<br/>
エラーメッセージ、ログ、ソースコードなど分量の多い情報をチケット等に貼り付けるときなどに便利です。<br/>

## 折り畳み表示させる方法

折り畳み表示させたい情報を {{collapse と }} で囲んでください。<br/>

{{collapse<br/>
aaa<br/>
bbb<br/>
ccc<br/>
}}<br/>

## リンク文字列の変更

折り畳んだ状態のものを表示したり隠したりするリンクは「表示」と「隠す」ですが、 collapse に引数を指定することで別の表示にすることもできます。<br/>
例えば、以下のようにすると「エラーメッセージを表示」「隠す」に変えることができます。<br/>

{{collapse(エラーメッセージを表示, 隠す)<br/>
  .<br/>
  .<br/>
  .<br/>
}}<br/>
