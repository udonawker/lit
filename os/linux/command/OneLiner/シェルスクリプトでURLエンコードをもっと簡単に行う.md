## [シェルスクリプトでURLエンコードをもっと簡単に行う](https://qiita.com/ko1nksm/items/bab121dc5aa0bca2de78)

```
$ echo "日本語" | jq -Rr @uri 
%E6%97%A5%E6%9C%AC%E8%AA%9E

$ echo "日本語" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'
%E6%97%A5%E6%9C%AC%E8%AA%9E
```

### URL エンコードだけでは実用的ではない
### URL の組み立てを簡単に行う
#### jq コマンドを使う方法
#### url コマンド（自作）を使う方法 [ソースコード](https://github.com/ko1nksm/url)
### おまけ URL デコードはどうするの？
