library(KoNLP)
library(wordcloud2)
library(htmlwidgets)
useSejongDic()

word_origin <- readLines("9월28일 day14/yes24.txt") # 벡터로 반환
head(word_origin)

word_noun <- extractNoun(word_origin) # extractNoun은 리스트로 반환
str(word_noun) # list
head(word_noun)

undata <- unlist(word_noun)
undata2 <- Filter(function(x) {nchar(x) >= 2}, undata)
word_table <- table(undata2); word_table
topic_orderd <- sort(word_table, decreasing = T)
head(topic_orderd, 15)


img_path = system.file("data/twitter.png", package = "wordcloud2") # 이미지에 채워서 표현하기
result <- wordcloud2(topic_orderd,
                     minSize = 5,
                     size = 0.5,
                     rotateRatio = 0.5,
                     figPath = img_path,
                     fontFamily = "바탕")

saveWidget(result, "wc.html", title = "WORDCLOUD 실습", selfcontained = F)
