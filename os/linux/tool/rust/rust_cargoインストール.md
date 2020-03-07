[UbuntuにRustをインストールする](https://qiita.com/yoshiyasu1111/items/0c3d08658560d4b91431)<br/>

## インストール

`curl https://sh.rustup.rs -sSf | sh` を実行するだけで簡単にインストールできます。<br/>
途中でインストールの方法を選択できますがここではデフォルトの1を選択しています。<br/>
rustup.rsは中身はBashスクリプトになっていてrustupやrustc、cargoなどを`$HOME/.cargo/bin`にダウンロードしてくるようです。<br/>
スクリプトの中身は[rustup.rsのGitHub](rustup.rsのGitHub)のrustup-init.shです。

<pre>
~$ curl https://sh.rustup.rs -sSf | sh
info: downloading installer

Welcome to Rust!

This will download and install the official compiler for the Rust programming 
language, and its package manager, Cargo.

It will add the cargo, rustc, rustup and other commands to Cargo's bin 
directory, located at:

  /home/yoshi/.cargo/bin

This path will then be added to your PATH environment variable by modifying the
profile file located at:

  /home/yoshi/.profile

You can uninstall at any time with rustup self uninstall and these changes will
be reverted.

Current installation options:

   default host triple: x86_64-unknown-linux-gnu
     default toolchain: stable
  modify PATH variable: yes

1) Proceed with installation (default)
2) Customize installation
3) Cancel installation
>1 <--ここで1を入力する

info: syncing channel updates for 'stable-x86_64-unknown-linux-gnu'
info: latest update on 2019-04-11, rust version 1.34.0 (91856ed52 2019-04-10)
info: downloading component 'rustc'
 85.3 MiB /  85.3 MiB (100 %)  15.9 MiB/s ETA:   0 s                
info: downloading component 'rust-std'
 56.2 MiB /  56.2 MiB (100 %)  16.3 MiB/s ETA:   0 s                
info: downloading component 'cargo'
info: downloading component 'rust-docs'
info: installing component 'rustc'
 85.3 MiB /  85.3 MiB (100 %)  12.5 MiB/s ETA:   0 s                
info: installing component 'rust-std'
 56.2 MiB /  56.2 MiB (100 %)  15.0 MiB/s ETA:   0 s                
info: installing component 'cargo'
info: installing component 'rust-docs'
 10.2 MiB /  10.2 MiB (100 %)   4.2 MiB/s ETA:   0 s                
info: default toolchain set to 'stable'

  stable installed - rustc 1.34.0 (91856ed52 2019-04-10)


Rust is installed now. Great!

To get started you need Cargo's bin directory ($HOME/.cargo/bin) in your PATH 
environment variable. Next time you log in this will be done automatically.

To configure your current shell run source $HOME/.cargo/env
</pre>

## インストール先
インストールメッセージの最後の方にRustを使用するにはCargoのbinディレクトリ(`$HOME/.cargo/bin`)を環境変数PATHに追加してくださいとあります。<br/>
lsコマンドでそのディレクトリを確認するとRustコンパイラの`rustc`以外に、コンパイルマネージャとパッケージマネージャを兼ねる`cargo`、ドキュメンテーションツールの`rustdoc`、これらツールチェーンのインストーラ`rustup`もインストールされています。<br/>
rust-lldbとかrust-gdbとかデバッガらしきものもインストールされています。

<pre>
~$ ls $HOME/.cargo/bin/
cargo  cargo-clippy  cargo-fmt  cargo-miri  clippy-driver  rls  rust-gdb  rust-lldb  rustc  rustdoc  rustfmt  rustup
</pre>

## パスの設定

親切にもパスを通すスクリプト`$HOME/.cargo/env`を用意してくれています。<br/>
中身はexportコマンドで＄HOME/.cargo/binをパスに追加しています。<br/>
これをsourceコマンドで読み込みます。

<pre>
~$ cat $HOME/.cargo/env
export PATH="$HOME/.cargo/bin:$PATH"
~$ source $HOME/.cargo/env
</pre>

## 実行確認

`cargo`、`rustc`、`rustdoc`、`rustup`は無事インストールされています。

<pre>
~$ cargo --version
cargo 1.34.0 (6789d8a0a 2019-04-01)
~$ rustc --version
rustc 1.34.0 (91856ed52 2019-04-10)
~$ rustdoc --version
rustdoc 1.34.0 (91856ed52 2019-04-10)
~$ rustup --version
rustup 1.17.0 (069c88ed6 2019-03-05)
</pre>

rust-lldbでデバッグしたかったのですが、rust-lldbを実行するとlldbがないと怒られました。<br/>
aptコマンドでlldbを入れると無事起動しました。<br/>

<pre>
~$ rust-lldb 
/home/yoshi/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-lldb: 34: exec: lldb: not found

~$ sudo apt install lldb

~$ lldb --version
lldb version 6.0.0

~$ rust-lldb 
(lldb) command script import "/home/yoshi/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/etc/lldb_rust_formatters.py"
(lldb) type summary add --no-value --python-function lldb_rust_formatters.print_val -x ".*" --category Rust
(lldb) type category enable Rust
(lldb) 
</pre>

## ビルド

さっそく簡単なプログラムを書いて動かしてみます。<br/>

- rustcで直接コンパイル

<pre>
  ~$ vim hello.rs
  fn main() {
    println!("Hello, world!");
  }
  ~$ rustc hello.rs -o hello
  ~$ ./hello 
  Hello, world!
  </pre>
  
  - cargoでコンパイル
  
  <pre>
    ~$ cargo new hello
    Created binary (application) `hello` package
  ~$ cd hello
  ~$ cargo build
    Compiling hello v0.1.0 (/home/yoshi/rust/hello)
    Finished dev [unoptimized + debuginfo] target(s) in 0.26s
  ~$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.00s
    Running `target/debug/hello`
  Hello, world!
  </pre>
  
  ## cargoのオプション
  
  その他のcargoのオプションです。そのうち細かいところも見ていこうと思います。<br/>
  
  |オプション|説明|
|:-- |:-- |
|build|プロジェクトのビルドをする|
|check|ビルドできるかのチェックをする|
|clean|プロジェクトのクリーンをする|
|doc|ドキュメントを作成する|
|new|プロジェクトの作成|
|init|既存のディレクトリでプロジェクトの作成|
|run|実行ファイルを実行する|
|test|テストを実行する|
|bench|ベンチマークを実行する|
|update|Cargo.lockに記述された依存をアップデートする|
|search|crate.ioからパッケージを探します|
|public|パッケージをcreate.ioに公開します|
|install|rust製のバイナリをインストールする|
|uninstall|rust製のバイナリアンインストールします|
