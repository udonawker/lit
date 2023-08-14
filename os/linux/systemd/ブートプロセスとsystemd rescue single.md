## [1.01.3 ブートプロセスとsystemd](https://linuc.org/study/samples/4244/?hm_ct=3eb824ddc0011d34ef2a9dee409b1391&hm_cv=3f25211b47622df5e60f618ed4840d13&hm_cs=3405646265fcc645dc30868.60445446&hm_mid=mc5o1&hm_id=mc5o1&hm_h=a05.hm-f.jp)

```
例題
systemdを採用しているシステムで、起動している状態のままシングルユーザモードに変更したい。
適切なコマンドを一つ選択してください。

# systemctl set-default rescue.target
# systemctl set-default single.target
# systemctl default single.target
# systemctl isolate rescue.target
※この例題は実際の試験問題とは異なります。
```

```
解答と解説
表示
正解は、「4. # systemctl isolate rescue.target」です。
シングルユーザモードとは、コンソールから管理者ユーザ(rootユーザ)のみがログインでき、操作することのできる動作モードのことです。
従来のSysVinit/Upstartのランレベルでは、ランレベル1がシングルユーザモードでした。systemdでは、従来のSysVinit/Upstartのランレベルに相当するターゲットがデフォルトで存在します。

SysVランレベルとsystemdターゲットの比較は以下の通りです。

ランレベル	ターゲットユニット	詳細
0	poweroff.target	システムをシャットダウンし電源を切ります
1	rescue.target	レスキューモード（シングルユーザモード）にシステムを切り替えます
2～4	multi-user.target	非グラフィカルなインタフェースで複数ユーザがシステムを利用できる状態に切り替えます
5	graphical.target	グラフィカルなインタフェースで複数ユーザがシステムを利用できる状態に切り替えます
6	reboot.target	システムをシャットダウンして再起動します
つまり、systemdではrescue.targetがシングルユーザモードに相当します。

また、systemdを使用しシステムを管理する際は、systemctlコマンドを使用します。systemctlコマンドを使ってターゲットを管理するには以下のサブコマンドを使用します。

get-default	：	デフォルトターゲットの確認
set-default	：	デフォルトターゲットの変更
default	：	現在のターゲットをデフォルトターゲットに変更
isolate	：	指定したターゲットが依存するユニット以外すべて停止し、指定したターゲットを起動
今回の例題では、「起動している状態のままシングルユーザモードに変更したい」とあるため、「isolate」サブコマンドを使用し、シングルユーザモードに相当するrescue.targetを指定します。
これにより、rescueターゲットに依存するユニット以外全て停止し、rescueターゲットが起動されます。

よって、「4. # systemctl isolate rescue.target」が正解となります。

それでは、例題の選択肢について解説します。

１．# systemctl set-default rescue.target
不正解です。

set-defaultは、デフォルトターゲットを変更するためのサブコマンドです。このコマンドを実行した場合、次回起動時のターゲットがrescue.targetとなります。
シングルユーザモードで起動するには、一度再起動を行わなければならないため不正解となります。

２． # systemctl set-default single.target
不正解です。

選択肢1で解説した通り、set-defaultは、デフォルトターゲットを変更するためのサブコマンドです。また、システムで定義されているターゲットにsingle.targetというターゲットは存在しません。
よって不正解となります。

３．# systemctl default single.target
不正解です。

defaultは、現在のターゲットをデフォルトターゲットに変更するサブコマンドです。
引数は指定せず、以下のように実行します。

# systemctl default
書式から異なるため不正解となります。

４． # systemctl isolate rescue.target
正解です。

今回選択肢にはありませんでしたが、シングルユーザモード（レスキューモード）への切り替えは以下のコマンドでも行うことができます。

# systemctl rescue
シングルユーザモード（レスキューモード）への切り替えは、システムでトラブルが起きた時など、障害対応を行う場合に使用することがあります。必要に応じて利用できるようにしておきましょう。
```
