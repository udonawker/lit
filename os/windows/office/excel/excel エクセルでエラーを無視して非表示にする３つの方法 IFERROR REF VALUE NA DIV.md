[エクセルでエラーを無視して非表示にする３つの方法](https://www.excelspeedup.com/errormushi/)<br>

- 1 [エラーが出た後に処理する方法](https://www.excelspeedup.com/errormushi/#i)
    - 1.1 [エラーそのものを取り除いて正常な値に置き換える](https://www.excelspeedup.com/errormushi/#i-2)
        - 1.1.1 [Excel20007より前でiferror関数が使えないとき](https://www.excelspeedup.com/errormushi/#Excel20007iferror)
    - 1.2 [エラーが出ていることを条件付書式でごまかす](https://www.excelspeedup.com/errormushi/#i-3)
- 2 [エラーが出る前に処理する方法](https://www.excelspeedup.com/errormushi/#i-4)
    - 2.1 [計算式でエラーが出そうな場合に別処理をする](https://www.excelspeedup.com/errormushi/#i-5)
- 3 [非表示にする方法別のメリットとデメリット](https://www.excelspeedup.com/errormushi/#i-6)
    - 3.1 [計算式の複雑さ](https://www.excelspeedup.com/errormushi/#i-7)
    - 3.2 [処理内容のわかりやすさ](https://www.excelspeedup.com/errormushi/#i-8)
    - 3.3 [エラーを完全に消せるか？](https://www.excelspeedup.com/errormushi/#i-9)
    - 3.4 [細かい処理のしやすさ](https://www.excelspeedup.com/errormushi/#i-10)
    - 3.5 [後続計算が可能か？](https://www.excelspeedup.com/errormushi/#i-11)
- 4 [エラーを非表示にする方法まとめ](https://www.excelspeedup.com/errormushi/#i-12)
- 5 [おすすめ記事](https://www.excelspeedup.com/errormushi/#i-13)

## エラーそのものを取り除いて正常な値に置き換える

エラーが出た後に、関数を使ってエラーを取り除きます。<br>
いろいろな方法がありますが、Excel2007以降であれば「iferror関数」を使うのが一番簡単です。<br>
iferror関数は次のように、エラーが出る計算式の「外側」にくるむように入力します。<br>
<pre>
=iferror( 「エラーが出る計算式」 , 「エラーのときに表示する値」 )
</pre>

![alt](https://www.excelspeedup.com/wp-content/uploads/2016/04/errormushi_1_1.png)<br>
