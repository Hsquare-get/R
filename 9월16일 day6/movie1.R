library(rvest)
text<-NULL; vpoint<-NULL; vreview<-NULL
url <- "https://movie.daum.net/moviedb/grade?movieId=131576"
#url <- "https://movie.daum.net/moviedb/grade?movieId=131576&type=netizen&page=2"
text <- read_html(url, encoding="UTF-8"); text

for (i in 1:10) {
  # 고객평점
  node1 <- html_nodes(text, paste0("#mArticle > div.detail_movie.detail_rating > div.movie_detail > div.main_detail > ul > li:nth-child(",i,") > div > div.raking_grade > em"))
  point <- html_text(node1)
  vpoint[i] <- point
  
  # 리뷰
  node2 <- html_nodes(text, paste0("li:nth-child(",i,") > div > p"))
  review <- html_text(node2, trim=T)
  vreview <- append(vreview, review) # append(벡터, values=추가할 값, after=추가될 위치)
}

page <- data.frame(vpoint, vreview); View(page)
getwd()
write.csv(page, "daummovie1.csv")

