# TIL0921 (동적 스크래핑_Selenium, MariaDB)

## (1) 셀레늄 

>  계층적 트리구조에서 각각의 돔객체들을 노드라고 한다 

- API 소개

| API                                                          | 뜻                                                 |
| ------------------------------------------------------------ | -------------------------------------------------- |
| remDr <- remoteDriver(remoteServerAddr="localhost",port=4445,browserName="chrome") | Selenium  서버에 접속하고   remoteDriver 객체 리턴 |
| remDr$open()                                                 | 크롬브라우저 오픈                                  |
| remDr$navigate(url)                                          | 페이지 렌더링                                      |
| doms <- remDr$findElements(using="css", "컨텐트를추출하려는태그의선택자") | 태그들을 찾자                                      |
| **sapply(doms, function(x) {x$getElementText()})**           | 찾아진 태그들의 컨텐트 추출                        |
| more  <- remDr$findElements(using='css', '클릭이벤트를강제발생시키려는태그의선택자') | 태그를 찾자                                        |
| **sapply(more, function(x) {x$clickElement()})**             | 찾아진 태그에 클릭 이벤트 발생                     |
| webElem **<-** remDr$findElement("css selector",  "body")                                       remDr$executeScript("scrollTo(0, document.body.scrollHeight)", args **=**                                                     list(webElem)) | 페이지를 아래로 내리는(스크롤)    효과             |



```R
#install.packages("RSelenium")
library(RSelenium)
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445, browserName = "chrome")
remDr$open()
# 이해를 돕기 위해 간단한 웹페이지를 크롤링하고 스크래핑 함
url <- "http://unico2013.dothome.co.kr/crawling/tagstyle.html"
remDr$navigate(url)

#단수형으로 노드 추출 using=css 나 using=css selector 나 동일함
one <- remDr$findElement(using='css','div') # 찾은 첫번째 노드 한 개 리턴(webElement 객체)
one$getElementTagName() # div
one$getElementText() # "테스트입니다1"

# 단수형으로 없는 노드 추출
one <- NULL
one <- remDr$findElement(using='css','p') # 없으면 오류 발생

# 만일 오류 발생을 무시하고 싶어서 사용하지만 소용없음, 외부 라이브러리 사용 때문이라 추정(^^)
# 없을 수도 있으면 복수형(findElements()) 사용할것, 없으면 비어있는 리스트를 반환하기 때문에 유용
one <- NULL
try(one <- remDr$findElement(using='css','p')) 


#복수형으로 노드 추출
more <- remDr$findElements(using='css','div')
sapply(more, function(x) x$getElementTagName())
sapply(more, function(x) x$getElementText())

#복수형으로 없는 추출
more<-remDr$findElements(using='css','p') # 없으면 오류가 발생하지 않음 비어있는 리스트(NULL이랑은 다름) 리턴
print(more)  
if(length(more) == 0) 
  cat("<p> 태그는 없슈\n")
sapply(more, function(x) x$getElementTagName())
sapply(more, function(x) x$getElementText())
```



```R
##### 웹페이지를 하나의 이미지로 끌어올 경우 #####
install.packages("base64enc") # 인코딩하거나 디코딩
install.packages("magick") # 바이너리 형식의 이미지를 읽어오는 기능, jpg 이미지를 png로 바꾸는 기능을 지원하는 패키지
library(base64enc)
library(magick)

remDr <- remoteDriver(remoteServerAddr = "localhost", port=4445, browserName="chrome")
remDr$open()
remDr$navigate("https://google.com")


# this returns a list of base64 characters
screenshot <- remDr$screenshot(display = FALSE)
# converts the base64 characters into a vector
screenshot <- base64decode(toString(screenshot), output = NULL) # 문자열형식으로 변환한다음 다시 디코딩
# reads the vector as stores it as a PNG
screenshot <- image_read(screenshot) # magick가 제공하는 함수 image_read()
image_browse(screenshot) # magick가 제공하는 함수 image_browse()


remDr$screenshot(display = FALSE, file="c:/Temp/google.png")
pngdata <- image_read("c:/Temp/google.png")
image_browse(pngdata)

```



```R
##### 네이버 책 페이지 베스트셀러 크롤링 #####
site <- "https://book.naver.com/"
remDr$navigate(site)

# bestseller_tab
booksitenodes <- remDr$findElements(using='css', '#bestseller_tab > ul.tab_cp_spt > li > a')
booksites <- sapply(booksitenodes, function(x) {x$getElementAttribute("class")}); booksites
booksites <- unlist(booksites); booksites
booksites <- unlist(strsplit(booksites, ' ')); booksites
size <- length(booksites)
booksites <- booksites[seq(1, size, 2)]; booksites

for (booksite in booksites) {
  # 책판매 사이트 선택
  booksitenode <- remDr$findElement(using='css', paste0('#tab_cp_spt_', booksite))
  booksitenode$clickElement()
  Sys.sleep(2)
  
  # 책 이미지 가져오기
  bookthumbenodes <- remDr$findElements(using='css', '#bestseller_list dl > dt:nth-child(1) img')
  bookthumburl <- sapply(bookthumbenodes, function(x) {x$getElementAttribute("src")})
  bookthumburl <- unlist(bookthumburl); bookthumburl
  
  # 책 제목 가져오기
  booktitlenodes <- remDr$findElements(using='css', '#bestseller_list dl > dt:nth-child(2) > a')
  booktitle <- sapply(booktitlenodes, function(x) {x$getElementText()})
  booktitle <- gsub("[[:cntrl:]]", "", booktitle); booktitle # 중간에 개행문자 제거
  
  df <- data.frame(bookthumburl, booktitle)
  if (!dir.exists('book')) 
    dir.create('book')
  print(df)
  write.csv(df, file=paste0('book/', booksite, '.csv'))
}


# GS25 행사상품 정보가져오기
site <- 'http://gs25.gsretail.com/gscvs/ko/products/event-goods'
remDr$navigate(site)

eventgoodsnodes <- remDr$findElements(using='css', '#contents > div.cnt > div.cnt_section.mt50 > div > div > div:nth-child(3) > ul > li > div > p.tit')
eventgoodsname <- sapply(eventgoodsnodes, function(x) {x$getElementText()})

eventgoodsnodes <- remDr$findElements(using='css', '#contents > div.cnt > div.cnt_section.mt50 > div > div > div:nth-child(3) > ul > li > div > p.price > span')
eventgoodsprice <- sapply(eventgoodsnodes, function(x) {x$getElementText()})

```



- 스크롤이 내려가면서 댓글을 렌더링하기 때문에 댓글을 가져오려면 <span style="color:red;">R로는 렌더링을 처리할 수 없고</span> <span style="color:red;">JavaScript로 스크롤을 다운시킨 후 </span>댓글을 가져온다

```R
# [ YES24의 명견만리 댓글 읽어오기 ]

library(RSelenium)
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445, browserName = "chrome")
remDr$open()
remDr$navigate("http://www.yes24.com/24/goods/40936880")


webElem <- remDr$findElement("css", "body"); str(webElem)
remDr$executeScript("scrollTo(0, 0)", args = list(webElem))
Sys.sleep(1)
remDr$executeScript("scrollBy(0, 3200)", args = list(webElem))
Sys.sleep(1)
remDr$executeScript("scrollBy(0, 3200)", args = list(webElem))
Sys.sleep(1)
remDr$executeScript("scrollBy(0, 3200)", args = list(webElem))
Sys.sleep(3)

repl_v = NULL
endFlag <- FALSE
page <- 3

repeat {
  # 더보기 5번누르기
  for(index in 3:7) {
    fullContentLinkCSS <- paste("#infoset_reviewContentList > div:nth-child(",index,") > div.reviewInfoBot.crop > a", sep='')
    fullContentLink <- remDr$findElements(using='css selector',  fullContentLinkCSS)
    if (length(fullContentLink) == 0) {
      cat("종료\n")
      endFlag <- TRUE
      break
    }
    remDr$executeScript("arguments[0].click();",fullContentLink);
    Sys.sleep(1)
    fullContentCSS <- paste("#infoset_reviewContentList > div:nth-child(",index,") > div.reviewInfoBot.origin > div.review_cont > p", sep='')
    fullContent<-remDr$findElements(using='css selector', fullContentCSS)
    repl <-sapply(fullContent,function(x){x$getElementText()})    
    print(repl)
    cat("---------------------\n")
    repl_v <- c(repl_v, unlist(repl))
  }
  if(endFlag)
    break;  
  
  if(page == 10){
    page <- 3
    nextPageCSS <- "#infoset_reviewContentList > div.review_sort.sortTop > div.review_sortLft > div > a.bgYUI.next"
  }
  else{
    page <- page+1;
    nextPageCSS <- paste("#infoset_reviewContentList > div.review_sort.sortBot > div.review_sortLft > div > a:nth-child(",page,")",sep="")
  }
  remDr$executeScript("scrollTo(0, 0)", args = list(webElem))
  nextPageLink <- remDr$findElements(using='css selector', nextPageCSS) 
  remDr$executeScript("arguments[0].click();", nextPageLink);
  #sapply(nextPageLink, function(x) {x$clickElement()})  
  Sys.sleep(3)
  print(page)
}
write(repl_v, "yes24.txt")

```



```R
##### [ 스타벅스 매장 정보 읽어오기1 ] #####
library(RSelenium)

remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445, browserName="chrome")
remDr$open()
remDr$navigate("https://www.istarbucks.co.kr/store/store_map.do?disp=locale")

selectSeoul <- "#container > div > form > fieldset > div > section > article.find_store_cont > article > article:nth-child(4) > div.loca_step1 > div.loca_step1_cont > ul > li:nth-child(1) > a"
nextPageLink <- remDr$findElements(using='css selector', selectSeoul)  
sapply(nextPageLink, function(x) {x$clickElement()})

selectAll <- paste("#mCSB_2_container > ul > li:nth-child(1) > a")
nextPageLink <- remDr$findElements(using='css selector', selectAll)  
sapply(nextPageLink, function(x) {x$clickElement()})

sizeCss <- "#container > div > form > fieldset > div > section > article.find_store_cont > article > article:nth-child(4) > div.loca_step3 > div.result_num_wrap > span"
size <- remDr$findElements(using='css selector', sizeCss)
limit <- sapply(size, function(x) {x$getElementText()})    

nameList <- NULL
addressList <- NULL
phoneList <- NULL
latList <- NULL
longList <- NULL

for(i in 1 : as.numeric(limit)){
  nameCss <- paste("#mCSB_3_container > ul > li:nth-child(",i,")  > strong", sep = '')
  nameLink <- remDr$findElements(using='css selector', nameCss)
  a <- sapply(nameLink, function(x) {x$getElementText()})
  nameList <- c(nameList, unlist(a))
  
  infoCss <- paste("#mCSB_3_container > ul > li:nth-child(",i,")  > p", sep = '')
  infoLink <- remDr$findElements(using='css selector', infoCss)
  a <- sapply(infoLink, function(x) {x$getElementText()})
  words = strsplit(unlist(a), split="\n")
  addressList <- c(addressList, words[[1]][1])
  phoneList <- c(phoneList, words[[1]][2])
  
  pointCss <- paste("#mCSB_3_container > ul > li:nth-child(",i,")", sep = '')
  pointLink <- remDr$findElements(using='css selector', pointCss)
  latList <- c(latList, sapply(pointLink, function(x) {x$getElementAttribute('data-lat')}))
  longList <- c(longList, sapply(pointLink, function(x) {x$getElementAttribute('data-long')}))
  
  if(i %% 3 == 0 && i != as.numeric(limit)){
    remDr$executeScript("var su = arguments[0]; var dom = document.querySelectorAll('#mCSB_3_container > ul > li')[su]; dom.scrollIntoView();", list(i))
  }
}
```



```R
##### [ 스타벅스 매장 정보 읽어오기2 ] #####
library(RSelenium)

remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445, browserName="chrome")
remDr$open()
site <- paste("https://www.istarbucks.co.kr/store/store_map.do?disp=locale")
remDr$navigate(site)

Sys.sleep(3)

#서울 클릭
btn1Css <- "#container > div > form > fieldset > div > section > article.find_store_cont > article > article:nth-child(4) > div.loca_step1 > div.loca_step1_cont > ul > li:nth-child(1) > a"
btn1Page <- remDr$findElements(using='css', btn1Css)
sapply(btn1Page, function(x) {x$clickElement()})
Sys.sleep(3)

#전체 클릭
btn2Css <- "#mCSB_2_container > ul > li:nth-child(1) > a"
btn2Page <- remDr$findElements(using='css', btn2Css)
sapply(btn2Page, function(x) {x$clickElement()})
Sys.sleep(3)

index <- 0
starbucks <- NULL
total <- sapply(remDr$findElements(using='css', "#container > div > form > fieldset > div > section > article.find_store_cont > article > article:nth-child(4) > div.loca_step3 > div.result_num_wrap > span"),function(x){x$getElementText()})

repeat{
  index <- index + 1
  print(index)
  
  storeCss <- paste0("#mCSB_3_container > ul > li:nth-child(",index,")")
  storePage <- remDr$findElements(using='css', storeCss)
  if(length(storePage) == 0) 
    break
  storeContent <- sapply(storePage, function(x) {x$getElementText()})
  
  #스타벅스 정보 추출
  #strsplit(storeContent, split="\n")
  storeList <- strsplit(unlist(storeContent), split="\n")
  shopname <- storeList[[1]][1]
  addr <- storeList[[1]][2]
  addr <- gsub(",", "", addr)
  telephone <- storeList[[1]][3]
  
  #스타벅스 위도 경도 추출
  lat <- sapply(storePage, function(x) {x$getElementAttribute("data-lat")})
  lng <- sapply(storePage, function(x) {x$getElementAttribute("data-long")})
  
  #병합
  starbucks <- rbind(starbucks ,cbind(shopname, addr, telephone, lat, lng))
  
  #스크롤 다운
  if(index %% 3 == 0 && index != total)
    remDr$executeScript("var dom = document.querySelectorAll('#mCSB_3_container > ul > li')[arguments[0]]; dom.scrollIntoView();", list(index))
}

getwd()
write.csv(starbucks, "starbucks.csv")

```



# (2) Maria DB

> oracle에 먹혀서 거의 유료화된 MySQL 기능을 무료로 사용가능 (license free)
>
> MariaDB는 MySQL과 같은 소스 코드를 기반으로 만들어진 오픈소스의 관계형 데이터베이스 관리 시스템(RDBMS)으로 사용방법과 구조도 MySQL과 거의 동일 (MySQL과 높은 호환성)
>
> 

```mariadb
# [접속방법1] 
# C:\Windows\System32>mysql -u root -p # 계정이 root인 user
```

```mariadb
# [접속방법2]
# Enter password: bigdata
# Commands end with ';' or '\g'
show databases; # 기본 데이터베이스 보기
use test; # test 데이터베이스 사용
show tables; # 'test' 데이터베이스 내의 테이블 목록 보기, Empty set(테이블 없음)

create database work; # 'work' 데이터베이스 생성
show databases;
use work;

# 4개의 column을 가지는 goods 테이블 생성
create table goods(
    code int primary key,
    name varchar(20) not null, # varchar, 실제 저장되는 바이트 수만큼만 저장
    su int,
    dan int
);

# insert 명령으로 goods 테이블에 레코드를 추가
insert into goods values(1, '냉장고', 2, 850000);
insert into goods values(2, '세탁기', 3, 550000);
insert into goods values(3, '전자레인지', 2, 350000);
insert into goods values(4, 'HDTV', 3, 1500000);

# select 명령으로 레코드 조회
select * from goods;

```



> MariaDB를 사용하면서 사용자 계정으로 MariaDB의 관리자인 "root" 계정을 이용하고 있다. 사용자 계정을 만들고, 등록된 사용자에게 권한을 설정한다.

```mariadb
# localhost에 scott이라는 사용자 계정만들기(비밀번호는 tiger)
create user 'scott'@'localhost' identified by 'tiger';

# work 데이터 베이스에서 'scott'@'localhost'에게 모든 권한을 부여
grant all privileges on work.* to 'scott'@'localhost';

# 사용자 생성 마무리
flush privileges;

quit
```

