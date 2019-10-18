引用 [yum (rpm) と apt-get の対応表](http://yoshifumi.hateblo.jp/entry/20080506/p1)<br/>

## yum と apt-get 

|処理|Redhat系|Debian系|Fedora22+|
|---|---|---|---|
|キャッシュの更新||apt-get update||
|モジュールの更新|yum update|apt-get upgrade||
|パッケージの検索|yum search <検索文字列>|apt-cache search <検索文字列>||
|パッケージに含まれるファイルの検索|yum provides <検索文字列>|apt-file search <検索文字列>||
|インストール|yum install <パッケージ名>|apt-get install <パッケージ名>|dnf install <パッケージ名>|
|再インストール|yum reinstall <パッケージ名>|||
|削除|yum remove <パッケージ名> 又は rpm -e <パッケージ名>|apt-get remove <パッケージ名>||
|参照レポジトリの設定ファイル|/etc/yum.repos.d/*|/etc/apt/sources.list||
|インストール済みパッケージのリスト|rpm -qa|dpkg-query -l||
|インストール済みパッケージの変更の有無の確認|rpm -V パッケージ名|dpkg-query -l||
|（インストール済みの）指定したパッケージ内のファイルのリスト|rpm -ql <パッケージ名>|dpkg-query -L <パッケージ名>||
|ファイルがどのパッケージに属するか|rpm -qf /path/to/file|||
|インストール済みパッケージの依存パッケージのリスト|rpm -qR <パッケージ名>|apt-cache depends <パッケージ名>||
|パッケージの情報表示|rpm -qi <パッケージ名>|apt-cache show <パッケージ名>||
