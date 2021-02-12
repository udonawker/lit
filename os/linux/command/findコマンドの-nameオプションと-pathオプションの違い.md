## [findコマンドの-nameオプションと-pathオプションの違い](https://qiita.com/nkojima/items/2af0558d3faf8a3063a8)

### -nameオプション
```
find {検索するディレクトリ} -name {検索するキーワード}
```

* "-name"オプションを付けることで、ファイル名、ディレクトリ名を指定して検索できます。
  * 検索するキーワードに"*"を付けることで、ワイルドカードを使った検索が可能です。
* ただし、"-name"オプションの引数にスラッシュを含む場合は検索できないため、例えば"-name {ディレクトリ名}/{ファイル名}"とパラメーターを指定することができません。
```
[root@kumotori ~]# find /etc -name "ifcfg*"
/etc/sysconfig/network-scripts/ifcfg-eth0
/etc/sysconfig/network-scripts/ifcfg-lo
```
```
[root@kumotori /]# find / -name "/etc/sysconfig/network-scripts/*eth*"
find: warning: Unix filenames usually don't contain slashes (though pathnames do).  That means that '-name `/etc/sysconfig/network-scripts/*eth*'' will probably evaluate to false all the time on this system.  You might find the '-wholename' test more useful, or perhaps '-samefile'.  Alternatively, if you are using GNU grep, you could use 'find ... -print0 | grep -FzZ `/etc/sysconfig/network-scripts/*eth*''.
```

### -pathオプション
```
find {検索するディレクトリ} -path "{パターン}"
```

* "-path"オプションを付けると、パターンにマッチするファイルやディレクトリを検索できます。
  * 検索するパターンに"*"を付けることで、ワイルドカードを使った検索が可能です。
* "-path"オプションにはスラッシュを含むパターンを指定できるので、ディレクトリもパターンに含めて検索できます。

```
[root@kumotori /]# find /etc/sysconfig/ -path "*network-scripts/*eth*"
/etc/sysconfig/network-scripts/ifup-eth
/etc/sysconfig/network-scripts/ifcfg-eth0
/etc/sysconfig/network-scripts/ifdown-eth
```
