```
$ find . -type f -name "*.h" | xargs grep -E "#define[[:space:]]*XXX"
```
```
$ xargs grep -E "^#define[[:space:]]*XXX" filename
```
