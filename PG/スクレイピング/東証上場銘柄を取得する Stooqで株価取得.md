1. 東証上場銘柄の一覧は、JPX(日本取引所グループ)のページから取得します。
2. [その他統計資料 | 日本取引所グループ](https://www.jpx.co.jp/markets/statistics-equities/misc/01.html)
3. CSVに変換して読み込み
```
import pandas as pd

tse_list = pd.read_csv('data_j.csv', header=0)
```

### [pandas-datareaderでTOPIX500銘柄の株価上昇率を算出](https://predora005.hatenablog.com/entry/2021/03/08/190000)

### 業種ごとに株価を取得
抽出した、業種コード・業種区分ごとに株価を取得します。<br>
期間は3ヶ月分よりも長く取得したいのですが、Stooqの株価取得には制限があります。<br>
具体的な基準は分かりませんが、一定回数か容量を超えると空のDataFrameが返ってくるので、3ヶ月分に留めています。<br>
```
# 2020/11/2〜2021/2/5の株価を取得する
base_date = datetime.datetime(2020, 1, 6)
end_date=datetime.datetime(2021, 2, 5)

# 業種単位の株価上昇率格納用のDataFrameを用意する
category_df = None

# 業種ごとに変動率を計算する
for category in industry_category:
    
    category_code = category[0]     # 33業種コード
    category_class = category[1]    # 33業種区分
    
    # 指定した業種の銘柄を抽出
    brands = topix500[topix500['33業種区分'] == category_class]
    
    # 銘柄コードの末尾に.JPを付加する
    symbols = []
    for code in brands['コード']:
        symbols.append('{0:d}.JP'.format(code))

    # 指定銘柄コードの株価を取得する
    stock_price = web.DataReader(symbols, 'stooq', start=base_date, end=end_date)
    print(stock_price)
    # Attributes   Close                 ...  Volume                  ...   
    # Symbols    1414.JP 1721.JP 1801.JP ... 1883.JP  1893.JP 1911.JP ...   
    # Date                               ...                          ...   
    # 2021-02-05  4600.0  3315.0  3545.0 ...  262000   877200  476600 ...   
    # 2021-02-04  4630.0  3245.0  3510.0 ...  304100   864200  547700 ...   
    # ...            ...     ...     ... ...     ...      ...     ... ...   
    # 2020-11-04  5200.0  2789.0  3325.0 ...   85900  1494600  520500 ...   
    # 2020-11-02  5130.0  2678.0  3280.0 ...  140500   647000  409200 ...   
```

### 各銘柄の株価上昇率を計算
 2021-03-08
pandas-datareaderでTOPIX500銘柄の株価上昇率を算出
プログラミング Python pandas_datareader Matplotlib 株式投資
f:id:predora005:20210201003956j:plain
<pandas-datareaderでTOPIX500銘柄の株価上昇率を算出>*1

前回はpandas-datareaderで米国株の株価を取得しました。


predora005.hatenablog.com

今回は、東証一部上場銘柄の株価を取得し、業種ごとの株価変動を可視化しました。

f:id:predora005:20210211200716p:plain

[1] 東証上場銘柄を取得する
[1-1] JPX(日本取引所グループ)から取得
[1-2] CSVに変換して読み込み
[2] TOPIX500銘柄の業種ごとの株価上昇率を算出
[2-1] TOPIX500銘柄のデータを抽出
[2-2] 業種ごとの銘柄数を確認
[2-3] 各銘柄の株価上昇率を計算
[2-3-1] 業種コード・業種区分を抽出
[2-3-2] 業種ごとに株価を取得
[2-3-3] 各銘柄の株価上昇率を計算
[2-4] 業種ごとの平均値, 標準偏差を算出
[2-5] 折れ線グラフで株価上昇率を可視化
[2-6] 棒グラフで株価上昇率を可視化
[3] TOPIX500銘柄の銘柄ごとの株価上昇率を算出
[3-1] 銘柄ごとの株価上昇率を算出
[3-2] 株価上昇率と上位10, 下位10銘柄を確認
[3-2-1] 上位10銘柄
[3-2-2] 下位10銘柄
終わりに
[1] 東証上場銘柄を取得する
[1-1] JPX(日本取引所グループ)から取得
東証上場銘柄の一覧は、JPX(日本取引所グループ)のページから取得します。

その他統計資料 | 日本取引所グループ

中身は次のようなデータになっています。

f:id:predora005:20210211133201p:plain

[1-2] CSVに変換して読み込み
ExcelをCSV形式に保存したのち、PythonからpandasのDataFrameとして読み込みます。

import pandas as pd

tse_list = pd.read_csv('data_j.csv', header=0)
[2] TOPIX500銘柄の業種ごとの株価上昇率を算出
東証上場銘柄のうち、TOPIX500銘柄にターゲットを絞ります。ちなみに、全銘柄だと4,086銘柄あります*2。

[2-1] TOPIX500銘柄のデータを抽出
'市場・商品区分'で東証一部上場銘柄を抽出します。次に、'規模区分'でTOPIX500銘柄を抽出します。

# TOPIX500の銘柄を抽出する
tse1 = tse_list[tse_list['市場・商品区分'] == '市場第一部（内国株）']
topix500 = tse1[(tse1['規模区分'] == 'TOPIX Core30') | 
                (tse1['規模区分'] == 'TOPIX Large70') |
                (tse1['規模区分'] == 'TOPIX Mid400')]
いったん東証一部上場銘柄を抽出していますが、省略してTOPIX500銘柄を抽出することも可能です。

なお、TOPIXについては、下記ページに詳しく載っています。

TOPIX（東証株価指数） | 日本取引所グループ

[2-2] 業種ごとの銘柄数を確認
業種ごとの銘柄数を確認すると、電気機器の49銘柄が最多です。

# 33業種コード,33業種区分ごとの銘柄数を算出
category_count = topix500.groupby(['33業種コード','33業種区分']).size()
print(category_count)
# 33業種コード  33業種区分    
# 1050        鉱業              1
# 2050        建設業            20
# 3050        食料品            28
# 3100        繊維製品           5
# 3150        パルプ・紙          3
# 3200        化学              46
# 3250        医薬品            22
# 3300        石油・石炭製品       3
# 3350        ゴム製品           4
# 3400        ガラス・土石製品      8
# 3450        鉄鋼              7
# 3500        非鉄金属           7
# 3550        金属製品           6
# 3600        機械              32
# 3650        電気機器           49
# 3700        輸送用機器         20
# 3750        精密機器           10
# 3800        その他製品          10
# 4050        電気・ガス業         13
# 50          水産・農林業         2
# 5050        陸運業             24
# 5100        海運業             2
# 5150        空運業             2
# 5200        倉庫・運輸関連業      2
# 5250        情報・通信業         32
# 6050        卸売業             23
# 6100        小売業             33
# 7050        銀行業             26
# 7100        証券、商品先物取引業  5
# 7150        保険業             6
# 7200        その他金融業        9
# 8050        不動産業           12
# 9050        サービス業          25
# dtype: int64
[2-3] 各銘柄の株価上昇率を計算
ここでは、2020/11/2〜2021/2/5の株価上昇率を計算します。

[2-3-1] 業種コード・業種区分を抽出
まずは、業種コード・業種区分を抽出します。

# 33業種コード,33業種区分を抽出
industry_category = topix500.groupby(['33業種コード','33業種区分']).groups.keys()
print(industry_category)
# dict_keys([('1050', '鉱業'), ('2050', '建設業'), ('3050', '食料品'), 
# ('3100', '繊維製品'), ('3150', 'パルプ・紙'), ('3200', '化学'), 
# ('3250', '医薬品'), ('3300', '石油・石炭製品'), ('3350', 'ゴム製品'), 
# ('3400', 'ガラス・土石製品'), ('3450', '鉄鋼'), ('3500', '非鉄金属'), 
# ('3550', '金属製品'), ('3600', '機械'), ('3650', '電気機器'), 
# ('3700', '輸送用機器'), ('3750', '精密機器'), ('3800', 'その他製品'), 
# ('4050', '電気・ガス業'), ('50', '水産・農林業'), ('5050', '陸運業'), 
# ('5100', '海運業'), ('5150', '空運業'), ('5200', '倉庫・運輸関連業'), 
# ('5250', '情報・通信業'), ('6050', '卸売業'), ('6100', '小売業'), 
# ('7050', '銀行業'), ('7100', '証券、商品先物取引業'), ('7150', '保険業'), 
# ('7200', 'その他金融業'), ('8050', '不動産業'), ('9050', 'サービス業')])
[2-3-2] 業種ごとに株価を取得
抽出した、業種コード・業種区分ごとに株価を取得します。期間は3ヶ月分よりも長く取得したいのですが、Stooqの株価取得には制限があります。具体的な基準は分かりませんが、一定回数か容量を超えると空のDataFrameが返ってくるので、3ヶ月分に留めています。

# 2020/11/2〜2021/2/5の株価を取得する
base_date = datetime.datetime(2020, 1, 6)
end_date=datetime.datetime(2021, 2, 5)

# 業種単位の株価上昇率格納用のDataFrameを用意する
category_df = None

# 業種ごとに変動率を計算する
for category in industry_category:
    
    category_code = category[0]     # 33業種コード
    category_class = category[1]    # 33業種区分
    
    # 指定した業種の銘柄を抽出
    brands = topix500[topix500['33業種区分'] == category_class]
    
    # 銘柄コードの末尾に.JPを付加する
    symbols = []
    for code in brands['コード']:
        symbols.append('{0:d}.JP'.format(code))

    # 指定銘柄コードの株価を取得する
    stock_price = web.DataReader(symbols, 'stooq', start=base_date, end=end_date)
    print(stock_price)
    # Attributes   Close                 ...  Volume                  ...   
    # Symbols    1414.JP 1721.JP 1801.JP ... 1883.JP  1893.JP 1911.JP ...   
    # Date                               ...                          ...   
    # 2021-02-05  4600.0  3315.0  3545.0 ...  262000   877200  476600 ...   
    # 2021-02-04  4630.0  3245.0  3510.0 ...  304100   864200  547700 ...   
    # ...            ...     ...     ... ...     ...      ...     ... ...   
    # 2020-11-04  5200.0  2789.0  3325.0 ...   85900  1494600  520500 ...   
    # 2020-11-02  5130.0  2678.0  3280.0 ...  140500   647000  409200 ...   
TOPIX500銘柄すべての株価を一度に取得し、業種単位に分割することも可能と思われます。しかし、一度に大量のデータは扱いたくないので、業種単位で取得しています。

[2-3-3] 各銘柄の株価上昇率を計算
株価を取得した銘柄ごとに株価の上昇率を計算します。<br>
計算結果はディショクナリにいったん格納し、最後にDataFrameに変換します。<br>
```
    # 銘柄ごとに上昇率を計算し、ディショクナリに格納する
    dict = {}
    for symbol in symbols:
        
        # 基準日付からの上昇率を計算する
        base_date_str = base_date.strftime('%04Y-%02m-%02d')
        base_price = stock_price.loc[base_date_str][('Close',symbol)]
        increase_rate = stock_price[('Close',symbol)] / base_price.iloc[0]
        
        # ディクショナリに格納する
        dict[symbol] = increase_rate
        
    # ディクショナリからDataFrame作成
    df = pd.DataFrame(dict)
```

### 業種ごとの平均値, 標準偏差を算出
```
    # 業種内銘柄の上昇率の平均値を計算する
    mean = df.mean(axis='columns')
    std = df.std(axis='columns')
    
    # DataFrameに業種単位の上昇率と、上昇率の標準偏差を格納する
    if category_df is None:
        category_df = pd.concat([mean, std], axis=1)
        category_df.columns = pd.MultiIndex.from_tuples(
            [(category_class, '上昇率'), (category_class, '標準偏差')])
    else:
        category_df[(category_class, '上昇率')] = mean
        category_df[(category_class, '標準偏差')] = std
    
    print(category_df)
    #             鉱業              建設業          
    #             上昇率    標準偏差  上昇率     標準偏差
    # Date                                         
    # 2021-02-05  1.308617  NaN     1.170162  0.130083
    # 2021-02-04  1.274549  NaN     1.157672  0.130904
    # ...         ...       ...     ...       ...
    # 2020-11-04  1.054108  NaN     1.007299  0.013290
    # 2020-11-02  1.000000  NaN     1.000000  0.000000
    # 
    # [65 rows x 4 columns]
```

### 銘柄ごとの株価上昇率を算出
業種ごとの平均値, 標準偏差を算出したのと同様の方法で行います。<br>
pandas-datareaderによる株価取得は業種単位で行い、そののち銘柄ごとの株価上昇率を計算します。<br>
```
# 33業種コード,33業種区分を抽出
industry_category = topix500.groupby(['33業種コード','33業種区分']).groups.keys()

# 銘柄単位の株価上昇率格納用のディクショナリを用意する
brand_dict = {}
brand_count = 0

# 業種ごとに変動率を計算する
for category in industry_category:
    
    category_code = category[0]     # 33業種コード
    category_class = category[1]    # 33業種区分
    
    # 指定した業種の銘柄を抽出
    brands = topix500[topix500['33業種区分'] == category_class]
    
    # 銘柄コードの末尾に.JPを付加する
    symbols = []
    for code in brands['コード']:
        symbols.append('{0:d}.JP'.format(code))
        
    # 指定銘柄コードの株価を取得する
    stock_price = web.DataReader(symbols, 'stooq', start=base_date)
    
    # 銘柄ごとに上昇率を計算し、ディショクナリに格納する
    dict = {}
    for symbol in symbols:
        
        # 銘柄ごとに上昇率を計算し、ディショクナリに格納する
        # 基準日付からの上昇率を計算する
        base_date_str = base_date.strftime('%04Y-%02m-%02d')
        base_price = stock_price.loc[base_date_str][('Close',symbol)]
        increase_rate = stock_price[('Close',symbol)] / base_price.iloc[0]
        
        # ディクショナリに格納する
        dict[symbol] = increase_rate
        
    # ディクショナリからDataFrame作成
    df = pd.DataFrame(dict)
    
    # 最新日付を取得する
    latest_date = stock_price.index.max()
    latest_date_str = latest_date.strftime('%04Y-%02m-%02d')
    
    # 銘柄単位の株価上昇率をディクショナリに格納する
    for i, symbol in enumerate(symbols):
        
        code = brands['コード'].iloc[i]
        name = brands['銘柄名'].iloc[i]
        increase_rate = df.loc[latest_date_str, symbol].iloc[0]
        
        # '33業種コード','33業種区分', 'コード', '銘柄名', '上昇率'])
        brand_dict[brand_count] = [category_code, category_class, code, name, increase_rate]
        brand_count += 1
        
# 銘柄単位の株価上昇率を格納したDataFrameを作成する
brand_df = pd.DataFrame.from_dict(
                brand_dict, orient="index", 
                columns=['33業種コード','33業種区分', 'コード', '銘柄名', '上昇率'])
```

## 株価上昇率と上位10, 下位10銘柄を確認
### 上位10銘柄
```
# 上昇率で降順ソート
df_sorted = brand_df.sort_values('上昇率', ascending=False)

# 上位銘柄を抽出
df_top = df_sorted.head(10)
```

### 下位10銘柄
```
# 上昇率で昇順ソート
df_sorted = brand_df.sort_values('上昇率', ascending=True)

# 下位銘柄を抽出
df_bottom = df_sorted.head(10)
```
