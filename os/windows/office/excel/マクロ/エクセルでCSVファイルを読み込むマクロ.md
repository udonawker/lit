
### エクセルでCSVファイルを読み込むマクロを教えてください。

### ボタンを作成し、そのボタンを押すとCSVファイル選択してCSVを読み込みたいです。

### ChatGPT:
```
もちろんです！Excelで「ボタンを押すとCSVファイルを選択して読み込むマクロ」を作る手順とサンプルコードをお渡しします。今回は 1行目は固定で手入力のヘッダーを残す ことを前提にしています。
```

```
1. 開発タブを表示

Excelで「ファイル」→「オプション」→「リボンのカスタマイズ」

「開発」タブにチェックを入れて「OK」

2. ボタンを作成

「開発」タブ → 「挿入」 → 「フォームコントロール」の「ボタン」

ワークシート上に配置 → マクロを割り当てる画面で後ほど作るマクロ名を入力（例：ImportCSV）

3. マクロコード例
Sub ImportCSV()
    Dim csvFile As String
    Dim ws As Worksheet
    Dim lastRow As Long
    
    ' CSV読み込み先シートを設定（例: "CSV読込"）
    Set ws = ThisWorkbook.Sheets("CSV読込")
    
    ' ファイル選択ダイアログ
    csvFile = Application.GetOpenFilename("CSVファイル (*.csv), *.csv", , "CSVファイルを選択")
    
    ' キャンセル時は終了
    If csvFile = "False" Then Exit Sub
    
    ' シートの2行目以降をクリア（ヘッダーは残す）
    ws.Rows("2:" & ws.Rows.Count).ClearContents
    
    ' CSVを2行目からインポート
    With ws.QueryTables.Add(Connection:="TEXT;" & csvFile, Destination:=ws.Range("A2"))
        .TextFileParseType = xlDelimited
        .TextFileCommaDelimiter = True
        .TextFilePlatform = 65001 ' UTF-8対応
        .AdjustColumnWidth = True
        .Refresh BackgroundQuery:=False
        .Delete ' QueryTableは削除してデータだけ残す
    End With
    
    ' フィルタを設定
    ws.Rows(1).AutoFilter
    
    MsgBox "CSVの読み込みが完了しました！", vbInformation
End Sub

4. ポイント

1行目は固定ヘッダーとして残ります。

CSVは 2行目以降 に読み込まれます。

自動でオートフィルタを設定。

UTF-8のCSVにも対応しています。

ファイル選択ダイアログが出るので、任意のCSVを選択可能。

💡補足
もしCSVによっては文字化けする場合は .TextFilePlatform を 932 に変更して Shift-JIS として読み込むこともできます。
```

### 希望であれば、このマクロに 複数CSVを一度に読み込む機能 や 読み込み前に既存データをバックアップする機能 も追加できます。
