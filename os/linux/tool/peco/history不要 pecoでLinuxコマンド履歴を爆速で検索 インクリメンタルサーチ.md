[history不要！pecoでLinuxコマンド履歴を爆速で検索](https://suwaru.tokyo/history%E4%B8%8D%E8%A6%81%EF%BC%81peco%E3%81%A7linux%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E5%B1%A5%E6%AD%B4%E3%82%92%E7%88%86%E9%80%9F%E3%81%A7%E6%A4%9C%E7%B4%A2/)<br/>
[pecoる](https://qiita.com/tmsanrinsha/items/72cebab6cd448704e366)<br/>
[git/peco release](https://github.com/peco/peco/releases/)<br/>
[毎回コマンド調べてない？それpeco使えば解決できるよ ...](https://webcache.googleusercontent.com/search?q=cache:xhc8LHioYzAJ:https://blog.dais0n.net/peco/+&cd=8&hl=ja&ct=clnk&gl=jp)<br/>
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


<br/><br/><br/>
#### pecoの利用シーン
<pre>
vi $(find . -name '*.go' | peco)

# 現在以下のディレクトリを検索し、インクリメンタルサーチ後移動
cd "$(find . -type d | peco)"

# git logをインクリメンタルサーチ後、その結果をgit showする
git log --oneline | peco | cut -d" " -f1 | xargs git show

# sshしたことのあるサーバをインクリメンタルサーチ
ssh $(grep -o '^\S\+' ~/.ssh/known_hosts | tr -d '[]' | tr ',' '\n' | sort | peco)
</pre>

#### bash history インクリメンタルサーチ
.bashrcに以下のステップで設定を入れる<br/>
履歴の設定<br/>
<pre>
export HISTCONTROL=ignoreboth:erasedups # 重複履歴を無視
HISTSIZE=5000 # historyに記憶するコマンド数
HISTIGNORE="fg*:bg*:history*:h*" # historyなどの履歴を保存しない
HISTTIMEFORMAT='%Y.%m.%d %T' # historyに時間を追加
</pre>

pecoを利用した関数をショートカットに登録<br/>
<pre>
peco_history() {
    declare l=$(HISTTIMEFORMAT=  history | LC_ALL=C sort -r |  awk '{for(i=2;i&lt;NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}'   |  peco --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
}
bind -x '"\C-x\C-r": peco_history'
</pre>
