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

- std::make_tuple() 引数リストから自動で Tuple 型を構築する
- std::tie() 複数個の変数を Tuple にまとめる
- std::tuple<int, CMyClass, double> tupleValue;
- size_t count = std::tuple_size<std::tuple<int, double>>::value;
- size_t count = std::tuple_size<decltype(tupleValue)>::value;
- int value1 = std::get<0>(tupleValue);
