1. python仮想環境用ディレクトリ作成
```
$ mkdir python_vp
```

2. 仮想環境作成(1回)
```
$ python -m venv python_vp
```

3. 仮想環境アクティベート
```
$ . python_vp/bin/activate
```

4. canライブラリインストール(1回)
```
$ pip install python-can
```

5. blf asc 変換
```
$ python -m can.logconvert [input.blf] [output.asc]
```
