## [bashで標準出力、エラーを捨てるとか、ファイルディスクリプタ](https://qiita.com/harasakih/items/868a850fcdc99a2c37b0)

## 1. bashで標準出力、エラーを捨てるとか、ファイルディスクリプタ
### ファイルディスクリプタ
```
0:stdin
1:stdout
2:stderr
```

### 標準出力と標準エラー出力をまとめて file に書き出す場合
```
% command >file 2>&1
 --- 標準出力  ( 1> )はfileに出力し
 --- 標準エラー( 2> )も標準出力と同じものにする
```

### 標準エラー出力のみをページャなどで見たい場合は、
```
% command 2>&1 1>/dev/null | less
```
2>&1の本当の意味は<br>
2 の出力先を、1 の出力先と同じものに設定する<br>

## 2. 標準エラー出力を捨てる
### 両方を捨てる
```
$ ./foo &> /dev/null　　あるいは　　$ ./foo > /dev/null 2>&1
```

### stdoutを捨てる,stderrのみ出力
```
$ ./foo 1> /dev/null
```

### stderrを捨てる,stdoutのみ出力
```
$ ./foo 2> /dev/null
```

### それぞれを別のファイルに出力
```
$ ./foo 1> stdout 2> stderr
$ cat stderr
stderr
$ cat stdout
stdout
```

### 両方を同じファイルに
```
$ ./foo > both  2>&1　あるいは　　$ ./foo &> both
$ cat both
stderr
stdout
```

## 3. 標準エラーをパイプでつなぐ
### 前提
```
$ ./stderrput
printf  to stdout
fprintf to stderr
fprintf to stdout
```

### 標準出力、標準エラーの両方を、パイプでつなぐ
```
$ ./stderrput 2>&1 | less
```

### これはNG
```
$ ./stderrput &> | less
-bash: syntax error near unexpected token `|'
```

### 標準エラーのみ、パイプで
```
$ ./stderrput 2>&1 1> /dev/null | less
```

### 標準出力のみ、パイプで
```
$ ./stderrput | less
```

### 考え方
```
　2>&1  ---  標準エラー（＃2）を、標準出力（＃1）と同じ出力先へ
　1> /dev/null --- さらに、標準出力（＃1）をヌルへ
```
