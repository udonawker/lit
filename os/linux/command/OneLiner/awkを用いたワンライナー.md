## 20241006 Qiita [awkワンライナー集](https://qiita.com/yusukew62/items/f9502a3ddd6087a496ce)
## 20241006 Qiita [AWK によるテキストのワンライナー処理クックブック集](https://qiita.com/key-amb/items/754a12eda28e7650a47c)
## 20241006 [AWKによるワンライナー7つ](https://doloopwhile.hatenablog.com/entry/2013/08/05/014709)
## 20241006 [Awkワンライナー (最小値、最大値、合計、平均、中央値)](https://leetmikeal.hatenablog.com/entry/20130117/1358423717)

#### 指定したフィールド"以外"を出力
```
#!bash
% echo {1..5} | awk '{$1=$3="";print}'
 2  4 5
```

#### 組み込み変数・特殊変数
`NF` ... フィールド数<br>
`NR` ... 行番号<br>
`$0` ... 行全体の文字列<br>

#### 末尾からn番目のフィールドを指定する
`$NF` で末尾のフィールド、 `$(NF-n)` で末尾から n 番目のフィールドを指定できます。<br>
```
% awk '{print $1,$(NF-1),$NF}' sample.csv # 1列目と最後の2列を出力
```

#### 書式指定
`printf 書式, 変数1, 変数2, ...` の構文が使えます。<br>

```
% awk '{printf "%10s %5d\n",$1,$3}' sample.dat
```

#### 各行の長さを出力
`length(string)` 関数で改行を含む文字列の長さを取得できるので、これを利用します。<br>

```
% awk '{print length($0)}' sample.txt
```

応用例としては、 sort と組み合わせて長い行から順に出力するということが、簡単にできます。<br>

```
# 1行が長い順に TOP 10 を行長とともに表示
% awk '{print length($0), $0}' sample.txt | sort -nr | head
# 1行が短い順に TOP 10 を行長とともに表示
% awk '{print length($0), $0}' sample.txt | sort -n | head
```

#### 平均値の算出
```
% awk '{sum += $4} END {print sum/NR}' sample.dat
```

#### 最大値の算出
```
% awk '{if (max<$4) max=$4} END {print max}' sample.dat
```

#### 連想配列を使ってキーごとに集計
% awk '
```
{sum_of[$3] += $4} END {for (key in sum_of) {printf "Key: %s, SUM: %d\n", key, sum_of[key]}}
' sample.dat
```
---

```
$ head proxy.csv 
"No.","Time","Source","Destination","Protocol","Length","Info"
"1","0.000000","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.203? Tell 192.168.1.66"
"2","1.000000","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.203? Tell 192.168.1.66"
"3","1.254539","240b:12:2000:6300:250:56ff:fe84:43ba","2404:6800:4004:80e::2002","TCP","86","40207  >  80 [FIN, ACK] Seq=1 Ack=1 Win=138 Len=0 TSval=300830160 TSecr=1572813386"
"4","1.257955","2404:6800:4004:80e::2002","240b:12:2000:6300:250:56ff:fe84:43ba","TCP","86","80  >  40207 [FIN, ACK] Seq=1 Ack=2 Win=271 Len=0 TSval=1572872727 TSecr=300830160"
"5","1.257977","240b:12:2000:6300:250:56ff:fe84:43ba","2404:6800:4004:80e::2002","TCP","86","40207  >  80 [ACK] Seq=2 Ack=2 Win=138 Len=0 TSval=300830164 TSecr=1572872727"
（省略）
"4990","21.653063","192.168.1.3","192.168.1.62","TCP","60","53875  >  3128 [ACK] Seq=2665 Ack=2690 Win=65024 Len=0"
"4991","21.682212","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.212? Tell 192.168.1.66"
"4992","22.351148","192.168.1.9","192.168.1.255","ALLJOYN-NS","161","VERSION 0 ISAT"
"4993","22.351873","192.168.1.9","192.168.1.255","ALLJOYN-NS","187","VERSION 1 ISAT"
"4994","22.682304","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.212? Tell 192.168.1.66"
```


## ワンライナー集
### 1. セミコロン（;）で複数行の処理
#### 例:2行目以内と、５行目以降１０行目以内を表示
解説：１つ目のNR<=2で２行目以内を表示後、２つ目のNR>=5&&NR<=10で５行目以降１０行目以内を表示している<br>

```
$ awk -F, 'NR <=2 {print $0}; NR >= 5 && NR <= 10 {print $0}' proxy.csv
"No.","Time","Source","Destination","Protocol","Length","Info"
"1","0.000000","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.203? Tell 192.168.1.66"
"4","1.257955","2404:6800:4004:80e::2002","240b:12:2000:6300:250:56ff:fe84:43ba","TCP","86","80  >  40207 [FIN, ACK] Seq=1 Ack=2 Win=271 Len=0 TSval=1572872727 TSecr=300830160"
"5","1.257977","240b:12:2000:6300:250:56ff:fe84:43ba","2404:6800:4004:80e::2002","TCP","86","40207  >  80 [ACK] Seq=2 Ack=2 Win=138 Len=0 TSval=300830164 TSecr=1572872727"
"6","1.522004","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.204? Tell 192.168.1.66"
"7","2.522074","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.204? Tell 192.168.1.66"
"8","3.522133","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.204? Tell 192.168.1.66"
"9","4.042009","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.205? Tell 192.168.1.66"
```

### 2. 前処理（BEGIN）、後処理（END)
#### 例:処理のはじめに"-- start --"、処理の終わりに "-- finish --"を表示
解説：BEGIN{}で処理のはじめに"-- start --"を出力、 NR<=5で5行目以内を表示、END{}で処理の終わりに"-- finish --"を出力している<br>

```
$ awk -F, 'BEGIN { print "-- start --" } NR <= 5{print NR ":" $2 } END{print "-- finish --"}' proxy.csv 
-- start --
1:"Time"
2:"0.000000"
3:"1.000000"
4:"1.254539"
5:"1.257955"
-- finish --
```

### 3. 正規表現
#### 例:ARPだけ抽出
解説：$0 ~ "ARP"で行中に"ARP"の文字列がある行だけ抜き出している<br>

```
$ awk -F, '$0 ~ "ARP" {print $0}' proxy.csv
"1","0.000000","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.203? Tell 192.168.1.66"
"2","1.000000","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.203? Tell 192.168.1.66"
"6","1.522004","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.204? Tell 192.168.1.66"
```

#### 例:ARP以外抽出
解説：$0 !~ "ARP|Protocol"で "ARP"と"Protocol"に一致しない行だけ出力している<br>
※ 一行目のデータラベルの"Protocol"も除くため、 ARP or Protocol（ARP|Protocol） としている<br>

```
$ awk -F, '$0 !~ "ARP|Protocol" {print $0}' proxy.csv
"3","1.254539","240b:12:2000:6300:250:56ff:fe84:43ba","2404:6800:4004:80e::2002","TCP","86","40207  >  80 [FIN, ACK] Seq=1 Ack=1 Win=138 Len=0 TSval=300830160 TSecr=1572813386"
"4","1.257955","2404:6800:4004:80e::2002","240b:12:2000:6300:250:56ff:fe84:43ba","TCP","86","80  >  40207 [FIN, ACK] Seq=1 Ack=2 Win=271 Len=0 TSval=1572872727 TSecr=300830160"
"5","1.257977","240b:12:2000:6300:250:56ff:fe84:43ba","2404:6800:4004:80e::2002","TCP","86","40207  >  80 [ACK] Seq=2 Ack=2 Win=138 Len=0 TSval=300830164 TSecr=1572872727"
```

### 4. 正規表現と複合条件文
#### 例:はじめの３行目、かつARPのものだけ抽出
解説：$0 ~ "ARP"で"ARP"が含まれている行だけ出力、かつNR<=3で3行目以内のものだけ出力としている<br>

```
$ awk -F, '($0 ~ "ARP")&&(NR<=3) {print $0}' proxy.csv
"1","0.000000","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.203? Tell 192.168.1.66"
"2","1.000000","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.203? Tell 192.168.1.66"
```

#### 例:ARPで抽出したもの、かつはじめの３行目
解説：$0 ~ "ARP"で"ARP"が含まれている行だけ出力、パイプでつないでその中から3行目以内を出力している<br>

```
$ awk -F, '($0 ~ "ARP") {print $0}' proxy.csv| awk -F, 'NR <=3 {print $0}'
"1","0.000000","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.203? Tell 192.168.1.66"
"2","1.000000","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.203? Tell 192.168.1.66"
"6","1.522004","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.204? Tell 192.168.1.66"
```

### 5. printf文
#### 例:1〜3列目の表示と文字列の付加
解説：printfでC言語同様の出力を行っており、%sで文字列を指定している<br>

```
$ awk -F, '$0 ~ "ARP"{ printf("No:%s Time:%s Source:%s\n",$1,$2,$3) }' proxy.csv
No:"1" Time:"0.000000" Source:"Vmware_84:aa:79"
No:"2" Time:"1.000000" Source:"Vmware_84:aa:79"
No:"6" Time:"1.522004" Source:"Vmware_84:aa:79"
No:"7" Time:"2.522074" Source:"Vmware_84:aa:79"
No:"8" Time:"3.522133" Source:"Vmware_84:aa:79"
No:"9" Time:"4.042009" Source:"Vmware_84:aa:79"
No:"10" Time:"5.042068" Source:"Vmware_84:aa:79"
No:"145" Time:"6.042041" Source:"Vmware_84:aa:79"
No:"329" Time:"6.567033" Source:"Vmware_84:aa:79"
No:"1074" Time:"7.567024" Source:"Vmware_84:aa:79"
No:"2148" Time:"8.567110" Source:"Vmware_84:aa:79"
```

#### 例:一列目を６桁表示（右揃え）
解説：printf文で書式付きのデータ出力の際、%の前の数字で桁を指定している<br>
※ 左揃えにする場合は、%のあとにマイナスを入れる<br>

```
$ awk -F, '$5 ~ "ARP"{ printf("No:%6s Time:%s Source:%s\n",$1,$2,$3) }' proxy.csv
No:   "1" Time:"0.000000" Source:"Vmware_84:aa:79"
No:   "2" Time:"1.000000" Source:"Vmware_84:aa:79"
No:   "6" Time:"1.522004" Source:"Vmware_84:aa:79"
No:   "7" Time:"2.522074" Source:"Vmware_84:aa:79"
No:   "8" Time:"3.522133" Source:"Vmware_84:aa:79"
No:   "9" Time:"4.042009" Source:"Vmware_84:aa:79"
No:  "10" Time:"5.042068" Source:"Vmware_84:aa:79"
No: "145" Time:"6.042041" Source:"Vmware_84:aa:79"
No: "329" Time:"6.567033" Source:"Vmware_84:aa:79"
No:"1074" Time:"7.567024" Source:"Vmware_84:aa:79"
No:"2148" Time:"8.567110" Source:"Vmware_84:aa:79"
```

### 6. 変数
#### 例:ARPの数をカウントする
解説：BEGIN{}で変数sumを初期化、行に"ARP"が含まれる時だけsumに1を加算、END{}で結果を出力している<br>

```
awk -F, 'BEGIN {sum = 0} $5 ~ "ARP"{ sum = sum + 1 } END {print sum}' proxy.csv
30
$ awk -F, 'BEGIN {sum = 0} $5 ~ "ARP"{ sum += 1 } END {print sum}' proxy.csv
30
$ awk -F, 'BEGIN {sum = 0} $5 ~ "ARP"{ sum++ } END {print sum}' proxy.csv
30
```

### 7. if文
#### 例:一行目以降５行ごとに区切り線を入れる
解説：if文で(NR-1)%5==0の時にライン"----------"を表示している<br>

```
$ awk -F, '{print $0} {if((NR-1) % 5 == 0) {print "----------"}}' proxy.csv
"No.","Time","Source","Destination","Protocol","Length","Info"
----------
"1","0.000000","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.203? Tell 192.168.1.66"
"2","1.000000","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.203? Tell 192.168.1.66"
"3","1.254539","240b:12:2000:6300:250:56ff:fe84:43ba","2404:6800:4004:80e::2002","TCP","86","40207  >  80 [FIN, ACK] Seq=1 Ack=1 Win=138 Len=0 TSval=300830160 TSecr=1572813386"
"4","1.257955","2404:6800:4004:80e::2002","240b:12:2000:6300:250:56ff:fe84:43ba","TCP","86","80  >  40207 [FIN, ACK] Seq=1 Ack=2 Win=271 Len=0 TSval=1572872727 TSecr=300830160"
"5","1.257977","240b:12:2000:6300:250:56ff:fe84:43ba","2404:6800:4004:80e::2002","TCP","86","40207  >  80 [ACK] Seq=2 Ack=2 Win=138 Len=0 TSval=300830164 TSecr=1572872727"
----------
"6","1.522004","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.204? Tell 192.168.1.66"
"7","2.522074","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.204? Tell 192.168.1.66"
"8","3.522133","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.204? Tell 192.168.1.66"
"9","4.042009","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.205? Tell 192.168.1.66"
"10","5.042068","Vmware_84:aa:79","Broadcast","ARP","60","Who has 192.168.1.205? Tell 192.168.1.66"
----------
"11","5.522504","192.168.1.3","192.168.1.62","TCP","60","53831  >  3128 [FIN, ACK] Seq=1 Ack=1 Win=68 Len=0"
```

### 8. for文
#### 例:パケットサイズを１０で割ったものを"＊"で表示
解説：for文で$6（パケットサイズ）を10で割った値分ループを回し"*"を表示している<br>
※ proxy.csvはパケットサイズが文字列になっているためsedでバックスラッシュを消してproxy2.csvとしている<br>

```
$ sed -e 's/"//g' proxy.csv > proxy2.csv 
$ awk -F, 'NR > 1 {printf("[%-4s] size = %-4d: ",$5,$6)} {for(i=0; i < int($6/10); i++) { printf("*") }; printf("\n") }' proxy2.csv

[ARP ] size = 60  : ******
[ARP ] size = 60  : ******
[TCP ] size = 86  : ********
[TCP ] size = 86  : ********
[TCP ] size = 86  : ********
[ARP ] size = 60  : ******
[ARP ] size = 60  : ******
[ARP ] size = 60  : ******
[ARP ] size = 60  : ******
[ARP ] size = 60  : ******
[TCP ] size = 60  : ******
[TCP ] size = 60  : ******
[TCP ] size = 60  : ******
[TCP ] size = 66  : ******
[TCP ] size = 66  : ******
[TCP ] size = 66  : ******
[TCP ] size = 66  : ******
[TCP ] size = 54  : *****
[TCP ] size = 86  : ********
[TCP ] size = 54  : *****
[TCP ] size = 54  : *****
[TCP ] size = 60  : ******
[DNS ] size = 84  : ********
[TCP ] size = 66  : ******
[TCP ] size = 66  : ******
[TCP ] size = 86  : ********
[TCP ] size = 86  : ********
[HTTP] size = 294 : *****************************
[TCP ] size = 54  : *****
```

### 9. while文
#### 例:パケットサイズを１０で割ったものを"＊"で表示
解説：for文と同様のことをwhile文に書き換えている<br>

```
$ awk -F, 'NR > 1 {printf("[%-4s] size = %4d: ",$5,$6)} {i = 0; while(i < int($6/10)) { printf("*"); i++ }; printf("\n") }' proxy2.csv

[ARP ] size =   60: ******
[ARP ] size =   60: ******
[TCP ] size =   86: ********
[TCP ] size =   86: ********
[TCP ] size =   86: ********
[ARP ] size =   60: ******
[ARP ] size =   60: ******
[ARP ] size =   60: ******
[ARP ] size =   60: ******
[ARP ] size =   60: ******
[TCP ] size =   60: ******
[TCP ] size =   60: ******
[TCP ] size =   60: ******
[TCP ] size =   66: ******
[TCP ] size =   66: ******
[TCP ] size =   66: ******
[TCP ] size =   66: ******
[TCP ] size =   54: *****
[TCP ] size =   86: ********
[TCP ] size =   54: *****
[TCP ] size =   54: *****
[TCP ] size =   60: ******
[DNS ] size =   84: ********
[TCP ] size =   66: ******
[TCP ] size =   66: ******
[TCP ] size =   86: ********
[TCP ] size =   86: ********
[HTTP] size =  294: *****************************
[TCP ] size =   54: *****
```

### 10. 配列
#### 例:一行目の要素を配列に入れて全て取り出して表示
解説：split("文字列",出力先配列)で配列のrecordに出力、文字列は-F,で指定したカンマ","区切りで分割、forで要素分ループしている<br>

```
$ awk -F, '{ if(NR==1) { split($0,record); for( i in record ) { print record[i] } } }' proxy.csv 
"Destination"
"Protocol"
"Length"
"Info"
"No."
"Time"
"Source"
```

#### 例:プロトコルごとのパケット数をカウント
解説：プロトコル列($5)の文字列を配列のキーに設定し出現回数分加算、END{}で配列のキー分ループを回し結果を出力している<br>

```
$ awk -F, '{ proto[$5]++ } END{ for ( i in proto) { print i ":" proto[i]} }' proxy.csv
"DNS":1384
"TLSv1.2":453
"TCP":2475
"ALLJOYN-NS":2
"ICMP":3
"HTTP":644
"Protocol":1
"HTTP/XML":2
"ARP":30
"DHCP":1
```

## AWKによるワンライナー7つ
- 要素を取り出してフォーマットする
- タブ以外の区切りを使う
- 正規表現にマッチした行を出力する
- 正規表現のマッチを置換する
- 整数として計算する
- 他のコマンドを呼び出す
- Schwartz変換ソート

## [ワンライナーでログの集計（時間ごとの件数）](https://blog.pdata.jp/linux-command/oneliner-awk02/)
例えば、以下のようなWebサーバ（Apache）のログを１時間ごとに集計してみます。<br>

```
xxx.xxx.xxx.xxx - - [01/Dec/2023:15:51:46 +0900] "GET / HTTP/1.1" 200 2731 "-" "Mozilla/5
```
```
# cat /var/log/html/access.log | awk '{print $4;}' | cut -b 2-15 | uniq -c
 282 01/Dec/2023:00
  67 01/Dec/2023:01
  72 01/Dec/2023:02
```

## [複数行で１データのテキストを１行ずつに変換](https://blog.pdata.jp/linux-command/oneliner-awk01/)
　郵便番号、住所、氏名、電話番号の４行でワンセットのデータがあります。<br>
```
% cat test.txt
〒110-001a
北海道知床町１丁目３－ｂ
北海　太郎
0a0-9955-1234
〒921-002c
福岡県南九州市４丁目２－９
博多　次郎
0f0-2455-8744
〒551-003e
山梨県中央市２番５号
中央　三郎
0g0-5122-4824
```

次のようにして、１行１データに変換します。<br>
４行１セットなので、「NR%4」としていますが、ここは何行で１セットかによって書き換えてくださいね。<br>
```
% cat test.txt | awk '{if(NR%4)ORS=",";else ORS="\n";print}'
〒110-001a,北海道知床町１丁目３－ｂ,北海　太郎,0a0-9955-1234
〒921-002c,福岡県南九州市４丁目２－９,博多　次郎,0f0-2455-8744
〒551-003e,山梨県中央市２番５号,中央　三郎,0g0-5122-4824
```

「ORS=”,”」のところを、「ORS=” ”」とすれば、CSVではなく、スペース区切りにすることもできます。<br>
