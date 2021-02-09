## [CONCATENATEで日付を－TEXT関数](https://www.relief.jp/docs/excel-concatenate-date-string-using-text-function.html)

A1に 2021/2/9 (日付)<br>
A2に 16:45:12 (時刻)<br>
が入力されているとき<br>
A3に 2021/2/9 16:45:12 と表示させるには<br>
```
=CONCATENATE(TEXT(A1,"yyyy/m/d")&" "&CONCATENATE(TEXT(A2,"hh:mm:ss"))
```
