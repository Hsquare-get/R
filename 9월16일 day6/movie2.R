library(rvest) # import

page<-NULL; movie.review<-NULL
for (i in 1:5) {
  url <- paste0("https://movie.daum.net/moviedb/grade?movieId=131576&type=netizen&page=",i)
  text <- read_html(url, encoding="UTF-8")
  
  # 평점
  node1 <- html_nodes(text, ".emph_grade") # html_nodes(text, ".raking_grade > .emph_grade")
  point <- html_text(node1) # 평점 하나씩 꺼내온게 아니라 전체를 꺼내온 것
  
  # 리뷰글
  node2 <- html_nodes(text, ".desc_review")
  review <- html_text(node2, trim=T)
  
  page <- data.frame(point, review)
  movie.review <- rbind(movie.review, page)
}

View(movie.review)
getwd()
write.csv(movie.review, "daummovie2.csv")