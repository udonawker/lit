引用 [Windows版VirtualBoxで仮想HDDのUUIDを変更する方法](https://dev.matumo.com/489/) <br/>

## １．登録されている仮想HDDの確認をする。

### VirtualBoxを起動し、左メニューの最上部にある「Tools」をクリックする。

![1](https://cdn.shortpixel.ai/client/to_webp,q_lossy,ret_img,w_300/https://dev.matumo.com/wp-content/uploads/2018/10/Screenshot_660-300x131.png) <br/>

「Tools」の右端にリストアイコンが表示されるので、クリックして「Media」を選択する。<br/>

![2](https://cdn.shortpixel.ai/client/to_webp,q_lossy,ret_img,w_300/https://dev.matumo.com/wp-content/uploads/2018/10/Screenshot_659-300x166.png) <br/>

ここで追加されている全てのディスクの情報が表示されるので、これからUUIDを変えるディスクの存在を確認しておく。<br/>
また、手順３で仮想HDDファイルのフルパスを利用するため、Location（場所）の値も把握しておく。<br/>

## ２．対象の仮想HDDを設定から除去する。

ソフトウェアが仮想HDDをUUIDで管理しているため、一旦除去する。<br/>
※注意：除去すると対象の仮想HDDがどの設定と紐付いているか判別できなくなるため、メモしておく等の対策が必要。<br/>
どの仮想環境と紐付いているかは、下記にある「解放」を行う際に表示される。<br/>
対象の仮想HDDを右クリックして、解放をクリックする。<br/>

![3](https://cdn.shortpixel.ai/client/to_webp,q_lossy,ret_img,w_300/https://dev.matumo.com/wp-content/uploads/2018/10/Screenshot_661-300x153.png) <br/>

先述の通り、紐付いている仮想マシンの確認をしてから解放する。<br/>

![4](https://cdn.shortpixel.ai/client/to_webp,q_lossy,ret_img,w_236/https://dev.matumo.com/wp-content/uploads/2018/10/Screenshot_662.png) <br/>

もう一度対象のHDDを右クリックして、除去をクリックする。<br/>
※注意：必ず「保持」を選択して除去する。<br/>

![5](https://cdn.shortpixel.ai/client/to_webp,q_lossy,ret_img,w_300/https://dev.matumo.com/wp-content/uploads/2018/10/Screenshot_663-300x139.png) <br/>

必ず「保持」を選択する。理由はダイアログに記述されている通り。<br/>

![6](https://cdn.shortpixel.ai/client/to_webp,q_lossy,ret_img,w_300/https://dev.matumo.com/wp-content/uploads/2018/10/Screenshot_664-300x197.png) <br/>


--------

## ３．仮想HDDを追加して仮想環境と紐付ける。

各々の仮想環境設定で対象の仮想HDDを追加し紐付ける。<br/>

![7](https://cdn.shortpixel.ai/client/to_webp,q_lossy,ret_img,w_300/https://dev.matumo.com/wp-content/uploads/2018/10/Screenshot_665-300x165.png) <br/>

一度追加すればリストから選べるようになる。<br/>
先程除去したため、とりあえず「追加」を選択して作業を進める。<br/>

![8](https://cdn.shortpixel.ai/client/to_webp,q_lossy,ret_img,w_258/https://dev.matumo.com/wp-content/uploads/2018/10/Screenshot_666.png) <br/>
