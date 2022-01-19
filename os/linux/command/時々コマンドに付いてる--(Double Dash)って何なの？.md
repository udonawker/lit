## [時々コマンドに付いてる--(Double Dash)って何なの？](https://zenn.dev/dowanna6/articles/245df006deee0c)

### 例えばNode.jsでテストを書いてる時こんなコマンドを見たことはありませんか？
```
dotenv -e .test.env -- jest --config config.json
```

.test.envの後に紛れ込んでいる --。これは一体何なのか？<br>

### 結論
「--」は「これ以降の入力はオプションではありません」と指定する記号です。<br>
bashのドキュメントでその存在について言及されています:<br>
