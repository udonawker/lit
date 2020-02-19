[history不要！pecoでLinuxコマンド履歴を爆速で検索](https://suwaru.tokyo/history%E4%B8%8D%E8%A6%81%EF%BC%81peco%E3%81%A7linux%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E5%B1%A5%E6%AD%B4%E3%82%92%E7%88%86%E9%80%9F%E3%81%A7%E6%A4%9C%E7%B4%A2/)<br/>
[pecoる](https://qiita.com/tmsanrinsha/items/72cebab6cd448704e366)<br/>
<br/>

### peco install
[ここ](https://github.com/peco/peco/releases/)から peco linux 版の最新バージョンの URL を確認<br/>
<pre>
# 確認した URL から peco をダウンロードする
sudo wget https://github.com/peco/peco/releases/download/v0.5.7/peco_linux_amd64.tar.gz
sudo tar xzvf peco_linux_386.tar.gz
sudo rm peco_linux_386.tar.gz
cd peco_linux_386
sudo chmod +x peco
 
# PATH が通っているところにファイルをコピー
sudo cp peco /usr/local/bin
cd ..
sudo rm -r peco_linux_386/
</pre>
