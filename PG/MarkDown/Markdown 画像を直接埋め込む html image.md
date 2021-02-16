## [HTMLファイルの中に画像を埋め込んで表示させる方法](https://allabout.co.jp/gm/gc/23977/)

1. [画像をbase64エンコードするツール](https://x.allabout.co.jp/rd/ur_301.php?v=r&p=m&aapage=https%3A%2F%2Fallabout.co.jp%2Fgm%2Fgc%2F23977%2F2%2F&gs=1053&type=cc&id=23977&e_url=https%3A%2F%2Flab.syncer.jp%2FTool%2FBase64-encode%2F)で画像をBase64化
2. HTMLソース内に画像を埋め込む書式：img要素のsrc属性値に記述
<br><br>

■画像ファイルを読み込む場合の記述：<br>
src属性の値には、画像ファイルのURLを記述します。<br>
```
<img src="image.png" width="200" height="100" alt="イヌとネズミ">
```
■HTML内に画像を埋め込む場合の記述：<br>
src属性の値に、エンコードした画像を指定の書式で記述します。<br>
```
<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAA～以下略～" width="200" height="100" alt="イヌとネズミ">
```
<br>

画像を直接埋め込んだ場合のimg要素は、以下のように記述します。<br>
```
<img src="data:形式名;base64,変換したデータ" width="横" height="縦" alt="代替文字">
```
src属性の部分だけを抜き出すと以下のようになります。<br>
```
src="data:形式名;base64,変換したデータ"
```
このうち、「data:」の部分と「;base64,」の部分は常に同じなのでそのまま記述します。ここで使われている記号3つは、登場順にそれぞれコロン「:」→セミコロン「;」→カンマ「,」なので間違わないように注意して下さい。<br>
<br>
■形式名：<br>
ここには、MIME(マイム)タイプを記述します。例えば代表的な画像形式だと以下の通りです。<br>
GIF画像なら「 image/gif 」と記述。<br>
PNG画像なら「 image/png 」と記述。<br>
JPEG画像なら「 image/jpeg 」と記述。<br>
画像データなら「image」で始まります。スラッシュ「/」記号以後の部分はファイル拡張子と同じ場合が多いですが、JPEG画像の場合は(たとえ拡張子が「jpg」のように3文字だったとしても)「jpeg」のように4文字で記述しますからご注意下さい。なお、MIMEタイプの代表例は「MIMEタイプの包括的な一覧」(MDN)などで探せます。<br>
<br>
■変換したデータ：<br>
ここには、Base64でエンコードした文字列をそのまま全部記述します。すべてを1行で記述しても構いませんし、途中に改行が含まれていても構いません。改行は、Base64でのエンコード部分の途中に挿入されていても問題ありません。下記の記述例では、エンコード部分を160文字ごとに改行しています。<br>

