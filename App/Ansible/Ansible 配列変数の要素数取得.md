## [Ansibleで配列の要素数を数える方法は？](https://www.it-swarm-ja.com/ja/array/ansible%E3%81%A7%E9%85%8D%E5%88%97%E3%81%AE%E8%A6%81%E7%B4%A0%E6%95%B0%E3%82%92%E6%95%B0%E3%81%88%E3%82%8B%E6%96%B9%E6%B3%95%E3%81%AF%EF%BC%9F/944568068/)

```
foo: [value0, value1, value2, value3]

Number_of_elements: "{{ foo | length }}"
```
