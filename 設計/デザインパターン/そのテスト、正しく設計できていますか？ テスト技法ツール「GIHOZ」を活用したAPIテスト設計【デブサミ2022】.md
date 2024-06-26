## [そのテスト、正しく設計できていますか？ テスト技法ツール「GIHOZ」を活用したAPIテスト設計【デブサミ2022】](https://codezine.jp/article/detail/15672)

```
テスト作りの過程を言語化するツールがテスト技法
　朱峰氏は「今はソフトウェアプロダクトを1回作って終わりという時代ではない。プロダクトをどんどん進化、変化させていく時代だ」と指摘し、この状況に対応するために書いたテストの根拠をチーム内で明快に説明、共有できる体制が必要ではないかと参加者に問いかけた。そして、「テストを書いたロジックがきちんと明快になっていれば、プロダクトの仕様が変化したときに、テストをどう変えるべきか論理的に説明できるようになる」と主張した。そうすることで、プロダクトの成長とともに、テストの変更も生産性高く、スピーディーに進めることができるからだ。
　テストを書いた根拠を明確にするとは、つまりテスト作りの過程を言語化するということだ。そして、「それを可能にするツールがテスト技法」だと朱峰氏は言う。たとえば、自分の書いたテストを同僚にレビューしてもらったり、同僚の書いたテストを自分がレビューしたりするときに、「抜け漏れを探せと言われてもよく分からない」という思いをしたことはないだろうか。「こういうときにサポートしてくれるのがテスト技法だ」（朱峰氏）。
　とはいえ、テスト技法にもさまざまなものがある。「すべてマスターした上で、場面に応じて組み合わせて使うのが理想」（朱峰氏）だが、一朝一夕にできることではない。ここで、Web APIのテストに絞って、「これだけで良いとは決して言えないが、始めるならここからやってみよう」という初級者講座が始まる。
　ここで朱峰氏は、Web APIのテストですべきことを「極めて単純に」考えてみようと言い、「HTTPリクエストを送って、その結果何らかの処理が行われ、結果としてHTTPのレスポンスが返ってくる。つまり行って返る。これがWeb APIテストの基本形」と整理して見せた。
　このような「行って返る」というシーンでは、テスト技法の中でも「デシジョンテーブルテスト」をよく使うと紹介する。特に開発者テストでは、Web APIに限らず関数やメソッドなど、インターフェイスを定義して、「入出力」を検証することが多い。つまりデシジョンテーブルテストが開発者テストの最初の一歩になるというわけだ。
　では、デシジョンテーブルテストの「デシジョンテーブル」とはどういうものなのか。対応する日本語訳として「決定表」という言葉があるが、これは「入出力条件をまとめ、仕様を決定する表」ということになる。朱峰氏はデシジョンテーブルについて「テストだけで使うものではない。テストよりも上流工程、仕様を整理するときに役立つものであり、ISOやJISでも規格が定まっているテクニック」と紹介する。そして、デシジョンテーブルを利用することで、「自然言語で書かれた仕様を論理的に整理できる」という。
　ここで朱峰氏は、スーパーの割引率決定のロジックを例に、デシジョンテーブルを作って見せた。まずは、割引率決定の仕様を書き起こしてみると、ある店舗でタイムサービスによる割引を実施している。18時から20時まではイブニングサービスタイム、20時から22まではナイトサービス。サービスタイムの対象商品は、イブニングの場合は10％割引、ナイトになると15％割引。対象商品の割引価格は、ショップの会員、非会員ともに変わらない。ただし会員の場合はサービスタイム以外でも常に5％割引、という具合だ。
 こうして自然言語で書くと、うまく整理できず、なかなか頭に入ってこないものだ。そこで朱峰氏は、文章で書いてある仕様の中から、条件を指定している部分と結果を指定している部分をハイライトして見せた。すると、上図のようになった。
　前出のスーパーの割引率決定のロジックをデシジョンテーブルにすると下図のようになる。左上の文字が並んでいるところが「条件記述部」。ここには起こり得る条件を洗い出して列挙する。「イブニングサービスタイム内」や、「ナイトサービスタイム内」など、割引の条件を列挙している。
右上のYやN、ハイフンが並んでいる部分は「条件指定部」。条件が成り立つところにはイエス、つまり「Y」を書き込み、成り立たないところはノー、つまり「N」を書き込む。そして発生しないところにはハイフンを入れる。
　朱峰氏が作成した表を見ると、条件指定部は7列ある。1列目は「イブニングサービスタイム内」に、「対象商品」を購入する場合なので、2カ所に「Y」が入っている。2列目は「イブニングサービスタイム内」に「会員」が買い物をする場合というわけだ。左下の割引率が並んでいる部分は「動作記述部」。起こり得る結果を列挙している。最後に右下の「動作指定部」。条件指定部で洗い出した条件に対する結果を指定する部分だ。1列目を例に取ると、「イブニングサービスタイム内」に、「対象商品」を購入する場合は「10％割引」という具合だ。
　この表の1列が1つのテストケースとなる。つまり、今回の例ではテストケースは7つあるということだ。自然言語で割引率決定の仕様を書き出してみても、想定できるパターン、つまりテストケースが7つあるとは分からないだろう。デシジョンテーブルは、テストに限らずソースコードを書き出す前の設計にも役立ちそうだ。
無償で使える「GIHOZ」でテストドキュメントの作成・共有が可能に
　朱峰氏はさらに、デシジョンテーブルのメリットとデメリットを挙げた。メリットとしては、上記で分かるように、ロジックが複雑になればなるほど、自然言語で書き出しただけではすぐには理解できない。それが、デシジョンテーブルを作ることで、仕様がきれいに定まるという点だ。さらに、仕様の抜け漏れに気づきやすいというメリットもある。表を作る過程で、「こういう条件もあるな」と思いつくことも多いのだ。
　デメリットは、入力データや条件が増えれば増えるほど、表が肥大化していくという点だ。
　ここで朱峰氏は、ベリサーブが開発して無償で提供しているツール「GIHOZ」に、デシジョンテーブルを作成する機能があると紹介する。GIHOZは、ベリサーブがSaaS形式で提供しているツールであり、デシジョンテーブルに限らず、さまざまなテスト技法に対応したドキュメントの作成を支援してくれるツールだ。メールアドレスでユーザー登録することで無償で利用できる。
　GIHOZでは、テストドキュメントを「リポジトリ」で管理する。リポジトリはプロジェクト単位で作成できる。そして、リポジトリは非公開として自分だけで利用することもできるが、ほかのユーザーを招待してドキュメントを共有することもできる。さらに、「公開」を選べば、世界中に自身のリポジトリを公開できる。GIHOZを紹介した後、朱峰氏はTwitterのようなミニブログのWeb APIを例として、GIHOZを使ってデシジョンテーブルを作成して見せた。
最後に朱峰氏は、テスト技法を利用することで、テストのパターンに対して理屈を付けられるということ、自分の作ったテストの根拠を人と共有できるということ、Web APIのテストでは入りと出のチェックを意識すべきことを説明し、数あるテスト技法の中でもWeb APIのテストではデシジョンケーブルテストが非常に役立つと伝え、講演を締めくくった。
```

![画像1](https://cz-cdn.shoeisha.jp/static/images/article/15672/15672_003.png)<br>

![画像2](https://cz-cdn.shoeisha.jp/static/images/article/15672/15672_004.png)<br>
