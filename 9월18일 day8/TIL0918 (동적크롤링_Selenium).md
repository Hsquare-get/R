# TIL0916 (동적 스크래핑_Selenium)

## (0) 셀레늄 기동

> chromedriver.exe
>
> selenium-server-standalone-4.0.0-alpha-1.jar
>
> 두개의 파일을 C:/Rexam/selenium에 저장하고 명령프롬프트에서 해당 디렉토리로 간 다음 서버를 기동

```bash
# cmd 명령프롬프트 창에서 실행
java -Dwebdriver.chrome.driver="chromedriver.exe" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445

# cmd 창을 닫으면 셀레늄을 이용할 수 없다
```



- 렌더링이 끝난 Element 정보에는 보이는데 서버로부터 보내진 소스에는 없다면 정적크롤링을 할 수가 없다(Ajax로 구현했다는 뜻)

> html만으로는 웹페이지를 구성할 수는 없다. 
>
> JavaScript로 Ajax를 활용하여 그때그때 다르게 서버에 추가로 요청하여 웹페이지의 내용을 가져올것이다
>
> JavaScript에 의해 그때그때 동적으로 만들어지는 내용이라면 정적크롤링(rvest, XML, httr 패키지)으로는 원하는 데이터를 수집할 수 없다. 
>
> 이 때 셀레늄을 이용하면 렌더링을 통하여 동적으로 자바스크립트로 인해 만들어지는 내용을 가져올 수 있다.
>
> 셀레늄 서버를 통하여 렌더링을 대신 수행하도록 요청할 수 있기 때문에 크롬브라우저에 스크래핑하려는 페이지를 먼저 띄우게 한 후 (RSelenium 패키지)



- API 소개

| API                                                          | 뜻                                                 |
| ------------------------------------------------------------ | -------------------------------------------------- |
| remDr <- remoteDriver(remoteServerAddr="localhost",port=4445,browserName="chrome") | Selenium  서버에 접속하고   remoteDriver 객체 리턴 |
| remDr$open()                                                 | 크롬브라우저 오픈                                  |
| remDr$navigate(url)                                          | 페이지 랜더링                                      |
| doms <- remDr$findElements(using ="css selector", "컨텐트를추출하려는태그의선택자") | 태그들을 찾자                                      |
| sapply(doms,function(x){x$getElementText()})                 | 찾아진 태그들의 컨텐트 추출                        |
| more  <- remDr$findElements(using='css  selector', '클릭이벤트를강제발생시키려는태그의선택자') | 태그를 찾자                                        |
| sapply(more,function(x){x$clickElement()})                   | 찾아진 태그에 클릭 이벤트 발생                     |
| webElem **<-** remDr$findElement("css",  "body")                                       remDr$executeScript("scrollTo(0, document.body.scrollHeight)", args **=**                                                     list(webElem)) | 페이지를 아래로 내리는(스크롤)    효과             |

```R
install.packages("RSelenium")
library(RSelenium)

# 셀레늄 서버 접속
remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445, browserName = "chrome"); str(remDr)
remDr$open() # remDr 리스트로 만들어진 객체 (빈 창이 안뜨면 서버를 죽였다가 다시 실행)
remDr$navigate("http://www.google.com/")

# 속성 선택자로 element 찾기
webElem <- remDr$findElement(using = "css", "[name = 'q']"); str(remDr$findElement) 
webElem$sendKeysToElement(list("PYTHON", key = "enter")); webElem$sendKeysToElement


remDr$navigate("http://www.naver.com/")

# id 선택자로 element 찾기
webElem <- remDr$findElement(using = "css", "#query")
webElem$sendKeysToElement(list("PYTHON", key = "enter"))


# [ 네이버 웹툰 댓글 읽기 ]
url <- 'http://comic.naver.com/comment/comment.nhn?titleId=570503&no=135'
remDr$navigate(url)

# 단수형으로 노드 추출
more <- remDr$findElement(using='css', '#cbox_module > div > div.u_cbox_sort > div.u_cbox_sort_option > div > ul > li:nth-child(2) > a')
more$getElementTagName() # 태그네임 찾기 (a태그)
more$getElementText()
more$clickElement() # 클릭수행


# 2페이지부터 10페이지까지 링크 클릭하여 페이지 이동하기 
for (i in 4:12) {
  nextCss <- paste0("#cbox_module > div > div.u_cbox_paginate > div > a:nth-child(",i,") > span")
  nextPage <- remDr$findElement(using='css', nextCss)
  nextPage$clickElement()
  Sys.sleep(2) # 서버에 요청하고 렌더링할 시간을 줘야한다
}

# 복수형으로 노드 추출 
url <- 'http://comic.naver.com/comment/comment.nhn?titleId=570503&no=135'
remDr$navigate(url)

# 베스트 댓글 내용 읽어오기
bestReviewNodes <- remDr$findElements(using ="css selector", "ul.u_cbox_list span.u_cbox_contents")
bestReviewNodes # 찾아진 돔객체가 여러개
sapply(bestReviewNodes, function(x){x$getElementText()}) 
# sapply : 데이터들을 하나씩 순서대로 function을 수행시키고 차곡차곡 저장했다가 한번에 return

# 전체 댓글 링크 클릭후에 첫 페이지 내용 읽어오기
totalReview <- remDr$findElement(using='css','#cbox_module > div > div.u_cbox_sort > div.u_cbox_sort_option > div > ul > li:nth-child(2) > a')
totalReview$clickElement()
totalReviewNodes<-remDr$findElements(using ="css selector", "ul.u_cbox_list span.u_cbox_contents")
sapply(totalReviewNodes, function(x){x$getElementText()})


# 링크 클릭으로 AJAX 로 처리되는 네이버 웹툰 댓글 읽어 오기
repl_v = NULL;
remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445, browserName = "chrome")
remDr$open()
url <- 'http://comic.naver.com/comment/comment.nhn?titleId=570503&no=135'
remDr$navigate(url)

# 베스트 댓글 내용 읽어오기
doms1 <- remDr$findElements(using ="css", "ul.u_cbox_list span.u_cbox_contents")
vest_repl <- sapply(doms1, function(x){x$getElementText()})
repl_v <- c(repl_v, unlist(vest_repl))


##### 전체 댓글 내용 가져오기 (1시간 걸림) #####
toralReview <- remDr$findElement(using='css', 'span.u_cbox_in_view_comment')
toralReview$clickElement()

# 전체 댓글의 첫 페이지 내용 읽어오기
doms2 <- remDr$findElements(using ="css selector", "ul.u_cbox_list span.u_cbox_contents")
repl <- sapply(doms2, function(x){x$getElementText()})
repl_v <- c(repl_v, unlist(repl))

repeat {
  for (i in 4:12) {               
    nextCss <- paste("#cbox_module>div>div.u_cbox_paginate>div> a:nth-child(",i,") > span", sep="")                
    try (nextListLink <- remDr$findElement(using='css', nextCss))
    if (length(nextListLink) == 0)   break;
    nextListLink$clickElement()
    Sys.sleep(1) # 서버에 요청하고 렌더링할 시간을 줘야한다
    # 전체 댓글의 해당 페이지 내용 읽어오기
    doms3 <- remDr$findElements(using ="css selector", "ul.u_cbox_list span.u_cbox_contents")
    repl <-sapply(doms3, function(x){x$getElementText()})
    repl_v <- c(repl_v, unlist(repl))                
  }
  
  # 마지막 페이지로 갔을 경우 다음으로 넘어가는 처리
  try (nextPage<-remDr$findElement(using='css',
                                  "#cbox_module > div > div.u_cbox_paginate > div > a:nth-child(13) > span.u_cbox_cnt_page"))
  if (length(nextPage) == 0) break;
  nextPage$clickElement()
  Sys.sleep(1)
  doms2 <- remDr$findElements(using ="css selector", "ul.u_cbox_list span.u_cbox_contents")
  repl <- sapply(doms2, function(x){x$getElementText()})
  repl_v <- c(repl_v, unlist(repl))        
}
print(repl_v)
write(repl_v, "webtoon2.txt")
```



```R
# [ 아고다 페이지에 올려진 신라스테이 호텔에 대한 전체 페이지 댓글 읽기 ]
remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445, browserName = "chrome")
remDr$open()
url <- 'https://www.agoda.com/ko-kr/shilla-stay-yeoksam/hotel/seoul-kr.html?asq=z91SVm7Yvc0eRE%2FTBXmZWCYGcVeTALbG%2FvMXOYFqqcm2JknkW25Du%2BVdjH%2FesXg8ORIaVs1PaEgwePlsVWfwf3sX%2BVNABRcMMOWSvzQ9BxqOPOsvzl8390%2BEhEylPvEiBp0eoREr2xLYHgqmk0Io4J1HYEzEOqyvdox%2BwS6yxHeonB9lh7mJsBIjSBPoMzBLFW01k%2BU8s2bGO6PcSdsu3T30HwabyNzwNYKiv%2BRDxfs%3D&hotel=699258&tick=637215342272&languageId=9&userId=bcb7ecc6-7719-465f-bf29-951e39733c66&sessionId=uouhnqjisace4freagmzbxxc&pageTypeId=7&origin=KR&locale=ko-KR&cid=-1&aid=130243&currencyCode=KRW&htmlLanguage=ko-kr&cultureInfoName=ko-KR&ckuid=bcb7ecc6-7719-465f-bf29-951e39733c66&prid=0&checkIn=2020-05-30&checkOut=2020-05-31&rooms=1&adults=1&childs=0&priceCur=KRW&los=1&textToSearch=%EC%8B%A0%EB%9D%BC%EC%8A%A4%ED%85%8C%EC%9D%B4%20%EC%97%AD%EC%82%BC%20(Shilla%20Stay%20Yeoksam)&productType=-1&travellerType=0&familyMode=off'
remDr$navigate(url)
Sys.sleep(3)
pageLink <- NULL
reple <- NULL
curr_PageOldNum <- 0
repeat{
  doms <- remDr$findElements(using = "css selector", ".Review-comment-bodyText")
  Sys.sleep(1)
  reple_v <- sapply(doms, function (x) {x$getElementText()})
  print(reple_v)
  reple <- append(reple, unlist(reple_v))
  cat(length(reple), "\n")
  pageLink <- remDr$findElements(using='css', "#reviewSection > div:nth-child(6) > div > span:nth-child(3) > i ")
  remDr$executeScript("arguments[0].click();", pageLink) # JavaScript로 클릭 발생(clickElement() 메서드 보다 에러가 적다)
  Sys.sleep(2)
  
  curr_PageElem <- remDr$findElement(using='css', '#reviewSection > div:nth-child(6) > div > span.Review-paginator-numbers > span.Review-paginator-number.Review-paginator-number--current')
  curr_PageNewNum <- as.numeric(curr_PageElem$getElementText())
  cat(paste(curr_PageOldNum, ':', curr_PageNewNum,'\n'))
  
  # 마지막 페이지 체크 (다음 페이지 넘버를 읽었는데 현재 페이지넘버랑 같다면 끝내라)
  if(curr_PageNewNum == curr_PageOldNum)  {
    cat("종료\n")
    break; 
  }
  curr_PageOldNum <- curr_PageNewNum;
}
cat(length(reple), "개의 댓글 추출\n")
write(reple,"hotel.txt")
```

