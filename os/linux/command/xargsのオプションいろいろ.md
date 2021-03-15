## [xargs のオプションいろいろ 2016/1/16](https://qiita.com/hitode7456/items/6ba8e2d58f9b8db9de11)

# 実験環境
今回実験に利用する環境は CentOS 6.4 です。<br>
xargs は Linux 系と BSD 系でオプションが異なりますので、ご注意下さい。<br>

# 実験用スクリプト
今回の実験に利用するスクリプトです。このスクリプトを xargs の引数に渡します。<br>
以降、このスクリプトの様に xargs に渡すコマンドを、 xargs 引数コマンド と呼ぶことにします。<br>

```
#!/bin/sh

# 実行時間を擬態
sleep 1

# コマンド引数表示時の最大文字数
max_len=50

# 最大文字数を超えた場合のトリミング
a=$@
if [ $max_len -lt ${#a} ]
then
    a="${a:0:$max_len}..."
fi

# プロセス番号, コマンド引数の数、コマンド引数のリストを出力
echo pid[$$] numArgs[$#] args[$a]
```

* 実験時に `time` を使って実行時間を測定しますので、 `sleep` で実行時間を偽装しています
* `xargs` に渡される引数を観測するための情報を標準出力に出力しています

## seq
seq は数列を出力するコマンドです。<br>
```
$ seq 10
1
2
3
4
5
6
7
8
9
10

$ seq -s ' ' 10
1 2 3 4 5 6 7 8 9 10
```
このコマンドを利用し、 `xargs`引数コマンド に、どのように引数が渡されるか観測します。<br>

### 通常の実行
```
$ time seq 10 | xargs ./echo.sh T
pid[13795] numArgs[11] args[T 1 2 3 4 5 6 7 8 9 10]

real    0m1.007s
user    0m0.000s
sys     0m0.002s
```
`xargs` のオプション無しで実行した場合です。<br>
標準入力から渡されたデータが、全て `xargs引数コマンド` (`echo.sh`)の引数に展開されます。<br>
標準入力から渡されたデータの他に、 `echo.sh` に `T` という引数を直接渡しています。<br>
出力結果の `args[T 1 2 3 4 5 6 7 8 9 10]` の部分からわかるように、標準入力から渡されたデータは最後尾に展開されます。<br>
`echo.sh` は1回の起動で、処理時間は約1秒です。<br>

### -L オプション
```
$ time seq 10 | xargs -L 5 ./echo.sh T
pid[15157] numArgs[6] args[T 1 2 3 4 5]
pid[15172] numArgs[6] args[T 6 7 8 9 10]

real    0m2.022s
user    0m0.002s
sys     0m0.003s
```

`-L` は、 `xarg引数コマンド` に一度に展開されるデータの最大値を指定します。<br>
標準出力から渡されたデータ数が、 `-L` で指定された数よりお大きい場合、全てのデータが展開し終わるまで `xargs引数コマンド` が繰り返し実行されます。<br>
今回の場合は、データ数が `10` ですので、 `10/5=2` で、 `echo.sh` が2回実行されました。<br>
処理時間が約2秒なので、逐次に実行されたことが分かります。<br>

### -P オプション
```
$ time seq 10 | xargs -L 5  -P 2  ./echo.sh T
pid[15256] numArgs[6] args[T 1 2 3 4 5]
pid[15257] numArgs[6] args[T 6 7 8 9 10]

real    0m1.011s
user    0m0.003s
sys     0m0.003s
```

`-L` オプションに加え、 `-P` オプションを付け加えて実行しました。<br>
`-P` オプションは、 `xargs引数コマンド` の同時実行数の最大値を指定します。<br>
`-L` オプションで5を指定しただけの場合、 `echo.sh` が2回、逐次に実行されましたので、約2秒かかりました。<br>
`-P` オプションで2を追加指定した場合、 `echo.sh` が同時に実行されるので、約1秒で終了しました。<br>

### -I オプション
```
$ time seq 10 | xargs -IXXX ./echo.sh XXX T
pid[15382] numArgs[2] args[1 T]
pid[15387] numArgs[2] args[2 T]
pid[15391] numArgs[2] args[3 T]
pid[15395] numArgs[2] args[4 T]
pid[15400] numArgs[2] args[5 T]
pid[15404] numArgs[2] args[6 T]
pid[15408] numArgs[2] args[7 T]
pid[15413] numArgs[2] args[8 T]
pid[15417] numArgs[2] args[9 T]
pid[15421] numArgs[2] args[10 T]

real    0m10.057s
user    0m0.005s
sys     0m0.016s
```

`-I` オプションにより、標準入力より渡されたデータを、 `xargs引数コマンド` の、任意の位置の引数に展開することが可能です。<br>
`args[1 T]` の様に、 `echo.sh` に直接渡された引数 `T` よりも前に( XXX が置かれた位置)展開されています。<br>
`-I` オプションを指定した場合、 `-L` オプションは無効になります。<br>

```
$ time seq 10 | xargs -L 5 -IXXX  ./echo.sh XXX T
pid[15536] numArgs[2] args[1 T]
pid[15541] numArgs[2] args[2 T]
pid[15545] numArgs[2] args[3 T]
pid[15549] numArgs[2] args[4 T]
pid[15554] numArgs[2] args[5 T]
pid[15558] numArgs[2] args[6 T]
pid[15562] numArgs[2] args[7 T]
pid[15567] numArgs[2] args[8 T]
pid[15571] numArgs[2] args[9 T]
pid[15574] numArgs[2] args[10 T]

real    0m10.086s
user    0m0.004s
sys     0m0.012s
```

`-I` オプションを指定した場合でも、 `-P` オプションは有効です。<br>

```
$ time seq 10 | xargs  -P 2 -IXXX ./echo.sh XXX T
pid[15645] numArgs[2] args[1 T]
pid[15646] numArgs[2] args[2 T]
pid[15652] numArgs[2] args[3 T]
pid[15654] numArgs[2] args[4 T]
pid[15658] numArgs[2] args[5 T]
pid[15660] numArgs[2] args[6 T]
pid[15664] numArgs[2] args[7 T]
pid[15666] numArgs[2] args[8 T]
pid[15674] numArgs[2] args[9 T]
pid[15677] numArgs[2] args[10 T]

real    0m5.033s
user    0m0.006s
sys     0m0.009s
```

`-P` オプションで同時実行数を2に指定しました。その効果により、 `echo.sh` が10回実行されているのに、処理時間は約5秒です。<br>

### -n オプション

`-n` オプションは、 `xargs引数コマンド` に渡す引数の最大値を指定します。<br>
`-L` オプションと似ています。違いは以下の例で確認できます。<br>

```
$ time seq -s ' ' 10 | xargs  -L  2  ./echo.sh  T
pid[23843] numArgs[11] args[T 1 2 3 4 5 6 7 8 9 10]

real    0m1.007s
user    0m0.001s
sys     0m0.002s

$ time seq -s ' ' 10 | xargs  -n 2 ./echo.sh  T
pid[23897] numArgs[3] args[T 1 2]
pid[23902] numArgs[3] args[T 3 4]
pid[23906] numArgs[3] args[T 5 6]
pid[23910] numArgs[3] args[T 7 8]
pid[23915] numArgs[3] args[T 9 10]

real    0m5.020s
user    0m0.002s
sys     0m0.002s
```

`seq` に `-seq` を指定することにより、改行を入れないデータを `xargs` の標準入力に渡しています。<br>
`-L` オプションでは、改行無しのデータは1つのデータとみなされ、 `xargs引数コマンド` に展開されるます。<br>
対して、 `-n` オプションでは、 `xargs` が `xargs引数コマンド` に渡す引数の数の最大値を制限します。<br>

## その他
### 標準入力で渡されるデータのサイズ
`xargs` によって展開されるデータのサイズや個数については限界があります。<br>
限界を超えたデータが渡された場合、展開可能な分毎に `xargs引数コマンド` が実行されます。<br>

```
$ time seq  100000  | xargs  ./echo.sh  T
pid[29078] numArgs[23695] args[T 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 ...]
pid[29087] numArgs[21844] args[T 23695 23696 23697 23698 23699 23700 23701 23702 ...]
pid[29096] numArgs[21844] args[T 45538 45539 45540 45541 45542 45543 45544 45545 ...]
pid[29103] numArgs[21844] args[T 67381 67382 67383 67384 67385 67386 67387 67388 ...]
pid[29112] numArgs[10778] args[T 89224 89225 89226 89227 89228 89229 89230 89231 ...]

real    0m12.134s
user    0m5.704s
sys     0m0.052s
```

限界は、 `xargs引数コマンド` に渡される引数の数や、展開後のコマンドライン全体の長さ等、複数条件があります。<br>
それらは `-show-limts` オプションで調べることが可能です。<br>

```
$ xargs --show-limits
Your environment variables take up 2560 bytes
POSIX upper limit on argument length (this system): 2616832
POSIX smallest allowable upper limit on argument length (all systems): 4096
Maximum length of command we could actually use: 2614272
Size of command buffer we are actually using: 131072

Execution of xargs will continue now, and it will try to read its input and run commands; if this is not what you wanted to happen, please type the end-of-file keystroke.
Warning: /bin/echo will be run at least once.  If you do not want that to happen, then press the interrupt keystroke.
```

また、今回はデータの数が多かっため、実行時間が12秒と、理論値である5秒よりも多くなってしまっています。<br>

### -P オプション指定時の実行時間
今回の例では `-P` オプションを利用することにより、理論値に近い並列効果を得ることができました。<br>
しかし、実行中に CPU をフルに使い続けるようなコマンドを `xargs引数コマンド` を指定した場合は、利用環境のCPU数(コア数)に依存した並列効果になります。<br>
