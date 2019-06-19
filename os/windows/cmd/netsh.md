<pre>
C:\Users\user>netsh /?

使用法: netsh [-a エイリアス ファイル名] [-c コンテキスト] [-r リモート コンピューター名] [-u [ドメイン名\]ユーザー名] [-p パスワード | *]
              [コマンド | -f スクリプト ファイル名]

使用できるコマンドは次のとおりです:

このコンテキストのコマンド:
?              - コマンドの一覧を表示します。
add            - エントリの一覧に構成エントリを追加します。
advfirewall    - 'netsh advfirewall' コンテキストに変更します。
branchcache    - 'netsh branchcache' コンテキストに変更します。
bridge         - 'netsh bridge' コンテキストに変更します。
delete         - エントリの一覧から構成エントリを削除します。
dhcpclient     - 'netsh dhcpclient' コンテキストに変更します。
dnsclient      - 'netsh dnsclient' コンテキストに変更します。
dump           - 構成スクリプトを表示します。
exec           - スクリプト ファイルを実行します。
firewall       - 'netsh firewall' コンテキストに変更します。
help           - コマンドの一覧を表示します。
http           - 'netsh http' コンテキストに変更します。
interface      - 'netsh interface' コンテキストに変更します。
ipsec          - 'netsh ipsec' コンテキストに変更します。
lan            - 'netsh lan' コンテキストに変更します。
mbn            - 'netsh mbn' コンテキストに変更します。
namespace      - 'netsh namespace' コンテキストに変更します。
netio          - 'netsh netio' コンテキストに変更します。
p2p            - 'netsh p2p' コンテキストに変更します。
ras            - 'netsh ras' コンテキストに変更します。
rpc            - 'netsh rpc' コンテキストに変更します。
set            - 構成の設定を更新します。
show           - 情報を表示します。
trace          - 'netsh trace' コンテキストに変更します。
wcn            - 'netsh wcn' コンテキストに変更します。
wfp            - 'netsh wfp' コンテキストに変更します。
winhttp        - 'netsh winhttp' コンテキストに変更します。
winsock        - 'netsh winsock' コンテキストに変更します。
wlan           - 'netsh wlan' コンテキストに変更します。

利用できるサブコンテキストは次のとおりです:
 advfirewall branchcache bridge dhcpclient dnsclient firewall http interface ipsec lan mbn namespace netio p2p ras rpc trace wcn wfp winhttp winsock wlan

コマンドのヘルプを表示するには、コマンドの後にスペースを入れ、
 ? と入力してください。
 </pre>
 
 <pre>
 C:\Users\user>netsh interface ipv4 show interface

Idx     Met         MTU          状態                 名前
---  ----------  ----------  ------------  ---------------------------
  1          75  4294967295  connected     Loopback Pseudo-Interface 1
 18          25        1500  disconnected  Wi-Fi
  8          35        1500  connected     Ethernet
 </pre>
