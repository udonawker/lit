## [ターゲットホストのIPアドレスの参照とデフォルトゲートウェイの設定についてのメモ](https://zaki-hmkc.hatenablog.com/entry/2021/01/08/094833)

* playbook
* ターゲットホストのOS設定
    * アドレス設定
    * ens192のみgateway設定
    * ens226のみgateway設定
    * gateway設定無し
    * 両方にgateway設定
* インタフェースを指定して参照
    * インタフェース名を指定
    * インタフェースリスト名も取得

```
- hosts: gateway-test
  gather_facts: true
  gather_subset:
    - network

  tasks:
  - name: print ansible_host
    debug:
      msg:
        - "{{ ansible_host }}"
        - "{{ inventory_hostname }}"
        - "{{ ansible_facts.default_ipv4 }}"  # <- gather_facts: false だと参照不可
```
