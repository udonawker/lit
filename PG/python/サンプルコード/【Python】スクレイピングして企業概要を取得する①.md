## 20240307 [【Python】スクレイピングして企業概要を取得する①](https://qiita.com/nogizakapython/items/0fa0a7b9034dc89a0657)
<br>

### ソースコード
```
# 企業概要取得ツール
# 新規開発   2024/3/2
# Create by 乃木坂好きのITエンジニア

#ライブラリのインポート
from bs4 import BeautifulSoup
import urllib3
import codecs
import datetime
import re
import os
import requests

#会社概要ページのURLの定義
get_url = "https://flora-inc.co.jp/page/company.php"
# 現在日時の取得
dt = datetime.datetime.now()
#現在日時を年4桁、月2桁、日付2桁、時間、分、秒のフォーマットで取得する
now_date = dt.strftime('%Y%m%d%H%M%S')
# 格納先ファイル名の定義
file_name = "flora" + now_date + ".txt"
#取得したHTMLから、必要なデータを抽出し、抽出ファイルに書き込む
result_file = "flora.txt"
# 検索文字列
pattern1 = '<td class="title">'
pattern2 = '<td class="content">'
pattern3 = '<p>'


# スクレイピング関数
def scraping():
    http = urllib3.PoolManager()
    # スクレイピング対象の URL にリクエストを送り HTML を取得する
    r = requests.get(get_url)
    soup = BeautifulSoup(r.text, 'html.parser')
    # tableタグ内の文字列を取得する
    title_text = soup.find('table')
    print(title_text,file=codecs.open(file_name,'a','utf-8'))    # セクションタグを取得する

# メイン関数
def main():
    scraping()
    file_data = open(file_name,"r",encoding="utf-8")

    file_exist = os.path.isfile(result_file)
    if file_exist:
        os.remove(result_file)
    # テーブルタグを取得したタグファイルから、不必要tableタグデータ行を読み込んだ時にファイル出力
    # ループから抜ける。
    for line in file_data:
        line = line.replace("　"," ")
        print(line)
        result1 = re.match(pattern1,line)
        result2 = re.match(pattern2,line)
        result3 = re.match(pattern3,line)
        # 必要なデータをファイルに出力する
        with open(result_file,mode="a",encoding="utf-8") as f:
            if result1 or result2 or result3:
                f.write(line)


    # 出力ファイルを閉じる
    file_data.close()

if __name__ == "__main__":
    main()
```

### 取得したタグファイルの中身
```
<td class="title">会社名</td>
<td class="content">株式会社フローラ</td>
<td class="content">株式会社フローラホールディングス</td>
<td class="title">本社所在地</td>
<td class="content">愛知県名古屋市中川区中花町37番地</td>
<td class="content">愛知県名古屋市中川区中花町37番地</td>
<td class="title">代表</td>
<td class="content">代表取締役 鈴木 智</td>
<td class="content">代表取締役 鈴木 智</td>
<td class="title">電話番号</td>
<td class="content"><a href="tel:052-655-6226">052-655-6226</a></td>
<td class="content"><a href="tel:052-655-6226">052-655-6226</a></td>
<td class="title">FAX</td>
<td class="content">052-655-6225</td>
<td class="content">052-655-6225</td>
<td class="title">URL</td>
<td class="content"><a href="https://flora-inc.co.jp">https://flora-inc.co.jp</a></td>
<td class="content"><a href="https://flora-inc.co.jp">https://flora-inc.co.jp</a></td>
<td class="title">メールアドレス</td>
<td class="content"><a href="mailto:info@flora-inc.co.jp">info@flora-inc.co.jp</a></td>
<td class="content"><a href="mailto:info@flora-inc.co.jp">info@flora-inc.co.jp</a></td>
<td class="title">事業所所在地</td>
<td class="content">
<p>・フローラ（A型事業所）</p>
<p> 愛知県名古屋市中川区中花町37番地</p>
<p>・らいふはうす（共同生活援助）</p>
<p> 愛知県名古屋市中川区中郷一丁目33番地</p>
<td class="content">
<p>・F-Gene（B型事業所）</p>
<p> 愛知県名古屋市中川区長良町5丁目104-2</p>
<td class="title">事業内容</td>
<td class="content">IT事業、ネット販売事業、軽作業<br/>
<td class="content">e-sports、CGイラスト、動画編集<br/>
```
