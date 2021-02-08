## [grepで指定した拡張子のみ対象としサブディレクトリも含む再帰検索する方法](https://linux.just4fun.biz/?%E9%80%86%E5%BC%95%E3%81%8DUNIX%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89/grep%E3%81%A7%E6%8C%87%E5%AE%9A%E3%81%97%E3%81%9F%E6%8B%A1%E5%BC%B5%E5%AD%90%E3%81%AE%E3%81%BF%E5%AF%BE%E8%B1%A1%E3%81%A8%E3%81%97%E3%82%B5%E3%83%96%E3%83%87%E3%82%A3%E3%83%AC%E3%82%AF%E3%83%88%E3%83%AA%E3%82%82%E6%A4%9C%E7%B4%A2%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95)

### includeオプションで拡張子を指定(パターンを指定)

以下に記す構文により、指定したパターンのファイルのみ対象として検索します。<br>
もちろん、配下のディレクトリ内のファイルも対象となります。(再帰検索となります。)<br>
```
grep -r --include=パターン 検索文字列 ディレクトリ
```
尚、オプション-rでサブディレクトリも対象となります。<br>

#### includeオプションなしでcygwinというキーワードを検索~
たくさん出力されてしまいます。<br>
```
$ grep -r cygwin /etc/
/etc/csh.login:  set term=cygwin
/etc/defaults/etc/csh.login:  set term=cygwin
/etc/defaults/etc/DIR_COLORS:TERM cygwin
/etc/defaults/etc/DIR_COLORS:TERM rxvt-cygwin
/etc/defaults/etc/DIR_COLORS:TERM rxvt-cygwin-native
<省略>
```

#### 拡張子confのみ対象としてgrep
```
$ grep -r --include='*.conf' cygwin /etc/
/etc/nsswitch.conf:#    see https://cygwin.com/cygwin-ug-net/ntsec.html#ntsec-mapping-nsswitch
```

### excludeオプションもあります
指定した拡張子のファイルのみ対象とする場合は、includeでしたが、除外するexcludeオプションもあります。<br>
構文はincludeと同じで、includeがexcludeにかわります。<br>

実行例<br>
```
$ grep -r --exclude='*.conf' cygwin /etc/ | head -10
/etc/csh.login:  set term=cygwin
/etc/defaults/etc/csh.login:  set term=cygwin
/etc/defaults/etc/DIR_COLORS:TERM cygwin
/etc/defaults/etc/DIR_COLORS:TERM rxvt-cygwin
/etc/defaults/etc/DIR_COLORS:TERM rxvt-cygwin-native
<省略>
```

### パターンなので拡張子だけではない 
include, exclude に指定するのはパターンなので、以下のようにファイル名にbashという文字列が含まれるものを対象とするようなこともできます。<br>
```
$ grep -r --include='*bash*' cygwin /etc/
/etc/defaults/etc/skel/.bashrc:# a patch to the cygwin mailing list.
/etc/defaults/etc/skel/.bash_profile:# a patch to the cygwin mailing list.
/etc/skel/.bashrc:# a patch to the cygwin mailing list.
/etc/skel/.bash_profile:# a patch to the cygwin mailing list.
```
