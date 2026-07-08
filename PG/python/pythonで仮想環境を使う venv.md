## 20260708 [pip installでerror: externally-managed-environmentの意味と解決方法](https://zenn.dev/kail/articles/ef502d950e8268)

### 1. 仮想環境を使う（推奨）
下記のコマンド引数においてmyenvは自分が仮想環境を作りたいディレクトリを指定してください。（例：~/.python-local-env）<br>

```
python3 -m venv myenv 
source myenv/bin/activate
pip install パッケージ名
```

## 20260708 [venvで手軽にPythonの仮想環境を構築しよう](https://qiita.com/shun_sakamoto/items/7944d0ac4d30edf91fde)
仮想環境のアクティベート<br>
```
. [仮想環境名]/bin/activate
```
仮想環境のディアクティベート<br>
```
deactivate
```
