library(rvest)

page<-NULL; movie.review<-NULL
i<-1
while (TRUE) {
  url <- paste0("https://movie.daum.net/moviedb/grade?movieId=131576&type=netizen&page=",i)
  text <- read_html(url, encoding="UTF-8")
  
  # 방법1 : 마지막 페이지를 가보고 없는 페이지 11을 가보고 html_nodes의 length()==0으로 체크
  # 방법2 : 총 댓글수를 99개로 확인할 수 있으니, 총페이지 수 = '99%%10 + 1'
  # 없는 페이지는 html_nodes가 {xml_nodeset (0)} return, length()==0 확인
  node0 <- html_nodes(text, ".emph_grade"); node0
  if (length(node0)!=0) {
  
    # 평점
    node1 <- html_nodes(text, ".emph_grade")
    point <- html_text(node1)
    
    # 리뷰글
    node2 <- html_nodes(text, ".desc_review")
    review <- html_text(node2, trim=T)
    
    page <- data.frame(point, review)
    movie.review <- rbind(movie.review, page)
    
    i <- i+1
  }
  else
    break
}

View(movie.review)
getwd()
write.csv(movie.review, "daummovie3.csv")


