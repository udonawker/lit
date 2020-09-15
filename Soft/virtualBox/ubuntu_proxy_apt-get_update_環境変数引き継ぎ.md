### プロキシの設定が必要な場合
### ~/.profile にプロキシ設定

<pre>
export http_proxy=http://xxx.co.jp:8080
export HTTP_PROXY=http://xxx.co.jp:8080
export https_proxy=http://xxx.co.jp:8080
export HTTPs_PROXY=http://xxx.co.jp:8080
</pre>

### apt-get 環境変数引き継ぎ
#### 参考 : [sudo時の環境変数上書き ／ 引き継ぎについて](https://qiita.com/chroju/items/375582799acd3c5137c7)

<pre>
$ sudo -E apt-get update
</pre>
