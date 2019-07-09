引用[Excelで数字のみを抽出する関数、文字のみを抽出する関数](https://qiita.com/mhara/items/82421d1b34e88a3efba1 "Excelで数字のみを抽出する関数、文字のみを抽出する関数")

例えばA1(数字+文字)がある場合、A2(数字のみ),A3(文字のみ)のように自動で出力したい時。<br/>
<pre>
@Excel2010
A1 = "50mg" 
A2 = 50
A3 = "mg" 
</pre>

以下の関数で、数字だけ/文字だけを抽出できます。<br/>
<pre>
@Excel2010
A1 = 50mg ;元データ
A2 = LOOKUP(10^17,LEFT(A1,COLUMN($1:$1))*1) ;A1から数字のみ"50"を抽出
A3 = SUBSTITUTE(A1,A2,"") ;A1から文字のみ"mg"を抽出
</pre>
