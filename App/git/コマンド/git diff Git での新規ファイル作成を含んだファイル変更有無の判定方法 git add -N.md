# [Git での新規ファイル作成を含んだファイル変更有無の判定方法](https://reboooot.net/post/how-to-check-changes-with-git/)

### 新規にファイルを作成した際の git diff の挙動
新規作成されたファイルは git status で Untracked files としては判定されていますが、stage/index に登録されていないので、git diff では何も出力されません。<br>

### 新規にファイルを作成した後で git add -N (–intent-to-add) した際の git diff の挙動
新規作成されたファイルは git status では変わらず Untracked files としては判定されていますが、git add -N (–intent-to-add) を実行した後だと git diff で変更内容が差分として出力されることがわかります。<br>
