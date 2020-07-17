# [C++11 範囲ベース for ループ](http://vivi.dyndns.org/tech/cpp/range-for.html)

## 範囲の値を参照
「範囲ベース for ループ（range-based for loop）」の書き方は「for( 変数宣言 : 範囲)」だ。範囲としては、通常配列・コンテナクラスオブジェクトが指定できる。 <br>
こう書くと、範囲をループし、各要素を変数に自動的に代入してくれる。<br>
例えば、通常配列の要素を全て表示するコードは以下のように書ける。<br>
<pre>
    int ar[] = {1, 2, 3, 4, 5, 6, 7};
    for(int x : ar) {
        std::cout << x << "\n";     // 1 2 3・・・7 と順に表示される
    }
</pre>
上記のコードは、下記のコードと同じ意味だ。すごく楽になったのがお分かりだろうか？<br>
<pre>
    int ar[] = {1, 2, 3, 4, 5, 6, 7};
    for(int i = 0; i < std::end(ar) - std::begin(ar); ++i) {
        std::cout << ar[i] << "\n";
    }
</pre>
下記のようにコンテナクラスも範囲指定として使える。<br>
<pre>
    std::vector<int> v{1, 2, 3, 4, 5, 6, 7};
    for(int x : v) {
        std::cout << x << "\n";
    }
</pre>
下記のように、添字でループしたり、その次のようにイテレータで回すよりも、上記はとても書きやすく、分かりやすい。<br>
<pre>
    std::vector<int> v{1, 2, 3, 4, 5, 6, 7};
    for(int i = 0; i < (int)v.size(); ++i) {
        std::cout << ar[i] << "\n";
    }
</pre>
<pre>
    std::vector<int> v{1, 2, 3, 4, 5, 6, 7};
    for(auto itr = v.begin(); itr != v.end(); ++itr) {
        std::cout << *itr << "\n";
    }
</pre>
なお、範囲forループで使用する変数の型は auto で書くと便利だぞ。<br>
<pre>
    std::vector<int> v{1, 2, 3, 4, 5, 6, 7};
    for(auto x : v) {
        std::cout << x << "\n";
    }
</pre>
念の為に書いておくと、std::map の場合、要素は キーと値のペア（std::pair）なので、 x.first でキーを、x.second で値を参照できる。<br>
<pre>
    std::map<std::string, int> mp;       // mp を生成
    mp にキー、値のペアを複数設定;
    for(auto x : mp) {
        std::cout << x.first << " " << x.second << "\n";
    }
</pre>

## 範囲の値を書き換え
ここまでの例は、範囲の値を参照するだけだったが、for変数宣言時に & を指定しておくと、参照変数となり、範囲の要素の値を書き換えることが出来る。<br>
<pre>
    int ar[] = {3, 1, 4, 1, 5, 9};
    for(int &x : ar) {
        if( x == 1 )            // 値が１だったら
            x = 123;           // 123 に書き換える
    }
    // ar[] の内容は {3, 123, 4, 123, 5, 9} に変わっている
</pre>
上記は、配列の全ての要素を調べ、要素の値が1だったら、値を123に書き換える例だ。<br>

## break, continue
普通の for ループと同じで、break文、continue 文も使えるぞ。<br>
<pre>
    int ar[] = {3, 1, 4, 1, 5, 9};
    for(auto x : ar) {
        if( x == 4 )
            break;           // 4を見つけたらループ終了
    }
</pre>
もちろん、条件が成立したら途中で return してもOKだぞ。<br>
