## [xargs で標準入力が空だったら何もしない 2012/03/16](https://qiita.com/m_doi/items/432b9145b69a0ba3132d)

```
find /hoge/fuga -ctime +30 -type f -print | xargs rm
```
などしたときに、何もfindの条件にマッチしなかったら、単に引数なしのrmが実行され<br>
```
rm: missing operand
Try `rm --help' for more information.
```
となる。<br>
こういったエラーを出したくない場合は、--no-run-if-empty を使って<br>
```
find /hoge/fuga -ctime +30 -type f -print | xargs --no-run-if-empty rm
```
としてやると、findの結果が空の場合は、rmが実行されず、エラーも出ない。<br>
