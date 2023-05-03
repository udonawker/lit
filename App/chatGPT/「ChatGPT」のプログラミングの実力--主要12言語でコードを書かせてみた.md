## [「ChatGPT」のプログラミングの実力--主要12言語でコードを書かせてみた](https://japan.zdnet.com/article/35203330/) 20230503

```
オレゴン州の現在時刻に応じて、「Good morning」「Good afternoon」または「Good evening」を出力した後、ループインデックス（1から始まる）、スペース、「Hello, world!」という言葉を含む10行を出力するプログラムを（言語の名前）で書いてほしい。
```

<br>
<br>

C++<br>
```
#include <ctime>

int main() {
    time_t now = time(0);
	tm* local_time = localtime(&now);
	int hour = local_time->tm_hour;

	if (hour >= 5 && hour < 12) {
	    std::cout << "Good moring\n";
    } else if (hour >= 12 && hour < 18) 
        std::cout << "Good afternoon!\n";
	} else {
	    std::cout << "Good evening!\n";
	}

	for (int i = 0; i <= 10; i++) {
	    std::cout << i << " Hello, world!\n";
	}

	return 0;
}
```

java<br>
```
import java.time.LocalTime;

public class GreetingProgram {
    public static void main(String[] args) {
	    LocalTime now = LocalTime.now();
		int hour = now.getHour();

		if (hour >= 5 && hour <12) {
		    System.out.println("Good morning!");
		} else if (hour >= 12 && hour < 18) {
		    System.out.println("Good afternoon!");
		} else {
		    System.out.println("Good evening!");
		}

		for (int i = 1; i <= 10; i++) {
		    System.out.println(i + " Hello, world!");
		}
	}
}
```

python<br>
```
import datetime

now = datetime.datetime.now();
hour = now.hour

if hour >= 5 and hour < 12:
    print("Good morning!")
elif hour >= 12 and hour < 18:
    print("Good afternoon!")
else:
    print("Good evening!")


for i in range(1, 11):
    print(i, "Hello, world!")
```
