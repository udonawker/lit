## [snmptranslate の使い方](https://blog.yskw.info/articles/154/)

## snmptranslate
### 数値からテキストに変換
```
snmptranslate OID
```

### 名前から数値に変換
```
snmptranslate -On NAME
```

## その他
### TWSNMP
TWISE Labo.さんが公開している、Windows 上で動作する SNMP マネージャー。<br>
snmp マネージャとしてもフリーとは思えない程しっかりしているが、このソフトに含まれている「MIBツリー」機能で mib ファイルの内容を視覚的に確認可能。<br>
残念ながら更新は 2011 年で止まってしまっていますが、MIBツリーは今でも普通に使えて、かなり便利なのでオススメです。<br>

### Cisco SNMP オブジェクトナビゲータ
mib-2 や cisco の private-mib ならここからも視覚的に閲覧可能。<br>
サイトにも注意書きが有る通り、日本語は頼りにならないので、細かい点を確認したいときは米国サイトを見るようにすること。<br>
