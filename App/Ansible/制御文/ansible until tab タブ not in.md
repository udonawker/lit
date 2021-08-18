```
---
- name: setfact1
  set_fact:
    test_var1: 'test	test'
# test_var1は'test[TAB]test'

- name: setfact2
  set_fact:
    test_var2: 'test\ttest'

- name: Check test
  command: cat /tmp/test.txt
  register: test_result
  until: test_var | string not in test_result.stdout      # ① stdoutにtest_var1が存在しなければuntil終了
#  until: test_var not in test_result.stdout               # ② stdoutにtest_var1が存在しなければuntil終了
#  until: test_var | string in test_result.stdout          # ③ stdoutにtest_var1が存在すればuntil終了
#  until: test_var in test_result.stdout                   # ④ stdoutにtest_var1が存在すればuntil終了
#  until: test_result.stdout.find('{{ test_var2 }}') != -1 # ⑤ stdoutにtest_var2が存在すればuntil終了
  retries: 10
  delay: 5
```

### 変数内にTABを含む場合の比較や検出
findを使う場合は'\t'でも実際のTABでもどちらでもよい<br>
jinja2の比較、検出の場合は'\t'ではなく実際のTABでないとひっかからない<br>
