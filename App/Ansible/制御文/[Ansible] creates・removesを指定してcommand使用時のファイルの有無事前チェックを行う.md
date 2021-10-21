## [Ansible creates/removesを指定してcommand使用時のファイルの有無事前チェックを行う](https://zaki-hmkc.hatenablog.com/entry/2020/09/07/125924#%E4%BD%99%E8%AB%87src%E3%81%A8dest%E3%81%AB%E5%B7%AE%E7%95%B0%E3%81%8C%E3%81%82%E3%82%8B%E5%A0%B4%E5%90%88%E3%81%AF%E4%B8%8A%E6%9B%B8%E3%81%8D)

* 書式
* creates
* removes
* 同時指定
* 例: 「ファイルを移動する」をこれ使って簡易的にやりたいとき
  * srcファイルが無い場合
  * destファイルが既にある場合
    * srcがあっても無視
    * srcがあるならdestを上書き
    * (余談)srcとdestに差異がある場合は上書き
