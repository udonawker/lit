[各言語で指定したディレクトリ内のファイル一覧を取得してみる](https://hhelibex.hatenablog.jp/entry/2017/12/10/163343)<br/>

## 要件は以下の通り。<br/>

- コマンドライン引数には、ディレクトリ名が1つ指定される
- 指定されたディレクトリから直下にあるファイルのファイル名一覧を読む
  - ファイルの個数は高々256個とする
  - ディレクトリか通常ファイルしか存在しない
  - ディレクトリは除外する
  - いわゆる隠しファイル("."で始まるファイル名のファイル)は含める
- 読み込んだファイル名一覧をファイル名の辞書順でソートする
- ファイル名一覧を、指定されたディレクトリの下の「result/out.txt」に書き込む
  - 「result」ディレクトリはあらかじめ用意してあるので、存在チェック等は不要

## 環境
- CentOS 7
  - Java (openjdk version "1.8.0_151")
  - C (gcc (GCC) 4.8.5)
    - -std=gnu11でコンパイル
  - C++ (g++ (GCC) 4.8.5)
    - -std=gnu++1yでコンパイル
  - PHP (PHP 5.4.16 (cli))
  - Python 2 (Python 2.7.5)
  - Python 3 (Python 3.6.3)
    - ソースからビルドしたもの
  - Ruby (ruby 2.0.0p648)
  - Perl (v5.16.3)
  - Go (go version go1.8.3 linux/amd64)
  - bash (4.2.46(1)-release)

### Java
<pre>
import java.io.File;
import java.io.FileFilter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("Usage: java Main dirname");
            System.exit(1);
            return;
        }

        File dir = new File(args[0]);
        if (!dir.isDirectory()) {
            System.err.println(dir + ": No such directory");
            System.exit(1);
            return;
        }

        // ディレクトリからファイルの一覧を読み込み
        File[] files = dir.listFiles(new FileFilter() {
            public boolean accept(File file) {
                return file.isFile();
            }
        });

        // ファイル名の辞書順でソート
        List<String> filenames = new ArrayList<>();
        for (File file : files) {
            filenames.add(file.getName());
        }
        Collections.sort(filenames);

        // ファイル名一覧の出力
        try (PrintWriter out = new PrintWriter(new FileWriter(new File(dir + "/result/out.txt")))) {
            for (String filename : filenames) {
                out.println(filename);
            }
            out.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
</pre>

### C
<pre>
#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/stat.h>
#include <string.h>
#include <limits.h>

int isdir(const char* path) {
    struct stat st;
    if (stat(path, &st)) {
        return 0;
    }
    return ((st.st_mode & S_IFMT) == S_IFDIR);
}

int isfile(const char* path) {
    struct stat st;
    if (stat(path, &st)) {
        return 0;
    }
    return ((st.st_mode & S_IFMT) != S_IFDIR);
}

int cmp(const void* p1, const void* p2) {
    const char* str1 = (const char*)p1;
    const char* str2 = (const char*)p2;
    return strcmp(str1, str2);
}

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s dirname\n", argv[0]);
        exit(1);
    }

    char dir[PATH_MAX];
    strcpy(dir, argv[1]);
    if (!isdir(dir)) {
        fprintf(stderr, "%s: No such directory\n", dir);
        exit(1);
    }

    // ディレクトリからファイルの一覧を読み込み
    DIR* dp = opendir(dir);
    if (!dp) {
        perror(dir);
        exit(1);
    }
    char filenames[256][PATH_MAX];
    int ct = 0;
    struct dirent* entry;
    while ((entry = readdir(dp))) {
        char tmp[PATH_MAX];
        sprintf(tmp, "%s/%s", dir, entry->d_name);
        if (isfile(tmp)) {
            strcpy(filenames[ct], entry->d_name);
            ++ct;
        }
    }
    closedir(dp);

    // ファイル名の辞書順でソート
    qsort(filenames, ct, sizeof(char) * PATH_MAX, cmp);

    // ファイル名一覧の出力
    char outFile[PATH_MAX];
    sprintf(outFile, "%s/result/out.txt", dir);
    FILE* outFp = fopen(outFile, "w");
    if (!outFp) {
        perror(outFile);
        exit(1);
    }
    for (int i = 0; i < ct; ++i) {
        fprintf(outFp, "%s\n", filenames[i]);
    }
    fclose(outFp);

    return 0;
}
</pre>

### C++
<pre>
#include <iostream>
#include <fstream>
#include <vector>
#include <boost/filesystem.hpp>

using namespace std;
using namespace boost::filesystem;

int main(int argc, char** argv) {
    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " dirname" << endl;
        return EXIT_FAILURE;
    }

    path dir(argv[1]);
    if (!exists(dir) || !is_directory(dir)) {
        cerr << dir << ": No such directory" << endl;
        return EXIT_FAILURE;
    }

    // ディレクトリからファイルの一覧を読み込み
    vector<string> filenames;
    try {
        directory_iterator end;
        for (directory_iterator it(dir); it != end; ++it) {
            if (!is_directory(it->path())) {
                filenames.push_back(it->path().filename().string());
            }
        }
    } catch (const filesystem_error& e) {
        cerr << e.what() << endl;
    }

    // ファイル名の辞書順でソート
    sort(filenames.begin(), filenames.end());

    // ファイル名一覧の出力
    string outFile = dir.string() + "/result/out.txt";
    ofstream outFs(outFile, ios::binary);
    if (!outFs) {
        cerr << outFile << ": Cannot open file" << endl;
        exit(1);
    }
    for (string& filename : filenames) {
        outFs << filename << endl;
    }
    outFs.close();

    return EXIT_SUCCESS;
}
</pre>
Boostに頼りました。コンパイルには「-lboost_filesystem -lboost_system」が必要。<br/>

### PHP
<pre>
&lt;?php

if (count($argv) != 2) {
    file_put_contents("php://stderr", "Usage: {$argv[0]} dirname" . PHP_EOL);
    exit(1);
}
$dir = $argv[1];
if (!is_dir($dir)) {
    file_put_contents('php://stderr', "{$dir}: No such directory" . PHP_EOL);
    exit(1);
}

// ディレクトリからファイルの一覧を読み込み
$dp = opendir($dir);
if (!$dp) {
    file_put_contents('php://stderr', "{$dir}: Cannot open directory" . PHP_EOL);
    exit(1);
}
$filenames = array();
while (($f = readdir($dp))) {
    if (is_file("{$dir}/{$f}")) {
        $filenames[] = $f;
    }
}
closedir($dp);

// ファイル名の辞書順でソート
sort($filenames);

// ファイル名一覧の出力
$outFile = "{$dir}/result/out.txt";
$fp = fopen($outFile, 'w');
if (!$fp) {
    file_put_contents('php://stderr', "{$outFile}: Cannot open output file" . PHP_EOL);
    exit(1);
}
foreach ($filenames as $filename) {
    fprintf($fp, "%s\n", $filename);
}
fclose($fp);
</pre>

### Python 2
<pre>
# -*- coding: utf-8 -*-
import sys
import os

if len(sys.argv) != 2:
        sys.stderr.write("Usage: " + sys.argv[0] + " dirname\n");
        exit(1)
dirPath = sys.argv[1];
if not os.path.isdir(dirPath):
        sys.stderr.write(dirPath + ": No such directory\n");
        exit(1)

# ディレクトリからファイルの一覧を読み込み
filenames = []
for f in os.listdir(dirPath):
        if os.path.isfile(dirPath + '/' + f):
                filenames.append(f)

# ファイル名の辞書順でソート
filenames.sort()

# ファイル名一覧の出力
outFile = dirPath + "/result/out.txt"
outFp = os.open(outFile, os.O_WRONLY | os.O_CREAT)
for f in filenames:
        os.write(outFp, f + "\n");
os.close(outFp)
</pre>
Dir.globを使うという手もあるらしいのだが、試したら、隠しファイルを取得するために2回呼び出さないといけないことが分かったので、今回は正攻法で攻めた。<br/>

### Python 3
<pre>
import sys
import os

if len(sys.argv) != 2:
        sys.stderr.write("Usage: " + sys.argv[0] + " dirname\n");
        exit(1)
dirPath = sys.argv[1];
if not os.path.isdir(dirPath):
        sys.stderr.write(dirPath + ": No such directory\n");
        exit(1)

# ディレクトリからファイルの一覧を読み込み
filenames = []
for f in os.listdir(dirPath):
        if os.path.isfile(dirPath + '/' + f):
                filenames.append(f)

# ファイル名の辞書順でソート
filenames.sort()

# ファイル名一覧の出力
outFile = dirPath + "/result/out.txt"
outFp = os.open(outFile, os.O_WRONLY | os.O_CREAT)
for f in filenames:
        os.write(outFp, f.encode('utf-8') + b"\n");
os.close(outFp)
</pre>

### Ruby
<pre>
if ARGV.length != 1
    STDERR.puts('Usage: ' + __FILE__ + ' dirname')
    exit 1
end

dir = ARGV[0]
if !File.directory?(dir)
    STDERR.puts(dir + ': No such directory')
    exit 1
end

# ディレクトリからファイルの一覧を読み込み
filenames = []
Dir.foreach(dir).each do |filename|
    if File.file?(dir + '/' + filename)
        filenames.push(File.basename(filename))
    end
end

# ファイル名の辞書順でソート
filenames.sort!

# ファイル名一覧の出力
outFile = dir + '/result/out.txt'
outFp = File.open(outFile, mode = 'wb')
for filename in filenames
    outFp.puts(filename + "\n")
end
outFp.close()
</pre>

### Perl
<pre>
if (@ARGV != 1) {
    print(STDERR 'Usage: ' . __FILE__ . " dirname\n");
    exit(1);
}
my $dir = $ARGV[0];
if (! -d $dir) {
    print(STDERR $dir . ": No such directory\n");
    exit(1);
}

# ディレクトリからファイルの一覧を読み込み
my $dp;
my $res = opendir($dp, $dir);
if (!$res) {
    print(STDERR $dir . ':' . $! . "\n");
    exit(1);
}
my @filenames = ();
my $ct = 0;
while (my $filename = readdir($dp)) {
    if (-f $dir . '/' . $filename) {
        $filenames[$ct++] = $filename;
    }
}
closedir($dp);

# ファイル名の辞書順でソート
@filenames = sort(@filenames);

# ファイル名一覧の出力
my $outFile = $dir . '/result/out.txt';
my $outFp;
my $res = open($outFp, '>', $outFile);
if (!$res) {
    print(STDERR $outFile . ':' . $! . "\n");
    exit(1);
}
for (my $i = 0; $i < @filenames; ++$i) {
    print($outFp $filenames[$i] . "\n");
}
close($outFp);
</pre>
glob()を使う方法もあるらしいのだが、隠しファイルを取得するために2回呼び出さないといけない感じだったので、今回は正攻法で攻めた。<br/>

### Go
<pre>
package main

import (
    "os"
    "fmt"
    "io/ioutil"
    "sort"
)

func main() {
    if len(os.Args) != 2 {
        fmt.Fprintln(os.Stderr, "Usage: " + os.Args[0] + " dirname")
        os.Exit(1)
    }
    dir := os.Args[1]
    statInfo, _ := os.Stat(dir)
    if !statInfo.IsDir() {
        fmt.Fprintln(os.Stderr, dir + ": No such directory")
        os.Exit(1)
    }

    // ディレクトリからファイルの一覧を読み込み
    files, err := ioutil.ReadDir(dir)
    if err != nil {
        fmt.Fprintln(os.Stderr, err)
        os.Exit(1)
    }
    count := 0
    for _, file := range files {
        if (!file.IsDir()) {
            count += 1
        }
    }
    filenames := make([]string, count)
    i := 0
    for _, file := range files {
        if (!file.IsDir()) {
            filenames[i] = file.Name()
            i += 1
        }
    }

    // ファイル名の辞書順でソート
    sort.Strings(filenames)

    // ファイル名一覧の出力
    outFile := dir + "/result/out.txt"
    outFp, err := os.Create(outFile)
    if err != nil {
        fmt.Fprintln(os.Stderr, err)
        os.Exit(1)
    }
    for _, filename := range filenames {
        fmt.Fprintln(outFp, filename);
    }
}
</pre>

### bash
<pre>
#! /bin/bash

dir=$1
if [ -z "${dir}" ]; then
    echo "Usage: ${0} dirname"
    exit 1
fi
if [ ! -d "${dir}" ]; then
    echo "${dir}: No such directory"
    exit 1
fi

ls -1aF "${dir}" | grep -v '/$' | tr -d / | LANG=C sort > "${dir}/result/out.txt"
</pre>
「LANG=C」しないと、日本語ファイル名のファイルを含む場合にソート順が期待通りにならない。<br/>
