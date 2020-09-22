library(RSelenium)


remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445, browserName = "chrome"); str(remDr)
remDr$open() # remDr 리스트로 만들어진 객체 (빈 창이 안뜨면 서버를 죽였다가 다시 실행)
url <- "https://hotel.naver.com/hotels/item?hotelId=hotel:Shilla_Stay_Yeoksam&destination_kor=%EC%8B%A0%EB%9D%BC%EC%8A%A4%ED%85%8C%EC%9D%B4%20%EC%97%AD%EC%82%BC&rooms=2"
remDr$navigate(url)


##### 리뷰 동적크롤링 #####
reviews_all <- NULL
repeat {
  # 댓글 읽어오기 전에 먼저 너무 긴 댓글은 생략되어있어서 모든 +버튼을 클릭부터 다 해놓는다
  for (i in 1:4) {
    more_button <- remDr$findElement(using ="css", paste0("li:nth-child(",i,") > div.review_desc > p > span"))
    more_button$clickElement() # 클릭수행
    
    # 한 페이지의 리뷰 가져오기
    reviews_element <- remDr$findElements(using='css', "div.review_desc > p"); reviews_element
    reviews_onepage <- sapply(reviews_element, function(x){x$getElementText()})
  }
  
  print(reviews_onepage)
  reviews_all <- append(reviews_all, unlist(reviews_onepage))
  
  # 다음버튼 누르기
  next_button <- remDr$findElement(using='css', "div.review_ta.ng-scope > div.paginate > a.direction.next")
  # str(next_button), next_button은 데이터프레임
  next_button$clickElement()
  Sys.sleep(2)
  
  # 마지막 페이지 판단
  if (next_button$getElementAttribute("class") == "direction next disabled") {
    reviews_all <- append(reviews_all, unlist(reviews))
    break
  }
}

reviews_all
getwd()
write(reviews_all, "naverhotel.txt")



