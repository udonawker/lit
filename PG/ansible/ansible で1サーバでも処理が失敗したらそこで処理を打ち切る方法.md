# ansible で1サーバでも処理が失敗したらそこで処理を打ち切る方法<br/>

ansible ではすべての対象ホストで処理が失敗しない限り次に処理を進める。<br/>
再実行を考えるとこの動作が嫌な場合がある。もちろん冪等性が完全にあれば、単純な再実行でも問題は無いはずだ。しかし、冪等性がない処理や、完全に横並びで処理を進めたい場合には1サーバが失敗しただけでも処理を止めたい場合もある。<br/>
特に変更処理前の「事前検証」を実施している場合はそうありたい(事前検証をクリアした環境に対して何らかのインストール処理を継続するとか)。<br/>
<br/>
そんな場合は max_fail_percentage を 0 にすればよい(0%のサーバの失敗を許容する＝失敗を一切許容しない)。<br/>
<br/>
check.yml を以下のとおりに作成する。<br/>
<br/>
<pre>
- hosts: '{{hosts}}'
  gather_facts: false
  max_fail_percentage: 0
  tasks:
    - name: check reachability
      ping:

    - name: check reachability
      ping:
</pre>
<br/>
garnet-vm10, garnet-vm11 のみが起動しており、garnet-vm12 が起動していない状態で実行すると、最初の ping 失敗で全体が停止する。<br/>
<pre>
# ansible-playbook check.yml -e hosts=all

PLAY [all] ******************************************************************** 

TASK: [check reachability] **************************************************** 
fatal: [garnet-vm12] => SSH encountered an unknown error during the connection.
We recommend you re-run the command using -vvvv, which will enable SSH debugging output to help diagnose the issue
ok: [garnet-vm11]
ok: [garnet-vm10]

FATAL: all hosts have already failed -- aborting

PLAY RECAP ******************************************************************** 
           to retry, use: --limit @/root/check.retry

garnet-vm10                : ok=1    changed=0    unreachable=0    failed=0   
garnet-vm11                : ok=1    changed=0    unreachable=0    failed=0   
garnet-vm12                : ok=0    changed=0    unreachable=1    failed=0   
</pre>
