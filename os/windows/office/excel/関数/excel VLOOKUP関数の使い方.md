[VLOOKUP関数の使い方](http://www.excel-list.com/vlookup.html)<br>


|項目　　　　|詳細 |
|:--- |:--- |
|書式|VLOOKUP(検索値, 範囲, 列番号, 検索の型)|
|検索値<br>(必須)|検索する値またはセル参照を指定します。|
|範囲<br>（必須）|2 列以上のセル範囲を指定します。ここで指定した範囲の左端の列で検索値を検索します。|
|列番号<br>（必須）|目的データが入力されている列番号を指定します。<br>**重要** 範囲の左端の列が 1 になり、次の列が 2 になります。|
|検索の型<br>（省略可）|検索値の検索方法を TRUE（近似値）か FALSE（完全一致）で指定します。省略するとTRUEとして処理されます。<br>**TRUE の場合** 範囲の左端の列にあるデータを、昇順に並べ替えておく必要があります。昇順になってない場合、正しい結果が求められません。検索値が見つからない場合は、検索値未満の最大値が使用されます。<br>**FALSE の場合** データの並べ替えは必要なく、検索値が文字列の場合にワイルドカードが使用できます。検索値を完全に一致するデータが無い場合エラー値「#N/A」が返されます。|

## VLOOKUP関数に関連する関数

|内容 |関数|
|:-- | :--|
|[文字の検索、置換、比較、変換](http://www.excel-list.com/conversion.html)|目的別一覧|
|[検査範囲を検索して対応する値を求める](http://www.excel-list.com/lookup.html)|LOOKUP|
|[先頭行で検索して対応する値を求める](http://www.excel-list.com/hlookup.html)|HLOOKUP|
|[指定した位置にあるセルの参照または値を求める](http://www.excel-list.com/index_fun.html)|INDEX|
|[相対的な位置を数値で求める](http://www.excel-list.com/match.html)|MATCH|
|[リストの中から値を選択する](http://www.excel-list.com/choose.html)|CHOOSE|
|[条件を満たすレコードの1 つの値を抽出する](http://www.excel-list.com/dget.html)|DGET|
