[Bash Shell Scripting - return key/Enter key](https://stackoverflow.com/questions/2612274/bash-shell-scripting-return-key-enter-key)<br/>

-> 参考 peco_find_dir.sh<br/>
<pre>
IFS= read -r -n1 -s char;
</pre>


<pre>
IFS=''
echo -e "Press [ENTER] to start Configuration..."
for (( i=10; i>0; i--)); do

printf "\rStarting in $i seconds..."
read -s -N 1 -t 1 key

if [ "$key" = $'\e' ]; then
        echo -e "\n [ESC] Pressed"
        break
elif [ "$key" == $'\x0a' ] ;then
        echo -e "\n [Enter] Pressed"
        break
fi

done
</pre>
