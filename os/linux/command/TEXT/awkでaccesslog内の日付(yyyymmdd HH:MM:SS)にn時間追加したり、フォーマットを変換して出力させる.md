## [awk(gawk/mawk)でaccesslog内の日付(yyyy/mm/dd HH:MM:SS)にn時間追加したり、フォーマットを変換して出力させる](https://orebibou.com/ja/home/201912/20191202_001/)

### 1. awkで日付を変換する(外部コマンド使用)
```
cat sample.log | awk '{"date -d \"$(echo \""$4"\"|sed -e\"s,/,-,g\" -e\"s,\\[,,\" -e\"s,:, ,\") 9 Hours\" \"+%Y-%m-%d %H:%M:%S\""|getline x;$4="["x;$5="+0900]";print $0}'
```
```
[blacknon@BlacknonMacBook-Pro2018][~/Work/201912/20191201]
(｀・ω・´)  < tail sample.log
180.159.128.48 - - [01/Dec/2019:12:53:13 +0000] "GET /item/networking/4202 HTTP/1.1" 200 69 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"
120.78.161.104 - - [01/Dec/2019:12:53:13 +0000] "GET /category/toys HTTP/1.1" 200 61 "/category/computers" "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"
140.153.157.210 - - [01/Dec/2019:12:53:13 +0000] "GET /category/electronics HTTP/1.1" 200 136 "-" "Mozilla/5.0 (Windows NT 6.0; rv:10.0.1) Gecko/20100101 Firefox/10.0.1"
120.45.206.66 - - [01/Dec/2019:12:53:13 +0000] "GET /item/electronics/1771 HTTP/1.1" 200 81 "/search/?c=Electronics" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11"
112.225.194.42 - - [01/Dec/2019:12:53:13 +0000] "GET /category/networking HTTP/1.1" 200 105 "-" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; YTB730; GTB7.2; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET4.0C; .NET4.0E; Media Center PC 6.0)"
44.156.113.66 - - [01/Dec/2019:12:53:13 +0000] "GET /item/toys/2218 HTTP/1.1" 200 133 "/item/networking/3747" "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"
184.114.94.28 - - [01/Dec/2019:12:53:13 +0000] "GET /category/electronics HTTP/1.1" 200 128 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.77 Safari/535.7"
60.90.52.188 - - [01/Dec/2019:12:53:13 +0000] "GET /item/books/2219 HTTP/1.1" 200 81 "-" "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"
160.126.224.217 - - [01/Dec/2019:12:53:13 +0000] "GET /category/networking HTTP/1.1" 200 55 "/category/software" "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A405 Safari/7534.48.3"
116.126.93.220 - - [01/Dec/2019:12:53:13 +0000] "GET /category/games HTTP/1.1" 200 91 "-" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; YTB720; GTB7.2; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)"

[blacknon@BlacknonMacBook-Pro2018][~/Work/201912/20191201]
(｀・ω・´)  < tail sample.log | awk '{"gdate -d \"$(echo \""$4"\"|sed -e\"s,/,-,g\" -e\"s,\\[,,\" -e\"s,:, ,\") 9 Hours\" \"+%Y-%m-%d %H:%M:%S\""|getline x;$4="["x;$5="+0900]";print $0}'
180.159.128.48 - - [2019-12-01 21:53:13 +0900] "GET /item/networking/4202 HTTP/1.1" 200 69 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"
120.78.161.104 - - [2019-12-01 21:53:13 +0900] "GET /category/toys HTTP/1.1" 200 61 "/category/computers" "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"
140.153.157.210 - - [2019-12-01 21:53:13 +0900] "GET /category/electronics HTTP/1.1" 200 136 "-" "Mozilla/5.0 (Windows NT 6.0; rv:10.0.1) Gecko/20100101 Firefox/10.0.1"
120.45.206.66 - - [2019-12-01 21:53:13 +0900] "GET /item/electronics/1771 HTTP/1.1" 200 81 "/search/?c=Electronics" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11"
112.225.194.42 - - [2019-12-01 21:53:13 +0900] "GET /category/networking HTTP/1.1" 200 105 "-" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; YTB730; GTB7.2; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET4.0C; .NET4.0E; Media Center PC 6.0)"
44.156.113.66 - - [2019-12-01 21:53:13 +0900] "GET /item/toys/2218 HTTP/1.1" 200 133 "/item/networking/3747" "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"
184.114.94.28 - - [2019-12-01 21:53:13 +0900] "GET /category/electronics HTTP/1.1" 200 128 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.77 Safari/535.7"
60.90.52.188 - - [2019-12-01 21:53:13 +0900] "GET /item/books/2219 HTTP/1.1" 200 81 "-" "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"
160.126.224.217 - - [2019-12-01 21:53:13 +0900] "GET /category/networking HTTP/1.1" 200 55 "/category/software" "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A405 Safari/7534.48.3"
116.126.93.220 - - [2019-12-01 21:53:13 +0900] "GET /category/games HTTP/1.1" 200 91 "-" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; YTB720; GTB7.2; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)"
117.```

その他、`dateutils`の`strptime`コマンドや`dateadd`コマンドを利用する方法もある。 `strptime`コマンドや`dateaddk`コマンドでは、以下のように時刻のフォーマットや追加する時刻を指定して加工ができる。<br>
```
echo "12/Nov/2015:23:28:22"|strptime -i "%d/%b/%Y:%H:%M:%S" -f "%d.%m.%Y %H:%M:%S"
echo "12/Nov/2015:23:28:22"|dateadd -i "%d/%b/%Y:%H:%M:%S" -f "%d.%m.%Y %H:%M:%S" +9h
```

`dateutils`を使った場合のサンプルは以下。 こちらのほうが指定がわかりやすい気がする。<br>
```
tail sample.log | awk '{"echo \""$4"\"|dateadd -i \"[%d/%b/%Y:%H:%M:%S\" -f \"%Y/%m/%d %H:%M:%S\n\" +9h"|getline x;$4="["x;$5="+0900]";print $0}'
```
