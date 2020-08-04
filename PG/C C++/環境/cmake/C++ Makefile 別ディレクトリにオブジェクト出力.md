# [C++ Makefile 別ディレクトリにオブジェクト出力](https://qiita.com/maaato414/items/89566fc7addc82540e4f)

### フォルダ構成

<pre>
example
|-- bin
|   `-- example    <- (TARGET) 実行ファイル
|-- include
|   `-- main.h
`-- source
    |-- main.cpp
    |-- makefile
    `-- obj        <- (OBJDIR) 中間ファイル生成先ディレクトリ
        |-- main.d <- (DEPENDS) 依存関係ファイル
        `-- main.o <- (OBJECTS) オブジェクトファイル
</pre>

### Makefile

<pre>
COMPILER = g++
CFLAGS   = -g -Wall -O2
LDFLAGS  =
LIBS     =
INCLUDE  = -I../include
TARGET   = ../bin/example
OBJDIR   = ./obj
SOURCES  = $(wildcard *.cpp)
OBJECTS  = $(addprefix $(OBJDIR)/, $(SOURCES:.cpp=.o))

 $(TARGET): $(OBJECTS) $(LIBS)
    $(COMPILER) -o $@ $^ $(LDFLAGS)

$(OBJDIR)/%.o: %.cpp
    @[ -d $(OBJDIR) ]
    $(COMPILER) $(CFLAGS) $(INCLUDE) -o $@ -c $<

all: clean $(TARGET)

clean:
    rm -f $(OBJECTS) $(TARGET)
</pre>

### ポイント

> (OBJDIR)/@[−d(OBJDIR)/@[−d(OBJDIR) ]<br>
> (COMPILER)(COMPILER)(CFLAGS) (INCLUDE)−o(INCLUDE)−o@ -c $<<br>

1行目 .cpp -> obj/.o に変換して出力するというサフィックスルール<br>
2行目 obj/以下に出力するファイルパス(ファイル名？)を@に設定<br>
3行目 コンパイル<br>
