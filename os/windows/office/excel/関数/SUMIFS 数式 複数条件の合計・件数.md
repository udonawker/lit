## [SUMIFS関数がなぜうまくいかない？#VALUE!エラーの原因と対処法](https://nyanto.jimdofree.com/%EF%BD%B4%EF%BD%B8%EF%BD%BE%EF%BE%99%E9%96%A2%E6%95%B0-%E8%AA%AC%E6%98%8E/sumifs%E9%96%A2%E6%95%B0%E3%81%A7%E8%A4%87%E6%95%B0%E6%9D%A1%E4%BB%B6%E3%81%AB%E5%90%88%E3%81%86%E3%82%BB%E3%83%AB%E3%82%92%E5%90%88%E8%A8%88%E3%81%99%E3%82%8B%E5%9F%BA%E6%9C%AC-%E5%BF%9C%E7%94%A8%E7%9A%84%E4%BD%BF%E3%81%84%E6%96%B9/%E3%82%A8%E3%82%AF%E3%82%BB%E3%83%AB%E3%81%AEsumifs%E9%96%A2%E6%95%B0%E3%81%8C-value-%E3%82%A8%E3%83%A9%E3%83%BC%E3%81%AB%E3%81%AA%E3%82%8B%EF%BC%92%E3%81%A4%E3%81%AE%E5%8E%9F%E5%9B%A0%E3%81%A8%E5%AF%BE%E5%87%A6%E6%B3%95/)

sumifsは他bookの値は参照できない<br>
### SUMIFS関数が#VALUE!エラーになる原因の一つ目は「引数で閉じた他のエクセルファイルを参照している」ことです。

条件が2つの場合、SUMIFS関数は、<br>
```
=SUMIFS(合計対象範囲,検索範囲1,条件1,検索範囲2,条件2)
```

SUM関数＋IF関数＋配列数式の場合は、<br>
```
{=SUM(IF((検索範囲1=条件1)*(検索範囲2=条件2),合計対象範囲,""))}
```
{}はCtrl + Shift + Enter でつける<br>
ポイント<br>
　① 条件をカッコで囲み、「*」でつなげる<br>
　② 配列数式にする<br>

例での数式で見比べてみると、SUMIFS関数の場合は、<br>
```
=SUMIFS([Book1.xlsx]Sheet1!$C$2:$C$7,[Book1.xlsx]Sheet1!$A$2:$A$7,"A",[Book1.xlsx]Sheet1!$B$2:$B$7,"〇")
```

対して、SUM関数＋IF関数＋配列数式の場合は、<br>
```
{=SUM(IF(([Book1.xlsx]Sheet1!$A$2:$A$7="A")*([Book1.xlsx]Sheet1!$B$2:$B$7="〇"),[Book1.xlsx]Sheet1!$C$2:$C$7,""))}
```

---

## [複数条件の合計・件数](https://excel-ubara.com/excel3/EXCEL004.html)

* SUMIFS関数 2007以降
* SUMPRODUCT関数 2003以前
* 配列数式（CSE）
