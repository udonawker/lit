参考:[エクセル シート名を取得する](https://www.tipsfound.com/excel/01306)<br/>

1. 各シートごとにシート名をA1に表示(1シート目は目次のため例外)
2. 1シート目に目次として各シート名を表示

例
1. シートを4つ作成
2. シート1-4のA1に以下の式 -> 各シートのA1にシート名を表示
<pre>
=RIGHT(CELL("filename",A1),LEN(CELL("filename",A1))-FIND("]",CELL("filename",A1)))
</pre>
3. シート1でシート名一覧取得
<pre>
1 任意のセルで 数式タブ→名前の定義
  - 名前:book
  - 参照範囲:=GET.WORKBOOK(1)
2 任意のセルで 数式タブ→名前の定義
  - 名前:doc
  - 参照範囲:=GET.DOCUMENT(88)
    # GET.DOCUMENT()はファイルの情報を返す関数
    # 88 は「アクティブブックの名前を文字列で返す」
    # http://excel4macro.blog86.fc2.com/blog-entry-170.html
</pre>
4. シート1で目次として各シート名表示
<pre>
各シート名を表示したいセルに以下の式
=SUBSTITUTE(INDEX(book,x),"["&doc&"]","")
  # xは表示したいシートインデックス
</pre>

