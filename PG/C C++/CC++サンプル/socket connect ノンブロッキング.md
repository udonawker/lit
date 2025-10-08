```
ノンブロッキング接続が確立されたかどうかは、select()関数（またはpoll()、epoll()などの同様の関数）とgetsockopt()関数を組み合わせて確認します。 以下に、接続完了を確認する一般的な手順を説明します。 1. connect()の戻り値を確認する ノンブロッキングソケットに対してconnect()関数を呼び出した場合、接続がすぐに完了しないと、通常はerrnoにEINPROGRESS（またはWindowsではWSAEWOULDBLOCK）が設定され、関数は\(-1\)を返して即座に戻ります。 接続完了: connect()が\(0\)を返した場合、接続は即座に完了しています。接続進行中: connect()が\(-1\)を返し、errnoがEINPROGRESSである場合、接続はバックグラウンドで継続中です。 2. select()でソケットの状態を監視する EINPROGRESSが返された場合は、select()関数を使ってソケットが書き込み可能になるのを待ちます。これは、接続が完了するとソケットが書き込み可能な状態になるためです。 select()の第2引数（書き込み用ファイルディスクリプタ集合）に、接続中のソケットを含めます。select()がブロックから戻ってきたら、ソケットが書き込み可能になったかを確認します。 3. getsockopt()でソケットのエラー状態を取得する select()がソケットの書き込み可能を通知した後、getsockopt()関数を使用してソケットの状態を確認します。 getsockopt()のオプションにSO_ERRORを指定します。この呼び出しによって、接続処理中に発生した保留中のエラーを取得できます。エラーコードが\(0\): エラーがないことを意味し、接続が正常に確立されたと判断できます。エラーコードが\(0\)以外: 接続エラーが発生したことを意味します（例：ECONNREFUSED（接続拒否）など）。 別の確認方法 connect()の再呼び出し: 接続完了後にconnect()を再度呼び出し、errnoがEISCONN（既に接続済み）になるか確認する方法もあります。\(0\)バイトのread(): 一部のシステムでは、接続完了後に\(0\)バイトのread()を試み、その戻り値やエラーで判断する方法も利用されます。 まとめ ノンブロッキング接続では、connect()が\(-1\)とEINPROGRESSを返した後に、select()で書き込み可能を待ち、getsockopt(..., SO_ERROR, ...)で最終的な接続の成否を判断するのが最も確実で一般的な方法です。 


1. connect()の戻り値を確認する
ノンブロッキングソケットに対してconnect()関数を呼び出した場合、接続がすぐに完了しないと、通常はerrnoにEINPROGRESS（またはWindowsではWSAEWOULDBLOCK）が設定され、関数は\(-1\)を返して即座に戻ります。
・接続完了: connect()が\(0\)を返した場合、接続は即座に完了しています。
・接続進行中: connect()が\(-1\)を返し、errnoがEINPROGRESSである場合、接続はバックグラウンドで継続中です。 

別の確認方法
・connect()の再呼び出し: 接続完了後にconnect()を再度呼び出し、errnoがEISCONN（既に接続済み）になるか確認する方法もあります。


----
#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <sys/ioctl.h>
#include <unistd.h>

int main(void) {

	int sfd;	// ソケットファイルディスクプリタ
	struct sockaddr_in saddr;
	int val = 1;
	int rtn;
	fd_set readfds;

	sfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sfd < 0) {
		exit(EXIT_FAILURE);
	}

	// ノンブロッキングソケットに変更
	ioctl(sfd, FIONBIO, &val);

	saddr.sin_family = AF_INET;
	saddr.sin_port = htons(12345);
	saddr.sin_addr.s_addr = inet_addr("127.0.0.1");
	rtn = connect(sfd, (struct sockaddr*)&saddr, sizeof(saddr));
	if (rtn < 0) {
		perror("ノンブロッキングだからここでエラーになるのはOK");
	}

	FD_ZERO(&readfds);
	FD_SET(sfd, &readfds);
	rtn = select(sfd + 1, &readfds, NULL, NULL, NULL);
	if (rtn < 0) {

	}

	close(sfd);

	exit(EXIT_SUCCESS);

}

----
```
