### スペースを含まない場合(スベース含んでいると1行でも複数に分割される)
<pre>
LIST="$(ls -1 | grep XX)"; for item in ${LIST[@]}; do echo "${item}"; done
</pre>

### スペースを含む場合
<pre>
LIST=$(ls -1 | grep HXX); for ((i = 0; i < ${#LIST[@]}; i++)); do echo "${LIST[$i]}"; done
</pre>
