[cpprefjp - C++日本語リファレンス](https://cpprefjp.github.io/reference.html)<br/>
<br/>
- T::emplace_back()
- std::distance()
- std::for_each()
- std::this_thread
    - get_id() 現スレッドのスレッド識別子を取得する
    - yield() 処理系に再スケジュールの機会を与える
    - sleep_until() 指定した絶対時刻を過ぎるまで現スレッドをブロックする
    - sleep_for() 指定した相対時間だけ現スレッドをブロックする
- condition_variable
- fill fill_n

<br/>

- tuple
    - std::make_tuple() 引数リストから自動で Tuple 型を構築する
    - std::tie() 複数個の変数を Tuple にまとめる
    - std::tuple<int, CMyClass, double> tupleValue;
    - size_t count = std::tuple_size<std::tuple<int, double>>::value;
    - size_t count = std::tuple_size<decltype(tupleValue)>::value;
    - int value1 = std::get<0>(tupleValue);

- std::copy_if

#### std::advance std::next std::prev
##### std::advance
- 引数を変更します
- 何も返さない
- 入力イテレータ以上で動作します（負の距離が指定されている場合は双方向イテレータ）

##### std::next
- 引数を変更しないままにする
- 指定された量だけ進んだ引数のコピーを返します
- 前方反復子以上で動作します（負の距離が指定されている場合は双方向反復子）

##### std::prev
std::next() はデフォルトで1つずつ進みますが、 std::advance() は距離を必要とします。<br>
そして、戻り値があります：<br>
- std::advance() ：（なし）（渡された反復子は変更されます）
- std::next() ：n番目の後続。
std::next() は_std::advance_と同様に負の数を取ります。その場合、反復子は双方向でなければなりません。 std::prev() は、意図が具体的に後方に移動することである場合により読みやすくなります。<br>
