1. [enhancd git](https://github.com/b4b4r07/enhancd)からenhancd-master.zipをダウンロード
2. \1. のzipを任意の場所に展開
3. .bashrc等に以下を追加
<pre>
ENHANCD_COMMAND=ecd; export ENHANCD_COMMAND
ENHANCD_HYPHEN_ARG="-ls"
ENHANCD_DOT_ARG="-up"

# enhancd init
if [ -f <path_to_enhancd>/enhancd-master/init.sh ]; then
    source <path_to_enhancd>/enhancd-master/init.sh
fi
</pre>
