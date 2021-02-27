## [watchでbashのfunctionを定期実行させる](https://orebibou.com/ja/home/202001/20200106_001/)

最近は定型的な作業はfunctionを事前に作っておいてそれを使うようにしているのだけど、たまにwatchコマンドとかで実行させたいときに引っかかることがある。<br>
悲しいことだけど、watchコマンドなどではfunctionやenvは読み込んでくれない(PythonとかからSubprocessなどで呼び出す場合でも同様だろう)。 なので、以下のように無理やり実行する方法を使っている。<br>

```
watch "bash -c 'source ~/.bashrc 2>/dev/null; function ...'"
```
