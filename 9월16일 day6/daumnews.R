library(rvest)


url <- "http://media.daum.net/ranking/popular/"
html <- read_html(url, encoding="UTF-8")

# 신문사
# 전체 추출 : ul[3]/li[48] -> ul[3]/li
node1 <- html_nodes(html, xpath='//*[@id="mArticle"]/div[2]/ul[3]/li/div[2]/strong/span') 
#node1 <- html_nodes(html, ".tit_thumb span")
newspaper_name <- html_text(node1)

# 뉴스 제목
node2 <- html_nodes(html, css="#mArticle .tit_thumb .link_txt") # 추천뉴스 제외 #mAside
news_title <- html_text(node2, trim=T)

news <- data.frame(newspaper_name, news_title); View(news)
getwd(); setwd("C:/Rexam"); getwd()
write.csv(news, "daumnews.csv")

