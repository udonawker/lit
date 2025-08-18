## [Windowsでのパス操作を助けるコマンド](https://ascii.jp/elem/000/004/312/4312914/)

```
パスのテスト
　前回解説したJoin-Pathのようなコマンドは、任意のパスを作り出すことが可能で、その中には存在しないファイルもある。これから書き込むファイルであれば、存在しなくて当然だが、存在している場合、上書きにより情報を失う恐れがある。

　「Test-Path」コマンド（https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.management/test-path?view=powershell-7.5）は、ファイルパスに対して、その有効性や存在の有無、作成日時範囲を調べることができる。

　このコマンドを使うことで、ファイルの存在を調べられるため、ファイル作成前に、同名のファイルが同じディレクトリに存在しているかどうかを判断できる。たとえば、test0.txt、test1.txt……test9.txtといったファイル名のうち、実際に存在するファイルを調べるなら

(0..9) | Foreach-Object {Test-Path ".\test$_.txt" }

として、Test-Pathを使うことができる。もっとも、これだとTrueとFalseしか表示されないので、ファイル名などを表示させるなら、

(0..9) | % {$cp="test$_.txt"; Write-Output "$cp`t$(Test-Path $cp)" }

などとする。

　存在しないファイルの扱いには、このように直接パスを調べる方法もあれば、存在しているファイルのリストを作る方法もある。Resolve-Pathを使えば、特定のディレクトリに存在するファイルの一覧を得られる。ここでは、Split-Pathを使ってファイル名のみを出力させている。

Resolve-Path ".\test?.txt" | Split-Path -Leaf

　存在するファイルの一覧が得られるのであれば、これを使って、ファイルが存在するかどうかを調べることもできる。変数$eflistに上記のコマンドの出力を入れておき、包含比較演算子「-in」を使ってファイル名が、Resolve-Pathで作ったリスト（$eflist）に含まれているかどうかを調べる。

$eflist=Resolve-Path '.\test?.txt' | Split-Path -Leaf
(0..9) | % {$cp="test$_.txt"; Write-Output "$cp`t$($cp -in $eflist)"}

　「-in」演算子は、「アイテム -in 配列」の形式で利用し、アイテムが配列に踏まれているかどうかをTrue、Falseで返す。

　なお、ファイルの非存在を調べる用途の1つにテンポラリファイルの作成がある。PowerShellには、専用のコマンド「New-TemporaryFile」（https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.utility/new-temporaryfile?view=powershell-7.5）があるので、これを使うのが簡単だ。

カレントディレクトリを扱うコマンド
　一般にパスは、長くなる傾向があるため、ファイルパスに関しては、「作業ディレクトリ」や「カレントディレクトリ」と呼ばれる仕組みが導入された。なお、この作業ディレクトリの概念は、コマンドラインでは正しく利用されている。しかし、GUIのアプリケーションに関しては、カレントディレクトリを使うかどうかはアプリ開発者次第で、必ずしも作業ディレクトリを理解するとはかぎらない。

　PowerShellでは、ファイルシステム以外にレジストリなど、PSプロバイダー、PSドライブを使ったパス表現を使う。このため、「現在の作業場所（current working location）」（以下、CWL）と、呼ばれる概念を持つ。これは、ファイルシステムに対しては、カレントディレクトリとなる。

　CWLを使ったパスの表記を「相対パス」と呼び、そうでないものを「絶対パス」（完全修飾パス）という。

　CWLはピリオド「.」で表記でき、その親コンテナをピリオド2つ「..」で表記することができる。また、パス名の先頭に「パス区切り文字」もピリオドもないものも、相対パスとなる。このあたりに関しては、冒頭にあげたパスに関する過去記事を参照してほしい。

　コマンドラインでは、CWLを頻繁に切り替えたり、特定のCWL間を行き来することがある。このような場合には、スタックを使ったCWLコマンドを使う。

CWL
　現在のCWLを得るのが「Get-Location」（https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.management/get-location?view=powershell-7.5、エイリアスはpwdまたはgl）で、CWLを設定するのが「Set-Location」（https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.management/set-location?view=powershell-7.5、cdまたはchdir、sl）だ。

　このほかに、CWL間移動のためのコマンドがある。現在のCWLをスタックに保存して、新しいCWLに移動するのが「Push-Location」（https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.management/push-location?view=powershell-7.5、pushd）で、スタックから保存されたCWLを取り出して、そこに移動するのが「Pop-Location」（https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.management/pop-location?view=powershell-7.5、popd）だ。

　スタックに保存されているCWLを見るには、「Get-Location -Stack」コマンドを使う。

　また、Set-Locationコマンドでは「+」「-」を使ったCWLの履歴アクセスが可能。「cd -」（cdは、Set-Locationのエイリアス）でリストの1つ前にあるCWLに移動する。「cd +」で履歴リストの次のCWLに移動する。+／-でリストの範囲を超えてアクセスするとエラーとなる。この履歴リストは、最大20個までのCWLを保持しているが、履歴リストを表示する方法は現状ない。

　コマンドラインでは、2つのディレクトリ間を行ったり来たりすることが多く、Set-LocationコマンドやPush／Pop-Locationコマンドで効率的な移動が可能。CWL、特にファイルシステムのカレントディレクトリの概念に慣れて、パスの補完機能を使うと、パス指定もそれほど苦にならなくなる。
```
