```
OUTDIR=/aaa/bbb/ccc
cp --parents -pr xxx/yyy/zzz ${OUTDIR}
```

```
カレントディレクトリ
/home/user
  +-- xxx/
      +-- yyy/
          -- y1.txt
          -- y2.txt
          +-- zzz/
              -- z1.txt
              -- z2.txt
```
```
Dstディレクトリ
/aaa/bbb/ccc
```

### ↓コピー

```
/aaa/bbb/ccc
  +-- xxx/
      +-- yyy/
          -- y1.txt
          -- y2.txt
          +-- zzz/
              -- z1.txt
              -- z2.txt
```
