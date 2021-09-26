## [株式投資メモからスクレイピングする方法](https://megane-sensei.com/609/)

```
from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
import time

def download_stock_csv(codes,year_range):
    #####codesは、株式コードをリストで渡し、year_rangeは取得年をrangeで渡す。
    
    #---------ダウンロード先を指定してChromeを開く---------
    ###ダウンロード先(*＾＾*)
    download_directory='ファイルのPATH'
　　 #例) download_directory='/Users/<ここにユーザー名が入る>/Desktop/KabuPython/raw_prices_for_selenium'
    #################
    
    chop=webdriver.ChromeOptions()
    prefs={"download.default_directory":download_directory}
    chop.add_experimental_option("prefs",prefs)
    chop.add_argument('--ignore-certificate-errors')
    
    ##Chromeを起動させる##
    driver = webdriver.Chrome(options = chop)
    #################
    
    
    for code in codes:
        try:
            for year in year_range :
                url = 'https://kabuoji3.com/stock/{0}/{1}/'.format(code,year)
                driver.get(url)
                try:
                    driver.find_element_by_name("csv").click()
                    time.sleep(3)
                    driver.find_element_by_name("csv").click()
                except NoSuchElementException:
                    print(code,"の",year,"年がありません")
                    pass
                time.sleep(1)
        except NoSuchElementException:
            print("no code")
            pass
        time.sleep(3) 
```

```
download_stock_csv([1301,1302,1305],range(2000,2002))
```
       
