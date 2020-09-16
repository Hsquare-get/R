library(rvest)


partial_comic<-NULL; total_comic<-NULL
i<-1
while (TRUE) {
  url <- paste0("https://comic.naver.com/genre/bestChallenge.nhn?&page=",i) # ?&page=300 주면 알아서 마지막 페이지로 이동
  html <- read_html(url, encoding="UTF-8")
  
  comicName<-NULL; comicSummary<-NULL; comicGrade<-NULL
  
  # 만화 이름
  node1 <- html_nodes(html, css=".challengeInfo > h6 > a")
  partial_comicName <- html_text(node1, trim=T)
  comicName <- c(comicName, partial_comicName)
  
  # 만화 소개
  node2 <- html_nodes(html, css=".challengeInfo > div.summary")
  partial_comicSummary <- html_text(node2, trim=T)
  comicSummary <- c(comicSummary, partial_comicSummary)
  
  # 만화 평점
  node3 <- html_nodes(html, css=".challengeInfo > div.rating_type > strong")
  partial_comicGrade <- html_text(node3, trim=T)
  comicGrade <- c(comicGrade, partial_comicGrade)
  
  i <- i+1
  
  partial_comic <- data.frame(comicName, comicSummary, comicGrade)
  total_comic <- rbind(total_comic, partial_comic)
  
  # 다음 버튼이 없는 것으로 마지막 페이지 체크
  node0 <- html_node(html, css="#content > div.paginate > div > a.next > span.cnt_page")
  if (is.na(node0)) break

}

View(total_comic)
getwd(); setwd("C:/Rexam"); getwd()
write.csv(total_comic, "navercomic.csv")





