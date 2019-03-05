<pre>
#!/bin/sh

echo '◯◯処理を開始します。Enter キーで継続します。(中断は Ctrl+C)'
read

## …何かの処理…

echo '◯◯処理が完了しました。'
exit 0
#!/bin/sh
</pre>
  
<pre>
echo '◯◯処理を開始しますか? (yes or no) '
read answer
case "$answer" in
yes)
  : OK
  ;;
*)
  echo '中断します。'
  exit 1
  ;;
esac

## …何かの処理…

echo '◯◯処理が完了しました。'
exit 0
</pre>
