引用<br/>
[C++におけるrewindのお作法](https://sleepy-yoshi.hatenablog.com/entry/20120508/p1 "C++におけるrewindのお作法")<br/>

ひさびさにTIPSぽい記事を書いてみる．C++のstd::ifstreamを読み進んだ後に先頭に戻りたい場合はこんな感じでseekg()を使えばよさそうということを知る．<br/>
```
std::ifstream fin;
fin.seekg(0, std::ios::beg);
```

ファイルの行数を調べてから各行に対する処理をしたかったので，さっそくこんなコードを書いてハマった．<br/>

```  std::ifstream fin("hoge.dat");
  std::string line;
  int count = 0;
  while (fin && getline(fin, line)) {
    count++;
  }

  // (A)
  fin.seekg(0, std::ios::beg);

  // Write # instance
  fout.write( (char *)&count, sizeof( int ) );

  while (fin && getline(fin, line)) {
    // (B) 各行に対する処理
  }
  ```
  
  どうやら(B)のロジックが実行されないみたい．<br/>
  なんでだろうと思って調べてみたら，streamオブジェクトは入出力状態というものを持っていて，ファイルの最後に達するとeofフラグ (eofbit) というものが立つらしい (他にもgoodbit, failbit, badbitがあるらしい)．<br/>
  どうやらエラー状態 (eofbit, failbit, badbit?) が立っている状態ではseekgが実行されない模様．<br/>
  今回はgetline()によってファイル最後まで読み込まれてeofフラグとfailフラグが立っている模様 ((A)の位置に下記のようなコードを挿入して確認．)<br/>
  
  ```
  if (fin.bad()) std::cout << "bad" << std::endl;
  if (fin.eof()) std::cout << "eof" << std::endl;
  if (fin.fail()) std::cout << "fail" << std::endl;
  if (fin.good()) std::cout << "good" << std::endl;
  exit(1);
  ```
  
  というわけでこれらのフラグを明示的にリセットしてやる必要がある．以下の一行を(A)の位置に挿入する．<br/>
  これでOK．<br/>
  
  
  
  
