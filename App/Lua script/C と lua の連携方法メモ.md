## [C と lua の連携方法メモ](https://qiita.com/miuk/items/82e5566ea01313a8b1af)

## 初期化
```
lua_State* l = luaL_newstate(); // lua context 取得
luaL_openlibs(l);               // 基本的ライブラリ読み込み
```

## C から lua script の読み込みと実行
```
lua_State* l = luaL_newstate(); // lua context 取得
luaL_openlibs(l);               // 基本的ライブラリ読み込み

// 文字列を lua script として実行
luaL_dostring(l, "print('hello lua script!!')");

// lua script file 読み込み
if (luaL_loadfile(l, fname)) {
  fprintf(stderr, "cannot open %s\n", fname);
  return;
}
if (lua_pcall(l
              , 0     // 引き数の数
              , 0     // 戻り値の数
              , 0)) { // error message handler の stack index
  fprintf(stderr, "cannot exec %s\n", fname);
  return;
}
```

## C から lua の関数呼び出し
下記の lua 関数を C から呼び出す.<br>
```
function func(arg1, arg2)
  print(arg1)
  print(arg2)
  return arg1+1, arg2+2
end
```

上記を呼び出す C のコード.<br>
```
lua_State* l = luaL_newstate();
luaL_openlibs(l);
luaL_loadfile(l, "func.lua");
lua_pcall(l, 0, 0, 0); // script を実行しておかないと関数を呼び出せない
lua_getglobal(l, "func");   // 呼び出す関数
lua_pushnumber(l, 4);   // 第一引数
lua_pushnumber(l, 5);   // 第ニ引数
if (lua_pcall(l, 2, 2, 0)) {    // 引数 2 個, 戻り値 2 個
  fprintf(stderr, "cannot exec add. %s\n", lua_tostring(l, -1));
  return;
}
if (lua_isnumber(l, -1)) {
  int ret = lua_tointeger(l, -1); // 戻り値その 1
  printf("ret=%d\n", ret);
}
lua_pop(l, 1);      // 戻り値を pop
if (lua_isnumber(l, -1)) {
  int ret = lua_tointeger(l, -1); // 戻り値その 2
  printf("ret=%d\n", ret);
}
lua_pop(l, 1);      // 戻り値を pop
```

## lua から C の関数呼び出し
下記のように lua から C の関数 `c_func()` を呼び出す.<br>
```
arg1, arg2 = 3, 4
ret1, ret2 = c_func(arg1, arg2)
```

上記から呼び出される C のコード.<br>
```
// lua から呼ばれる関数
static int
c_func(lua_State* l)
{
  int arg1 = luaL_checkint(l, -2);  // 第一引数取得
  int arg2 = luaL_checkint(l, -1);  // 第二引数取得
  // pop は lua library がやってくれるので不要
  int ret1 = arg1 + 1;
  int ret2 = arg2 + 2;
  lua_pushnumber(l, ret1);  // 戻り値 1 を push
  lua_pushnumber(l, ret2);  // 戻り値 2 を push
  return 2;         // 戻り値の数を返す
}

// lua script を実行するコード
int main(int ac, char* av[])
{
  lua_State* l = luaL_newstate();
  luaL_openlibs(l);
  luaL_loadfile(l, "func.lua");
  lua_register(l, "c_func", c_func); // lua に関数を登録
  lua_pcall(l, 0, 0, 0); // script 実行
  lua_close(l);
}
```

## C から lua へ table を渡す
C から下記 lua 関数 pass_table() を呼び出す.<br>
また、この関数から table を戻り値として C に返す.<br>
```
function pass_table(t)
  for key, val in pairs(t) do
    print(key, val)
  end
  return t
end
```

lua script に table を引き数として渡し, 戻り値として table を受け取る.<br>
```
lua_State* l = luaL_newstate();
luaL_openlibs(l);
luaL_loadfile(l, "func.lua");
lua_pcall(l, 0, 0, 0); // script を実行しておかないと関数を呼び出せない
lua_getglobal(l, "pass_table"); // 呼び出す関数
lua_newtable(l); // table を新規作成し, stack に積む
lua_pushstring(l, "key1");
lua_pushstring(l, "val1");
lua_settable(l, -3); // stack に積んだ table に key, value を設定
lua_pushstring(l, "key2");
lua_pushstring(l, "val2");
lua_settable(l, -3); // stack に積んだ table に key, value を設定
lua_pushstring(l, "key3");
lua_pushstring(l, "val3");
lua_settable(l, -3); // stack に積んだ table に key, value を設定
if (lua_pcall(l, 1, 1, 0)) {    // 引数 1 個, 戻り値 1 個
  fprintf(stderr, "cannot exec add. %s\n", lua_tostring(l, -1));
  return;
}
show_table(l);      // 戻ってきた table の内容表示
lua_pop(l, 1);      // 戻り値を pop
```

## stack に積まれている table へのアクセス
```
// stack に積まれている table の内容にひと通りアクセス
void show_table(lua_State* l)
{
  lua_pushnil(l);
  while (lua_next(l, -2)) {
    switch (lua_type(l, -2)) {  // key を表示
    case LUA_TNUMBER :
      printf("key=%td, ", lua_tointeger(l, -2));
      break;
    case LUA_TSTRING :
      printf("key=%s, ", lua_tostring(l, -2));
      break;
    }
    switch (lua_type(l, -1)) {  // value を表示
    case LUA_TNUMBER :
      printf("value=%td\n", lua_tointeger(l, -1));
      break;
    case LUA_TSTRING :
      printf("value=%s\n", lua_tostring(l, -1));
      break;
    case LUA_TBOOLEAN :
      printf("value=%d\n", lua_toboolean(l, -1));
      break;
    default :
      printf("value=%s\n", lua_typename(l, lua_type(l, -1)));
    }
    lua_pop(l, 1);      // 値を取り除く
  }
}

// 特定 key へのアクセス
void show_table_item(lua_State* l, const char* key)
{
  lua_pushstring(l, key);   // key 値を積む
  lua_rawget(l, 1);     // table のある stack index は 1 番目
  if (lua_isstring(l, -1)) {
    const char* val = lua_tostring(l, -1);
    printf("key=%s, value=%s\n", key, val);
  }
}
```

## lua から C へ table を渡す
C の関数 `c_func()` に引き数として table を渡し, 戻り値として table を受け取る.<br>
```
t = {}
t["key1"] = "val1"
t["key2"] = "val2"
t["key3"] = "val3"
rt = c_func(t)
for key, val in pair(rt) do
  print(key, val)
end
```

```
// lua から呼ばれる関数
static int
c_func(lua_State* l)
{
  show_table(l);      // 引き数として渡された table の内容表示
  // table を戻り値として返す
  lua_newtable(l);
  lua_pushstring(l, "retkey1");
  lua_pushstring(l, "retval1");
  lua_settable(l, -3);
  lua_pushstring(l, "retkey2");
  lua_pushstring(l, "retval2");
  lua_settable(l, -3);
  return 1;          // 戻り値の数
}

// lua script を実行するコード
int main(int ac, char* av[])
{
  lua_State* l = luaL_newstate();
  luaL_openlibs(l);
  luaL_loadfile(l, "func.lua");
  lua_register(l, "c_func", c_func); // lua に関数を登録
  lua_pcall(l, 0, 0, 0); // script 実行
  lua_close(l);
}
```

## 関数群をモジュールとしてまとめる
lua から C の関数を myLib モジュールの関数として呼び出せるようにする.<br>

```
val1 = myLib.add(5, 6)
val2 = myLib.mul(5, 6)
```

```
// lua から呼ばれる関数
static int
l_add(lua_State* l)
{
  int x = luaL_checkint(l, -2); // 第一引数
  int y = luaL_checkint(l, -1); // 第二引数
  // pop は lua library がやってくれるので不要
  int ret = x + y;
  lua_pushnumber(l, ret);   // 戻り値を push
  return 1;         // 戻り値の数を返す
}

static int
l_mul(lua_State* l)
{
  int x = luaL_checkint(l, -2); // 第一引数
  int y = luaL_checkint(l, -1); // 第二引数
  // pop は lua library がやってくれるので不要
  int ret = x * y;
  lua_pushnumber(l, ret);   // 戻り値を push
  return 1;         // 戻り値の数を返す
}

// モジュールを登録する関数
static int luaopen_myLib(lua_State* l)
{
  static const struct luaL_Reg myLib[] = {
    {"add", l_add},
    {"mul", l_mul},
    {NULL, NULL}
  };
  // モジュールを登録. lua v5.2, 5.1 では方法が違う
#if LUA_VERSION_NUM >= 502
  luaL_newlib(l, myMathLib);
#else
  luaL_register(l, "myMath", myMathLib);
#endif
  return 1;
}

int main(int ac, char* av[])
{
  lua_State* l = luaL_newstate();
  luaL_openlibs(l);
  // myLib = require('myLib') と同等
  luaL_requiref(l, "myLib", luaopen_myLib, 1);
  luaL_loadfile(l, fname);
  if (lua_pcall(l, 0, 0, 0)) {
    fprintf(stderr, "cannot exec %s\n", fname);
    fprintf(stderr, "cannot exec add. %s\n", lua_tostring(l, -1));
    return;
  }
  lua_close(l);
}
```

## C から lua の coroutine を制御する
下記, C の関数 c_func() の呼び出しにより実行が中断され,<br>
C 言語側で lua_resume() することにより中断箇所から再開されるようにする.<br>
再開時に c_func() から戻り値付きで制御が戻るようにする.<br>

```
arg1 = "arg1"
ret1 = c_func(arg1)
print("ret1=" .. ret1)
arg2 = "arg2"
ret2= c_func(arg2)
print("ret2=" .. ret2)
arg3 = "arg3"
ret3= c_func(arg3)
print("ret3=" .. ret3)
```

```
// 呼び出されると coroutine を中断する
static int
l_func(lua_State* l)
{
  const char* arg = luaL_checkstring(l, -1);
  printf("l_call, arg=%s\n", arg);
  return lua_yield(l, 0);
}

int main(int ac, char* av[])
{
  lua_State* l = luaL_newstate();
  luaL_openlibs(l);
  lua_register(l, "c_func", c_func); // lua に関数を登録
  lua_State* co = lua_newthread(l); // co-routine 用の thread
  luaL_loadfile(co, "func.lua");
  lua_resume(co, NULL, 0);  // 実行開始
  for (;;) {
    sleep(1);
    lua_pushstring(co, "reval"); // 戻り値を積む
    int ret = lua_resume(co, NULL, 1); // 実行再開
    printf("lua_resume returns %d\n", ret);
    if (ret == LUA_OK)      // co-routine 終了
      break;
  }
  // co-routine's thread の片付けは GC に任せる以外方法なし
  lua_close(l);
}
```


