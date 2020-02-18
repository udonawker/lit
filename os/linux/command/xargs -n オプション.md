[xargs のオプションいろいろ](https://qiita.com/hitode7456/items/6ba8e2d58f9b8db9de11#orgheadline9)<br/>

- 1 準備
  - 1.1. 実験環境
  - 1.2. 実験用スクリプト
  - 1.3. seq
- 2 通常の実行
- 3 -L オプション
- 4 -P オプション
- 5 -I オプション
- 6 -n オプション
- 7 その他
  - 7.1. 標準入力で渡されるデータのサイズ
  - 7.2. -P オプション指定時の実行時間

## -n オプション
`-n` オプションは、 xargs引数コマンド に渡す引数の最大値を指定します。<br/>
`-L` オプションと似ています。違いは以下の例で確認できます。<br/>

<pre>
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
</pre>

`seq` に `-seq` を指定することにより、改行を入れないデータを xargs の標準入力に渡しています。<br/>
`-L` オプションでは、改行無しのデータは1つのデータとみなされ、 xargs引数コマンド に展開されるます。<br/>
対して、 `-n` オプションでは、 xargs が xargs引数コマンド に渡す引数の数の最大値を制限します。<br/>
