## [Linuxのtreeコマンドの使い方をまとめてみた](https://qiita.com/wildmouse/items/4821ff338dd80d3c3881)

## Listing options
### -a: 全ファイルを表示
全てのファイルを表示するオプションですが、具体的には.(ドット)から始まるファイルが表示対象に追加されます。<br>
裏を返せばデフォルトではドットから始まるファイルは表示されないということなので注意が必要ですね。<br>

`-aオプションありの場合`
```
$ tree -L 1 -a
.
├── .editorconfig
├── .git
├── .gitignore
├── README.md
├── assets
├── components
├── layouts
├── middleware
├── node_modules
├── nuxt.config.js
├── package-lock.json
├── package.json
├── pages
├── plugins
├── static
└── store
```

`-aオプションなしの場合`
```
$ tree -L 1
.
├── README.md
├── assets
├── components
├── layouts
├── middleware
├── node_modules
├── nuxt.config.js
├── package-lock.json
├── package.json
├── pages
├── plugins
├── static
└── store
```

### -d: ディレクトリのみ表示
ディレクトリのみを表示するオプションです。<br>
ファイルを一緒に表示すると行数が多くなってしまうので、結構頻繁に使うかもしれませんね。<br>
`-dオプションありの場合`
```
tree -L 1 -d
.
├── assets
├── components
├── layouts
├── middleware
├── node_modules
├── pages
├── plugins
├── static
└── store
```

`-dオプションなしの場合`
```
$ tree -L 1
.
├── README.md
├── assets
├── components
├── layouts
├── middleware
├── node_modules
├── nuxt.config.js
├── package-lock.json
├── package.json
├── pages
├── plugins
├── static
└── store
```

### -f: フルパスで表示
ファイルやディレクトリの表示をカレントディレクトリからのフルパスで表示します。<br>
(パスを指定した場合はそのパスからのフルパスになる)。<br>

### -L level: 表示階層の深さを指定
表示する階層の深さを指定できます、全階層を表示すると把握できなくなってしまう場合などに使いそうですね。<br>
```
$ tree -L 1
.
├── README.md
├── assets
├── components
├── layouts
├── middleware
├── node_modules
├── nuxt.config.js
├── package-lock.json
├── package.json
├── pages
├── plugins
├── static
└── store
```

### -P pattern: ファイル名のパターンマッチング
引数としてパターンを指定して、各ディレクトリに加えて、そのパターンとファイル名が合致するファイルを表示します。<br>
`-Pオプション有りの場合`
```
$ tree -L 1 -P "*js*"
.
├── assets
├── components
├── layouts
├── middleware
├── node_modules
├── nuxt.config.js
├── package-lock.json
├── package.json
├── pages
├── plugins
├── static
└── store
```

`-Pオプション無しの場合`
```
$ tree -L 1
.
├── README.md
├── assets
├── components
├── layouts
├── middleware
├── node_modules
├── nuxt.config.js
├── package-lock.json
├── package.json
├── pages
├── plugins
├── static
└── store
```

### -I pattern: ファイル名のパターンマッチング（除外）
Pオプションとは逆に、与えられたパターンに合致するファイルを表示しません。<br>
IはIgnoreの略だと思われます。<br>

`-Iオプション有りの場合`
```
$ tree -L 1 -I "*js*"
.
├── README.md
├── assets
├── components
├── layouts
├── middleware
├── node_modules
├── pages
├── plugins
├── static
└── store
```

`-Iオプション無しの場合`
```
$ tree -L 1
.
├── README.md
├── assets
├── components
├── layouts
├── middleware
├── node_modules
├── nuxt.config.js
├── package-lock.json
├── package.json
├── pages
├── plugins
├── static
└── store
```

### -o filename: ファイルに結果を出力する
Output to file instead of stdout.<br>
指定したファイル名にtreeの表示結果を出力・保存します。<br>
ファイルが既に存在する場合で書き込み可能な場合は上書きされるので注意。<br>

## Graphics options: 描画関連
### -i: ツリーの表示を無くす
ツリーが表示されなくなります、階層も関係なくなるため階層下のファイルやディレクトリを全て列挙する場合などに使える感じですね。<br>
```
$ tree -L 1 -i
.
README.md
assets
components
layouts
middleware
node_modules
nuxt.config.js
package-lock.json
package.json
pages
plugins
static
store
```

### -C Turn colorization on always.
表示結果が色づけされて表示されます。<br>
今回はMacで試しましたが、デフォルトではディレクトリのみが色づけされている感じでした。<br>

## XML/HTML/JSON options: 出力フォーマット関連
### -X: XML形式で表示
XML形式での出力になります。<br>

```
$ tree -L 1 -X
<?xml version="1.0" encoding="UTF-8"?>
<tree>
<directory name=".">
<file name="README.md"></file>
<directory name="assets">
</directory>
<directory name="components">
</directory>
<directory name="layouts">
</directory>
<directory name="middleware">
</directory>
<directory name="node_modules">
</directory>
<file name="nuxt.config.js"></file>
<file name="package-lock.json"></file>
<file name="package.json"></file>
<directory name="pages">
</directory>
<directory name="plugins">
</directory>
<directory name="static">
</directory>
<directory name="store">
</directory>
</directory>
<report>
<directories>9</directories>
<files>4</files>
</report>
</tree>
```

### -J: JSON形式で表示
JSON形式での出力になります。今っぽくていいですね！<br>

```
$ tree -L 1 -J
[{"type":"directory","name": ".","contents":[
{"type":"file","name":"README.md"},
{"type":"directory","name":"assets","contents":[
]},
{"type":"directory","name":"components","contents":[
]},
{"type":"directory","name":"layouts","contents":[
]},
{"type":"directory","name":"middleware","contents":[
]},
{"type":"directory","name":"node_modules","contents":[
]},
{"type":"file","name":"nuxt.config.js"},
{"type":"file","name":"package-lock.json"},
{"type":"file","name":"package.json"},
{"type":"directory","name":"pages","contents":[
]},
{"type":"directory","name":"plugins","contents":[
]},
{"type":"directory","name":"static","contents":[
]},
{"type":"directory","name":"store","contents":[
]}
]},
{"type":"report","directories":9,"files":4}
]
```

### -H baseHREF: tree結果のハイパーリンクを作成する
サイトマップ的な感じのHTMLを生成できます。<br>
`tree -H .`等で実行。
