## [syslogの溢れ対策](https://www.rite.jp/suppressed-messages/)

### 解説
CentOS/RHEL 7のロギングは、journaldとrsyslogの２つのプロセスが担当している。<br>
役割はそれぞれ以下。<br>

* journald:各プロセスからのメッセージを収集
* rsyslog:journaldに収集されたものを、syslogメッセージとして記録

つまり、journaldが集めて（必要なものは）rysyslogが記録する。<br>
デフォルト設定では、この2つのプロセスは記録件数に制限をかけている。<br>
これが溢れる原因だ。<br>

#### man journald.confより抜粋<br>
```
Defaults to 1000 messages in 30s.
```
（≒journaldのデフォルトでは30秒で1000メッセージまで記録。それ以上は破棄）<br>

#### rsyslog.comより抜粋
```
ratelimit.interval seconds (default: 600)
ratelimit.burst messages (default: 20000)
```
（≒rsyslogのデフォルトでは600秒で20000メッセージまで記録。それ以上は破棄）<br>

### 対策
記録件数を変えるには、/etc/systemd/journald.confを変更すればいい。<br>
RateLimitIntervalの範囲時間内で、許容する記録件数をRateLimitBurstで指定する。<br>
以下の例だと30秒で10000メッセージまで記録する設定になる。<br>

/etc/systemd/journald.conf<br>
```
### [Journal]セクション末尾に追加する
RateLimitInterval=30s
RateLimitBurst=10000
```
もちろんjournaldだけでなくrsyslogも変更しておこう。<br>
<br>

/etc/rsyslog.conf<br>
```
### 末尾に追加する
$imjournalRatelimitInterval 30
$imjournalRatelimitBurst 10000
```

変更が終わったら反映させる。<br>
```
### jornalプロセスを再起動
systemctl status systemd-journald
systemctl restart systemd-journald
systemctl status systemd-journald

### rsyslogプロセスを再起動
ps auxwww | grep rsyslog
systemctl restart rsyslog.service
ps auxwww | grep rsyslog
```

### Tips
**Tips1**

設定値を考えるのが面倒な場合は、以下にすれば無条件ですべて記録する。<br>

/etc/systemd/journald.conf<br>
```
### [Journal]セクション末尾に追加する
RateLimitBurst=0
```
/etc/rsyslog.conf<br>
```
### 末尾に追加
$imjournalRatelimitInterval 0
```

※変更が終わったら反映させる。<br>
```
### jornalプロセスを再起動
systemctl restart systemd-journald
 
### rsyslogプロセスを再起動
systemctl restart rsyslog.service
```

**Tips2**
Qiitaでこのあたりをまとめてくれている人がいたので参考にどうぞ。

[Qiita:CentOS7(RHEL7)でmaillogが正常に出力されなかったときの対応](http://qiita.com/kitaji0306/items/34efc0efd91e849c0fe9)
