# TIL0917 (정적크롤링(rvest, XML, httr 패키지) / Open API 활용 공공DB, SNS 데이터 수집 / 정규표현식)

## (0) 정적크롤링

> Chrome에서 알려준 선택자 위치를 못찾은 경우는 컨텐츠의 내용 중 일부가 동적으로 만들어진 것이 반영되었을 수 있기 때문이다.
>
> 크롬 브라우저는 정적, 동적 렌더링이 모두 끝난 상태를 반환 한것. 서버로부터 보내온 html 문서안에 들어있었던 태그를 정적 컨텐츠라 하고, html 문서 안에 JavaScript에 의해서 만들어진 태그를 동적 컨텐츠라 할 수 있다.



## (1) rvest, XML, httr 패키지

> `rvest 패키지` 이외에도 XML, httr 패키지를 활용하여 정적 웹페이지를 크롤링할 수 있다.
>
> 끌어오고자 하는 웹페이지가 HTML이 아니라 공공DB나 네이버의 XML api와 같이 XML 형식으로 끌어올 때 `XML 패키지`를 활용한다.
>
> `httr 패키지`은 크롤링보다는 스크래핑에 적합한 패키지이다. 단순히 GET 방식으로 받아오는 건 httr보다는 rvest가 낫지만 GET방식이면서 요청헤더에 추가해줘야할 경우 httr 패키지를 사용한다. rvest나 XML로는 POST 방식을 처리할 수 없기 때문에 이때는 httr 패키지를 활용한다.



```R
##### 정적 웹페이지 #####
# rvest 패키지 주요 함수
html_nodes(x, css, xpath) # 돔객체(들)를 받아온다
html_text
html_attr

# XML 패키지 주요 함수
htmlParse (file, encoding="…") # 돔객체 생성
xpathSApply(doc, path(XPath), fun) # fun : xmlValue, xmlGetAttr, xmlAttrs

# httr 패키지
http.standard <- GET('url')

otp_url <- 'POST url'
parameter = list(
  name = 'fileDown',
  filetype = 'csv',
  url = 'MKD/03/0303/03030103/mkd03030103',
  tp_cd = 'ALL',
  date = '20190607',
  lang = 'ko',
  pagePath = '/contents/MKD/03/0303/03030103/MKD03030103.jsp')

my_otp <- POST(otp_url, query = parameter)

```



```R
### XML 패키지 ###
# 한겨레 페이지
library(XML)
library(rvest) # read_html 사용하기 위해

imsi <- read_html("http://www.hani.co.kr/")
t <- htmlParse(imsi)
content <- xpathSApply(t,'//*[@id="main-top01-scroll-in"]/div/div/h4/a', xmlValue); 
content
content <- gsub("[[:punct:]]", "", content) # 특수문자 전역적 대체
# gsub(찾을대상old, 뭐로대체할지new, content) : 모두 찾아서 전역적 대체
content


### httr 패키지 ###
# httr 패키지 사용 - GET 방식 요청
library(httr)
http.standard <- GET('http://www.w3.org/Protocols/rfc2616/rfc2616.html')

title2 = html_nodes(read_html(http.standard), 'div.toc h2')
title2 = html_text(title2)
title2

# GET 방식으로 안받아와도 됨
title2 = html_nodes(read_html('http://www.w3.org/Protocols/rfc2616/rfc2616.html'), 'div.toc h2')
title2 = html_text(title2); title2


# httr 패키지 사용 - POST 방식 요청
library(httr)
otp_url= 'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'
parameter = list(
  name = 'fileDown',
  filetype = 'csv',
  url = 'MKD/03/0303/03030103/mkd03030103',
  tp_cd = 'ALL',
  date = '20190607',
  lang = 'ko',
  pagePath = '/contents/MKD/03/0303/03030103/MKD03030103.jsp')

my_otp = POST(otp_url, query = parameter) # POST 방식으로 쿼리를 전달하면서 요청

download_url = 'http://file.krx.co.kr/download.jspx'
data = POST(download_url, query = list(code = my_otp), add_headers(referer = otp_url))
data # OTP 받아와서 10초 안에 해야함

library(readr)
data =  read_html(data) 
data = html_text(data)
data = read_csv(data)
as.data.frame(data)

# 뉴스, 게시판 등 글 목록에서 글의 URL만 뽑아내기 
res = GET('https://news.naver.com/main/list.nhn?mode=LSD&mid=sec&sid1=001')
htxt = read_html(res)
link = html_nodes(htxt, 'div.list_body a'); length(link)
article.href = unique(html_attr(link, 'href'))
article.href

# 이미지, 첨부파일 다운 받기 
# pdf
res = GET('http://cran.r-project.org/web/packages/httr/httr.pdf')
writeBin(content(res, 'raw'), 'c:/Rexam/httr.pdf')

# jpg
h = read_html('http://unico2013.dothome.co.kr/productlog.html')
imgs = html_nodes(h, 'img')
img.src = html_attr(imgs, 'src')
for(i in 1:length(img.src)){
  res = GET(paste('http://unico2013.dothome.co.kr/', img.src[i], sep=""))
  writeBin(content(res, 'raw'), paste('C:/Rexam/data/', img.src[i], sep=""))
} 

```



## (2) 정적 웹페이지 수집 -> 

## Open API를 활용한 공공DB와 SNS 데이터 수집 

## -> 동적 웹페이지 수집

- `API (Application Programming Interface)`

  ​	(1) 미리 만들어놓은 프로그램 (함수, 클래스 등)

  ​	(2) **URL 문자열**(Web세상)

  ​				필요한 데이터를 요청하고 받아갈 수 있게 지원하는 URL 문자열

  ​					- 인증키, Query 문자열 등을 필요로 한다

  ​					- 요청 헤더에 규격정보를 제공해야 할 수도 있다

  ​					- 정해진 규격의 URL 문자열

> GET방식이면서 url문자열 안에 모든 정보가 들어간다면 브라우저에서 요청할 수 있지만,
>
> 요청헤더에 담는다거나 POST방식으로 요청할 때는 브라우저에서 요청할 수 없다.
>
> 쿼리문자 뒤에 요청하는 것은 상관 없지만 POST 방식도 브라우저에서 url로 직접 요청할 수 없다.

```R
##### Open API를 활용한 공공DB와 SNS 데이터 수집 #####
# GET방식이면서 url문자열 안에 모든 정보가 들어간다면 브라우저에서 요청할 수 있지만
# 지금 처럼 요청헤더에 담는다거나 POST방식으로 요청할 때는 브라우저에서 요청할 수 없다
# 쿼리문자 뒤에 요청하는 것은 상관 없지만
# POST 방식도 브라우저에서 url로 요청하는 것 안됨
# url 뒤에 붙이는 것이 아니라 요청헤더에 담아서 요청하기 때문에 브라우저에서 직접 요청할 수가 없다
# 브라우저에서는 직접 요청이 안됨
# SNS의 Open API 활용
library(httr)
library(rvest)
library(XML)

#rm(list=ls())
searchUrl <- "https://openapi.naver.com/v1/search/blog.xml"
Client_ID <- "izGsqP2exeThwwEUVU3x"
Client_Secret <- "WrwbQ1l6ZI"

query <- URLencode(iconv("봄","euc-kr","UTF-8")) # euc-kr에서 UTF-8로 변환
url <- paste0(searchUrl, "?query=", query, "&display=100")
doc <- GET(url, add_headers("Content_Type" = "application/xml",
                            "X-Naver-Client-Id" = Client_ID, "X-naver-Client-Secret" = Client_Secret))
doc # XML 형식

# 블로그 내용에 대한 리스트 만들기		
doc2 <- htmlParse(doc, encoding="UTF-8")
text <- xpathSApply(doc2, "//item/description", xmlValue)
text
text <- gsub("</?b>", "", text)
text <- gsub("&.+t;", "", text)
text

# 네이버 뉴스 연동  
searchUrl<- "https://openapi.naver.com/v1/search/news.xml"
Client_ID <- "izGsqP2exeThwwEUVU3x"
Client_Secret <- "WrwbQ1l6ZI"
query <- URLencode(iconv("코로나","euc-kr","UTF-8"))
url <- paste0(searchUrl, "?query=", query, "&display=100")
doc <- GET(url, add_headers("Content_Type" = "application/xml",
                            "X-Naver-client-Id" = Client_ID, "X-Naver-Client-Secret" = Client_Secret))
doc # XML 형식

# 네이버 뉴스 내용에 대한 리스트 만들기		
doc2 <- htmlParse(doc, encoding="UTF-8")
text <- xpathSApply(doc2, "//item/description", xmlValue); 
text
text <- gsub("</?b>", "", text)
text <- gsub("&.+t;", "", text)
text


# 트위터 글 읽어오기
install.packages("rtweet")
library(rtweet) 
appname <- "edu_data_collection"
api_key <- "RvnZeIl8ra88reu8fm23m0bST"
api_secret <- "wTRylK94GK2KmhZUnqXonDaIszwAsS6VPvpSsIo6EX5GQLtzQo"
access_token <- "959614462004117506-dkWyZaO8Bz3ZXh73rspWfc1sQz0EnDU"
access_token_secret <- "rxDWfg7uz1yXMTDwijz0x90yWhDAnmOM15R6IgC8kmtTe"
twitter_token <- create_token(
  app = appname,
  consumer_key = api_key,
  consumer_secret = api_secret,
  access_token = access_token,
  access_secret = access_token_secret)

key <- "취업"
key <- enc2utf8(key) # CP949 -> UTF-8
result <- search_tweets(key, n=100, token = twitter_token)
str(result)
result$retweet_text
content <- result$retweet_text
content <- gsub("[[:lower:][:upper:][:digit:][:punct:][:cntrl:]]", "", content) # []:or
content


# 버스 실시간 운행정보
library(XML)
API_key  <- "%2BjzsSyNtwmcqxUsGnflvs3rW2oceFvhHR8AFkM3ao%2Fw50hwHXgGyPVutXw04uAXvrkoWgkoScvvhlH7jgD4%2FRQ%3D%3D"
bus_No <- "402"
url <- paste("http://ws.bus.go.kr/api/rest/busRouteInfo/getBusRouteList?ServiceKey=", API_key, "&strSrch=", bus_No, sep="")
# URL : http://ws.bus.go.kr/api/rest/busRouteInfo/getBusRouteList?ServiceKey=%2BjzsSyNtwmcqxUsGnflvs3rW2oceFvhHR8AFkM3ao%2Fw50hwHXgGyPVutXw04uAXvrkoWgkoScvvhlH7jgD4%2FRQ%3D%3D&strSrch=402
doc <- xmlParse(url, encoding="UTF-8")
top <- xmlRoot(doc) # 최상위 태그부터
top
df <- xmlToDataFrame(getNodeSet(doc, "//itemList")) # 태그명이 컬럼명으로 변환
df
str(df)
View(df)

busRouteId <- df$busRouteId
busRouteId


url <- paste("http://ws.bus.go.kr/api/rest/buspos/getBusPosByRtid?ServiceKey=", API_key, "&busRouteId=", busRouteId, sep="")
# URL : http://ws.bus.go.kr/api/rest/buspos/getBusPosByRtid?ServiceKey=%2BjzsSyNtwmcqxUsGnflvs3rW2oceFvhHR8AFkM3ao%2Fw50hwHXgGyPVutXw04uAXvrkoWgkoScvvhlH7jgD4%2FRQ%3D%3D&busRouteId=100100063
doc <- xmlParse(url, encoding="UTF-8")
top <- xmlRoot(doc)
top
df <- xmlToDataFrame(getNodeSet(doc, "//itemList"))
df
str(df); View(df)


# 서울시 빅데이터- XML 응답 처리
#http://openapi.seoul.go.kr:8088/796143536a756e69313134667752417a/xml/LampScpgmtb/1/100/

library(XML)
key = '796143536a756e69313134667752417a'
contentType = 'xml'
startIndex = '1'
endIndex = '200'
url = paste0('http://openapi.seoul.go.kr:8088/',key,'/',contentType,'/LampScpgmtb/',startIndex,'/',endIndex,'/')

con <- url(url, "rb") 
imsi <- read_html(con)
t <- htmlParse(imsi, encoding="UTF-8")
upNm <- xpathSApply(t,"//row/up_nm", xmlValue) 
pgmNm <- xpathSApply(t,"//row/pgm_nm", xmlValue)
targetNm <- xpathSApply(t,"//row/target_nm", xmlValue)
price <- xpathSApply(t,"//row/u_price", xmlValue)

df <- data.frame(upNm, pgmNm, targetNm, price)
View(df)
write.csv(df, "edu.csv")


# 한국은행 결제 통계시스템 Open API - JSON 응답 처리
install.packages("jsonlite") # 다른 패키지와 중복되는 부분을 해제하기 때문에 다른 패키지를 다시 로드 해야한다.
library(jsonlite)
key = '/4WQ7X833TXC370SUTDX4/'
contentType = 'json/' # 'xml/'
startIndex = '1'
endIndex = '/100/'

url <- paste0('http://ecos.bok.or.kr/api/KeyStatisticList',key,contentType,'kr/',startIndex,endIndex)
response <- GET(url)
json_data <- content(response, type = 'text', encoding = "UTF-8")
json_obj <- fromJSON(json_data)
df <- data.frame(json_obj)
df <- df[-1]
names(df) <- c("className", "unitName", "cycle", "keystatName", "dataValue")
View(df)

```

> #[실습1]
>
> 네이버 블로그는 url문자열만으로 요청하는 것이 아니라
>
> 요청헤더에 네이버에서 제공한 개발자 id와 secret 담아서 보내야하는데
>
> rvest는 그러한 처리를 할 수 없기 때문에 httr의 GET으로 요청한다.
>
> 브라우저에서 직접 요청하는 것이 안된다.
>
> POST 방식 요청도 마찬가지로 브라우저에서 직접 요청하는 것이 안된다.
>
> 네이버 블로그나 네이버 뉴스 예제는 브라우저에서 직접 요청할 수 없는 요청이었다



## (3) 정규표현식

> 특정한 규칙을 가진 문자열의 집합을 표현하는데 사용하는 '형식 언어'

[[:punct:]] ---> 특수문자 $#*&...

</?b> ---> \<b> or </?b> ( ? : 바로 앞에 문자가 한번나올수도 있고 안나올 수도 있다 )

&.+t ---> &at, &abct, &1t, &111t ( .+ : &와 t사이의 임의의 문자 1개 이상 )

`?` : `colou?r`는 `color`와 `colour`를 둘 다 일치시킨다

`*` : 0번 이상의 발생을 의미.  ab\*c는 `ac`, `abc`, `abbc`, `abbbc` 등을 일치시킨다

`+` : 1번 이상의 발생을 의미. ab+c는 `abc`, `abbc`, `abbbc` 등을 일치시키지만 `ac`는 일치시키지 않는다

`.` : 개행문자(\n)를 제외하고 임의의 문자 1개 문자와 일치

`gray|grey` : `gray` 또는 `grey` 와 일치한다.

```R
##### 정규표현식 사용 #####
word <- "JAVA javascript Aa 가나다 AAaAaA123 %^&*"
gsub(" ", "@", word); sub(" ", "@", word) # sub는 찾은 처음값 하나만 대체
gsub("A", "", word) # 모든 대문자A를 없애라
gsub("a", "", word) # 모든 소문자a를 없애라
gsub("Aa", "", word) # A와 a가 연달아 나온 것만을 없애라
gsub("(Aa)", "", word) # ()로 묶는다 위와 동일한 결과
gsub("(Aa){2}", "", word) # Aa를 2번 없애라
gsub("Aa{2}", "", word) # Aaa를 없애라
gsub("[Aa]", "", word) # 모든 A or a를 없애라 
gsub("[가-힣]", "", word) # 모든 한글문자를 없애라
gsub("[^가-힣]", "", word) # 모든 한글이 아닌 문자를 없애라
gsub("[&^%*]", "", word) # 모든 & or ^ or % or *을 없애라 (공백문자는 남는다)
gsub("[[:punct:]]", "", word) # 모든 특수문자를 없애라
gsub("[[:alnum:]]", "", word) # 모든 영문과 숫자를 없애라
gsub("[1234567890]", "", word) # 모든 0~9 숫자를 없애라
gsub("[0-9]", "", word) # 모든 숫자를 없애라
gsub("\\d", "", word) # 모든 숫자를 없애라
gsub("\\D", "", word) # 모든 숫자가 아닌것을 없애라
gsub("[[:digit:]]", "", word) # 모든 숫자를 없애라 
gsub("[^[:alnum:]]", "", word) # 모든 영문과 숫자가 아닌 것들을 없애라
gsub("[[:space:]]", "", word) # 모든 공백을 없애라
gsub("[[:punct:][:digit:]]", "", word) # 모든 특문 or 숫자를 없애라
gsub("[[:punct:][:digit:][:space:]]", "", word) # 모든 특문 or 숫자 or 공백을 없애라
```

