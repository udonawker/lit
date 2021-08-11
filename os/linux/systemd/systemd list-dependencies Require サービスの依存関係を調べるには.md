## [サービスの依存関係を調べるには](https://www.clear-code.com/blog/2015/12/28.html)

`systemctl`には`list-dependencies`というオプションがあり、依存関係を調べてツリー表示できます。 ここでいう依存関係は`Requires=`や`Wants=`といった、必要となるunitに着目した依存関係です。<br>
起動順に着目して調べるには、`list-dependencies`に`--before`や`--after`を併せて指定します。<br>
`--before`を指定するとunitファイルの`Before=`ディレクティブをたどって依存関係を表示します。 同様に`--after`を指定するとunitファイルの`After=`ディレクティブをたどって依存関係を表示します。

例えば、`getty@tty1`がどのサービスの前に起動していないといけないことになっているかを調べるには次のようにします。

```
% systemctl list-dependencies --before getty@tty1
getty@tty1.service
● ├─getty.target
● │ └─multi-user.target
● │   ├─systemd-update-utmp-runlevel.service
● │   └─graphical.target
● │     └─systemd-update-utmp-runlevel.service
● └─shutdown.target
```

これは、実際に`getty@tty1.service`に以下の記述があることと一致しています<br>
```
# If additional gettys are spawned during boot then we should make
# sure that this is synchronized before getty.target, even though
# getty.target didn't actually pull it in.
Before=getty.target
IgnoreOnIsolate=yes
```


### Require調べ方(依存されているサービス)
# grep -r Requires= /usr/lib/systemd/system
;もしくは
# grep -r [依存先サービス名] /usr/lib/systemd/system
