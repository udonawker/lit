引用<br/>
[githubをブラウザでフル活用する方法](https://qiita.com/reikubonaga/items/da5992a8360ccfa25106 "https://qiita.com/reikubonaga/items/da5992a8360ccfa25106")<br/>

### commitに移動する
- https://github.com/wantedly/wantedly/tree/****
- branck名でもcommit番号でもtag番号でも大丈夫
### ディレクトリに移動する
- https://github.com/wantedly/wantedly/tree/master/directory_path
- masterをcommit番号などに変更する
### ファイルを表示する
- https://github.com/wantedly/wantedly/blob/master/file_path
- masterをcommit番号などに変更する
### historyを見る
- https://github.com/wantedly/wantedly/commits/master/file_path
- blobをcommitsに変更
- masterをcommit番号などに変更する
### git blameする
- https://github.com/wantedly/wantedly/blame/master/file_path
- blobをblameに変更
- masterをcommit番号などに変更する
### ★commitに関連するissueとpull requestを見つける
- https://github.com/wantedly/wantedly/search?type=Issues&q=query
- queryにcommit番号を指定する
- code画面から/でショートカット
### version間のdiffを見る
- https://github.com/wantedly/wantedly/compare/master...master
- masterはcommit番号を指定する
- https://github.com/rails/rails/compare/master@{1.day.ago}...master
- 日付の指定もできる
### commit historyを人で検索
- https://github.com/rails/rails/commits/master?author=dhh
### ★ショートカットを活用してページ移動
- gc codeの画面に移動
- gi issue画面に移動
- gp pull request画面に移動
- gc + w code画面からbranchを探せる
- s 全レポジトリから検索
- gi + c issueを作成
### ★インクリメンタルファイルサーチ
- https://github.com/wantedly/wantedly/find/master
- code画面で、tでショートカット移動
- masterをcommit番号に変更する
