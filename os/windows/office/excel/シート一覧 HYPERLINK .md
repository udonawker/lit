# シート名一覧作成
1. 数式 → 名前の定義 → 名前の定義 から名前欄に任意の名前（仮に「シート一覧」）を付ける。

2. 参照範囲欄に

<pre>
=MID(GET.WORKBOOK(1),FIND("]",GET.WORKBOOK(1))+1,xx)&T(NOW())
</pre>

※xxはシート数<br/>

3. シート名を表示したいセルに

<pre>
IF(COLUMNS(シート一覧) < ROW(A1),"",INDEX(シート一覧,ROW(A1)))
</pre>

<br/>

# シートにハイパーリンク
<pre>
=HYPERLINK("LINK先","別名")
</pre>
3.でシート名を表示したセルを指定して(Bだった場合)
<pre>
=HYPERLINK("#"&B2&"!A1",B2)
</pre>
!A1は参照先セル
