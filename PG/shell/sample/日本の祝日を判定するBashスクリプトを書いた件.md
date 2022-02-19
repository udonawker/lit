## [日本の祝日を判定するBashスクリプトを書いた件](https://qiita.com/mindwood/items/d22689d3da61034751bd)

### 祝日検索サイト
https://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv<br>
https://raw.githubusercontent.com/holiday-jp/holiday_jp-ruby/master/holidays.yml<br>

```
# curl -sL https://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv | iconv -f cp932
# curl -sS https://raw.githubusercontent.com/holiday-jp/holiday_jp-ruby/master/holidays.yml | awk '{print $1}'
```

#### check_holiday.sh
```
#!/bin/bash
###############################################################
#   本邦休日判定スクリプト
#   @author  MindWood
#   @param   チェック日付を yyyymmdd で指定。省略すると今日を仮定
#   @return  0       ... 確実に祝日
#            1       ... おそらく平日
#            上記以外 ... エラー
#   @usage   check_holiday.sh || ”平日に必ず実行させるジョブ”
###############################################################

# 引数チェック
if   [ $# -eq 0 ]; then
    CHECK_DATE=$(date +%s)
elif [ $# -eq 1 ]; then
    CHECK_DATE=$(date +%s --date $1) || exit 254
else
    echo 'Invalid argument'
    exit 255
fi

CACHE_PATH=/tmp                          # 内閣府提供の祝日ファイルをキャッシュするディレクトリ
HOLIDAY_FILE=$CACHE_PATH/holiday.csv     # 祝日登録ファイル名
LIMIT=$(date +%s --date '3 months ago')  # ３ヶ月以上前は古い祝日登録ファイルとする

# 祝日登録ファイルが無い、もしくは祝日登録ファイルの更新日が古くなった場合、再取得する
if [ ! -f $HOLIDAY_FILE ] || [ $LIMIT -gt $(date +%s -r $HOLIDAY_FILE) ]; then
    curl -sL https://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv | iconv -f cp932 > $HOLIDAY_FILE || exit 250
fi

# 祝日として登録されていれば 0 を返却して終了
grep ^$(date -d @$CHECK_DATE +%Y/%-m/%-d), $HOLIDAY_FILE > /dev/null 2>&1 && exit 0

# 土日なら 0 を返却して終了
DAYOFWEEK=$(date -d @$CHECK_DATE +%u)
[ $DAYOFWEEK -eq 6 ] || [ $DAYOFWEEK -eq 7 ] && exit 0

# 年末年始（12月31日～1月3日）なら 0 を返却して終了
MMDD=$(date -d @$CHECK_DATE +%m%d)
[ $MMDD -eq 1231 ] || [ $MMDD -le 0103 ] && exit 0

# 上記いずれでもなければ平日として終了
exit 1
```

#### 確認
```
for (( DATE=20191226; $DATE < 20200116; DATE=$(date -d "$DATE 1 day" +%Y%m%d) )); do
    ./check_holiday.sh $DATE || echo "$DATE は恐らく平日です"
done
20191226 は恐らく平日です
20191227 は恐らく平日です
20191230 は恐らく平日です
20200106 は恐らく平日です
20200107 は恐らく平日です
20200108 は恐らく平日です
20200109 は恐らく平日です
20200110 は恐らく平日です
20200114 は恐らく平日です
20200115 は恐らく平日です
```

## cron定義例
業務開始前に実行させるジョブが、次のように定義されていたとすると、<br>
```
00 7 * * * python3 /usr/local/bin/app.py
```

次のように追記するだけで、休日は実行しないようにできる。<Br>
```
00 7 * * * /usr/local/bin/check_holiday.sh || python3 /usr/local/bin/app.py
```
