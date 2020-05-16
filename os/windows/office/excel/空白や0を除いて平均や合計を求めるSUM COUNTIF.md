[空白や０（ゼロ）は除いて平均を求める方法～SUM関数とCOUNTIF関数～](https://www.newcom07.jp/EXCEL-database/blog/excel_coffee_break/2011/02/post-102.html)<br>
[Excelで条件付きの合計値を求める方法と空欄以外の合計値を出す方法](https://incloop.com/excel-%E6%9D%A1%E4%BB%B6-%E5%90%88%E8%A8%88-%E7%A9%BA%E6%AC%84%E4%BB%A5%E5%A4%96%E3%81%AE%E3%82%BB%E3%83%AB%E3%81%AE%E5%90%88%E8%A8%88/)<br>

### 平均
<pre>
=SUM(B2:B13) / COUNTIF(B2:B13,　"<>0")
</pre>

### 合計
<pre>
=SUMIF(範囲,"検索条件",合計範囲)
=SUMIF(E4:E8,"食費",F4:F8) // 範囲内で"食費"の場合
=SUMIF(E4:E8,"<>",F4:F8)   // 空白以外
</pre>
