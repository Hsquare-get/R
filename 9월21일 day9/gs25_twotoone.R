library(RSelenium)


remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445, browserName = "chrome")
remDr$open()
url <- "http://gs25.gsretail.com/gscvs/ko/products/event-goods"
remDr$navigate(url)

# 2+1 행사메뉴 클릭
twoplusone <- remDr$findElement(using="css", "#TWO_TO_ONE"); # str(twoplusone)
twoplusone$clickElement()

goodsname <- NULL; goodsprice <- NULL
prev_page_num <- 0; current_page_num <- 1
repeat {
  # 상품명 가져오기
  goodsnodes <- remDr$findElements(using='css', '#contents > div.cnt > div.cnt_section.mt50 > div > div > div:nth-child(5) > ul > li > div > p.tit')
  goodsname_onepage <- sapply(goodsnodes, function(x) {x$getElementText()})
  goodsname_onepage <- unlist(goodsname_onepage)
  print(goodsname_onepage)
  goodsname <- c(goodsname, goodsname_onepage)
  
  # 상품가격 가져오기
  goodsnodes <- remDr$findElements(using='css', '#contents > div.cnt > div.cnt_section.mt50 > div > div > div:nth-child(5) > ul > li > div > p.price > span')
  goodsprice_onepage <- sapply(goodsnodes, function(x) {x$getElementText()})
  goodsprice_onepage <- unlist(goodsprice_onepage)

  # 가격 데이터 가공
  processed_goodsprice <- NULL
  for (price in goodsprice_onepage) {
    price <- gsub(",", "", price)
    price <- gsub("원", "", price)
    processed_goodsprice <- c(processed_goodsprice, as.numeric(price))
  }
  print(processed_goodsprice)
  goodsprice <- c(goodsprice, processed_goodsprice)
  
  # 다음버튼 클릭
  next_button <- remDr$findElement(using="css", "#contents > div.cnt > div.cnt_section.mt50 > div > div > div:nth-child(5) > div > a.next")
  next_button$clickElement()
  Sys.sleep(3)
  
  # 현재페이지 확인
  cat(current_page_num, "/ 102", "\n")
  current_page <- remDr$findElement(using='css', "#contents > div.cnt > div.cnt_section.mt50 > div > div > div:nth-child(5) > div > span > a.on")
  current_page_num <- as.numeric(current_page$getElementText())
  
  # 마지막 페이지 판단
  if(current_page_num == prev_page_num) {
    cat("종료", "\n")
    break
  }
  
  prev_page_num <- current_page_num;
  
}

goodsname; goodsprice
df <- data.frame(goodsname, goodsprice); df

getwd()
write.csv(df, "gs25_twotoone.csv")
