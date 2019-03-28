<pre>
# pcs resource update <リソース名> op start interval=0s on-fail=restart timeout=60s
# pcs resource update <リソース名> op stop interval=0s on-fail=fence timeout=60s

# pcs config show --all
# pcs resource show <リソース名>
</pre>
