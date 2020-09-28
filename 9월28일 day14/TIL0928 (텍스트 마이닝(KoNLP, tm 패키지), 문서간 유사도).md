# TIL0928 (텍스트 마이닝(KoNLP, tm 패키지), 문서간 유사도)

## (1) 텍스트 마이닝 - <span style="color:red;">KoNLP 패키지</span>

> 텍스트 마이닝은 단어의 출현 빈도, 단어간 관계성 등을 파악하여 유의미한 정보를 추출하는 것이다. 이는 '자연어 처리 기술(NLP)'을 기반으로 하고 있다.

> **자연어 NLP**
>
> 일상생활에서 사용하는 말, 언어이다. 한국어는 어순이나 조사 등을 영어처럼 명확하게 끊어지지 않는 부분이 있다. 자연어 처리는 사람이 작성한 글이나 대화를 형태소분석기, 구문분석기와 같은 컴퓨터를 통해 해설할 수 있게 하는 소프트웨어를 개발하거나 연구하고 그것을 실제로 이용해서 작업하는 것을 말한다.
>
> 형태소분석기 : 형태소를 구분하고 무엇인지 알려주는 것
>
> 구문분석기 : 주어, 목적어, 서술어와 같은 형태로, 품사보다는 단위가 더 높은 논리적 레벨까지 처리해주는것



```R
# 한국어 형태소 분석 패키지 설치
# Rtools 설치 # windows 운영체제는 Rtools를 설치해야한다(기존에 있었다면 삭제후 재설치)
# https://cran.r-project.org/bin/windows/Rtools/index.html
install.packages("Sejong")
install.packages("hash")
install.packages("tau")
install.packages("RSQLite")
install.packages("devtools")

# github 버전 설치
install.packages("remotes")
# 64bit 에서만 동작합니다.
remotes::install_github('haven-jeon/KoNLP', upgrade = "never", INSTALL_opts=c("--no-multiarch"))
```

```R
library(KoNLP)
useSejongDic() # 세종사전을 구성(이용하겠다)

extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다")
SimplePos09("대한민국의 영토는 한반도와 그 부속도서로 한다")
SimplePos22("대한민국의 영토는 한반도와 그 부속도서로 한다")

# extractNoun() 명사 추출
word_data <- readLines("data/애국가(가사).txt"); word_data
#word_data2 <- sapply(word_data, extractNoun); word_data2 # 'USE.NAMES=F' 없으면 원래 문자열와 추출된 명사가 같이 나온다
word_data2 <- sapply(word_data, extractNoun, USE.NAMES = F); word_data2
word_data3 <- extractNoun(word_data); word_data3

# 명사처리가 제대로 안됐으면 명사를 새로이 세종사전에 등록할 수도 있다
add_words <- c("백두산", "남산", "철갑", "가을", "달")
buildDictionary(user_dic=data.frame(add_words, rep("ncn", length(add_words))), replace_usr_dic=T) # df(추가할 단어, 품사, 이미 있더라도 대체)

word_data3 <- extractNoun(word_data); word_data3
undata <- unlist(word_data3); undata

# 단어의 개수(빈도수) 세기
word_table <- table(undata); word_table
undata2 <- Filter(function(x) {nchar(x) >= 2}, undata); undata2
word_table2 <- table(undata2); word_table2
final <- sort(word_table2, decreasing = T); head(final, 10)
```



```R
##### 워드 클라우드 #####
install.packages("wordcloud")
install.packages("wordcloud2")
library(wordcloud) # 정적 워드클라우드
library(wordcloud2) # 동적 워드클라우드(html로 만들어진다)

(words <- read.csv("data/wc.csv"))
head(words)
?windowsFonts
windowsFonts(lett=windowsFont("휴먼옛체")) # 내장글씨체로 설정
wordcloud(words$keyword, words$freq) # min.freq=3(default)
wordcloud(words$keyword, words$freq, family="lett")
wordcloud(words$keyword, words$freq, 
          min.freq = 8, 
          random.order = F, # 빈도수가 가장 큰 값을 가운데로 배치(default=T, 랜덤배치)
          rot.per = 0.5, scale = c(4, 1), # 회전된 단어비율이 절반
          colors = rainbow(7))


wordcloud2(words, fontFamily = "휴먼옛체")
wordcloud2(words, rotateRatio = 1)
wordcloud2(words, rotateRatio = 0.5) # 절반만 회전시킴
wordcloud2(words, rotateRatio = 0)
wordcloud2(words, size=0.5, col="random-dark")
wordcloud2(words, size=0.5, col="random-dark", figPath="data/flight.png")
wordcloud2(words, size=0.7, col="random-light", backgroundColor = "black")

# demoFreq 내장데이터셋
str(demoFreq); head(demoFreq)
wordcloud2(data = demoFreq)
wordcloud2(data = demoFreq, figPath="data/flight.png")
wordcloud2(data = demoFreq, shape = 'diamond')
wordcloud2(data = demoFreq, shape = 'star')
wordcloud2(data = demoFreq, shape = 'cardioid')
wordcloud2(data = demoFreq, shape = 'triangle-forward')
wordcloud2(data = demoFreq, shape = 'triangle')

# html 파일로 저장
# wordcloud의 이미지는 dev.copy로 저장하면되지만 wordcloud2는 html로 저장할 수 있다
library(htmlwidgets)
result <- wordcloud2(data = demoFreq, shape = 'pentagon')
saveWidget(result, "tmpwc.html", selfcontained = F)
```



```R
# 트위터 글 워드클라우드
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
key <- enc2utf8(key)
result <- search_tweets(key, n=100, token = twitter_token)
str(result)
content <- result$retweet_text
content <- gsub("[[:lower:][:upper:][:digit:][:punct:][:cntrl:]]", "", content)   
content <- gsub("취업", "", content)  
word <- extractNoun(content)
cdata <- unlist(word)
cdata

cdata <- Filter(function(x) {nchar(x) < 6 & nchar(x) >= 2} ,cdata)
wordcount <- table(cdata)
wordcount <- head(sort(wordcount, decreasing=T),30)

par(mar=c(1,1,1,1))
wordcloud(names(wordcount), freq=wordcount, scale=c(3,0.5), rot.per=0.35, min.freq=1,
          random.order=F, random.color=T, colors=rainbow(20))
word_table <- table(wordcount)

wordcloud2(wordcount, fontFamily = "맑은고딕", size=0.5,
           color="random-light", backgroundColor="black")

wordcloud2(scale(wordcount, center=F, scale=T), fontFamily = "맑은고딕", size=0.5,
           color="random-light", backgroundColor="black")
```



## (2) 텍스트 마이닝 - <span style="color:red;">tm 패키지</span>

> 텍스트는 비정형 데이터로서 데이터 정제 작업이 필요하다. tm 패키지에는 텍스트 데이터의 정제작업을 지원하는 다양한 변환함수를 제공한다.

> **Corpus**
>
> 텍스트 마이닝 패키지인 tm에서 문서를 관리하는 기본구조를 Corpus(말뭉치)라 하며, *텍스트 문서들의 집합*을 의미한다.
>
> 
>
> 텍스트 마이닝을 위해 수행해야할 첫번째 작업은 비구조화된 텍스트, 즉 **비정형 텍스트를 구조화된 데이터로 변환**하는 것이다. corpus 접근법이 일반적으로 사용되는데 이는 분석 대상이 되는 **개별 텍스트 즉 문서(document)를 단어의 집합(주머니)으로 단순화**시킨 표현 방법으로서 단어의 순서나 문법은 무시하고 단어의 출현 빈도수만을 이용하여 텍스트를 매트릭스로 표현한다. 이 때 생성되는 매트릭스를 **term-document matrix(TDM)** 또는 **document-term matrix(DTM)**이라고 한다.
>
> 
>
> 분석해야할 텍스트를 문서들의 집합인 **corpus 객체로 변환**해야한다. **tm 패키지의 Corpus() 함수**를 사용한다. getSources() 함수를 사용하면 사용가능한 소스객체의 종류를 파악할 수 있다.

![corpus](https://user-images.githubusercontent.com/64063767/94416648-10a92f00-01ba-11eb-99e7-e0060213b7b6.jpg)

```R
# getTransformations(), 사용가능한 변환함수의 리스트를 확인가능하고 
# 이 함수들은 tm_map() 함수에 인수로 전달하여 변환작업을 처리할 수 있다
getTransformations()
>>> 'removeNumbers', 'removePunctuation', 'removeWords', 'stemDocument', 'stripWhitespace'

tm_map(
    x, # corpus
    FUN # 변환에 사용할 함수
    )

corp2 <- tm_map(corp1, stripWhitespace) # 여러 개의 공백을 하나의 공백으로 변환
corp2 <- tm_map(corp2, removeNumbers) # 숫자 제거
corp2 <- tm_map(myCorpus, content_transformer(tolower)) # 영문 대문자를 소문자로 변환
corp2 <- tm_map(corp2, removePunctuation) # .,;: 등 문자 제거

corp2 <- tm_map(corp2, PlainTextDocument) # Corpus 객체이기 때문에 다시 일반문서로 변환
stopword2 <- c(stopwords('en'), "and", "but") # 기본 불용어 외에 불용어로 쓸 단어 추가
corp2 <- tm_map(corp2, removeWords, stopword2) # 불용어 제거 (전치사, 관사 등)
```



```R
### tm 패키지를 이용한 텍스트 마이닝 예제1 ###
install.packages("tm")
library(tm)

getSources() 
>>> 'DataframeSource', 'DirSource', 'URISource', 'VectorSource', 'XMLSource', 'ZipSource'

lunch <- c("커피 파스타 치킨 샐러드 아이스크림",
           "커피 우동 소고기김밥 귤",
           "참치김밥 커피 오뎅",
           "샐러드 피자 파스타 콜라",
           "티라무슈 햄버거 콜라",
           "파스타 샐러드 커피"
)

cps <- VCorpus(VectorSource(lunch))
tdm <- TermDocumentMatrix(cps, # control로 default 3음절 이상을 1음절 이상으로 변경
                          control=list(wordLengths = c(1, Inf)))
tdm
m <- as.matrix(tdm); m

rowSums(m)
colSums(m)
```

![asmatrix](https://user-images.githubusercontent.com/64063767/94417716-616d5780-01bb-11eb-840e-9afc23f46b09.png)

![co-occurrence](https://user-images.githubusercontent.com/64063767/94417635-47cc1000-01bb-11eb-9b74-6684ca568dc7.png)



```R
##### 단어의 연결성(collocation)을 찾는데 동시출현(Co-occurrence)이 활용 #####
# 동시출현(Co-occurrence), 한 문장,문단,텍스트 단위에서 같이 출현한 단어를 위한 행렬곱
install.packages("qgraph")
library(qgraph)

com <- m %*% t(m); com

qgraph(com, 
       labels=rownames(com), 
       diag=F, 
       layout='spring',
       edge.color='blue', 
       vsize=log(diag(com)*800))
```

![co-occurrence networks](https://user-images.githubusercontent.com/64063767/94422129-8fee3100-01c1-11eb-862f-519672414daa.png)



---



- 단어 가중치 : 문서에서 어떤 단어의 중요도를 평가하기 위해 사용되는 통계적인 수치

  - TF(Term Frequency) : 단어 빈도
  - IDF(Inverse Document Frequency) : 역문서 빈도
  - DF(Document Frequency) : 문서 빈도
  - TFIDF = TF x IDF

  > 특정 문서 내에서 단어 빈도가 높을수록, 전체 문서들엔 그 단어를 포함한 문서가 적을 수록 TFIDF 값이 높아지게 된다. 즉 문서내에서 해당 단어의 중요도는 커지게 된다.

```R
### tm 패키지를 이용한 텍스트 마이닝 예제2 ###
A <- c('포도 바나나 딸기 맥주 비빔밥 여행 낚시 떡볶이 분홍색 듀크 귤')
B <- c('사과 와인 스테이크 배 포도 여행 등산 짜장면 냉면 삼겹살 파란색 듀크 귤 귤')
C <- c('백숙 바나나 맥주 여행 피자 콜라 햄버거 비빔밥 파란색 듀크 귤')
D <- c('귤 와인 스테이크 배 포도 햄버거 등산 갈비 냉면 삼겹살 녹색 듀크')

data <- c(A,B,C,D)
cps <- Corpus(VectorSource(data))
tdm <- TermDocumentMatrix(cps, control=list(wordLengths = c(1, Inf)))

inspect(tdm)
m <- as.matrix(tdm); m
v <- sort(rowSums(m), decreasing=T); v

m1 <- as.matrix(weightTf(tdm)); m1
m2. <- as.matrix(weightTfIdf(tdm)); m2

```



---



```R
### tm 패키지를 이용한 텍스트 마이닝 예제3 ###
library(XML)
html.parsed <- htmlParse("data/TextofSteveJobs.html")
text <- xpathSApply(html.parsed, path="//p", xmlValue); text

text <- text[4:30]; text
docs <- VCorpus(VectorSource(text)); docs

toSpace <- content_transformer(function(x, pattern) {return(gsub(pattern, " ", x))})
docs <- tm_map(docs, toSpace, ":")
docs <- tm_map(docs, toSpace, ";")
docs <- tm_map(docs, toSpace, "'")

docs[[17]]$content
# "When I was 17, I read a quote that went something like:   "If you live ead$

docs <- tm_map(docs, removePunctuation) # 특수문자 제거
docs <- tm_map(docs, content_transformer(tolower)) # 소문자화
docs <- tm_map(docs, removeNumbers) # 숫자제거
docs <- tm_map(docs, removeWords, stopwords("english")) # 영어 불용어 제거
docs <- tm_map(docs, stripWhitespace) # 여러 개의 공백을 하나의 공백으로 변환
docs <- tm_map(docs, stemDocument) # 어근 추출

tdm <- TermDocumentMatrix(docs); tdm

inspect(tdm[50:60, 1:5])

termFreq <- rowSums(as.matrix(tdm))
head(termFreq)
termFreq[head(order(termFreq, decreasing=T))]

barplot(termFreq[termFreq >= 7], 
        horiz=T, las=1, cex.names=0.8, 
        col=rainbow(16), xlab="word Frequency", ylab="Words")

```

![steve state](https://user-images.githubusercontent.com/64063767/94422397-fb380300-01c1-11eb-9a42-b9515c3b1c6d.png)



```R
# tm 패키지를 활용한 숫자, 특수문자, 불용어 삭제하기
mystopwords <- readLines("data/stopwords_ko.txt", encoding="UTF-8")
text <- readLines("data/stopwords_testdata.txt", encoding="UTF-8")

docs <- Corpus(VectorSource(text)); inspect(docs)
docs <- tm_map(docs, removeNumbers); inspect(docs)
docs <- tm_map(docs, removePunctuation); inspect(docs)
docs <- tm_map(docs, removeWords, mystopwords); inspect(docs)

docs2 <- Corpus(VectorSource(text))
tdm1 <- TermDocumentMatrix(docs2, control=list(wordLengths = c(1, Inf)))
as.matrix(tdm1)
tdm2 <- TermDocumentMatrix(docs2,
                           control=list(removePunctuation = T,
                                        removeNumbers = T,
                                        wordLengths = c(1, Inf),
                                        stopwords=mystopwords))
as.matrix(tdm2)

```





## (3) 문서간 유사도 (코사인거리, 유클리드거리)

> 문서들간에 동일한 단어, 비슷한 단어가 얼마나 공통으로 많이 사용됐는지에 따라 문서간 유사도 분석을 할 수 있다. (**코사인 거리**, **유클리드 거리**)

- 코사인 유사도(Cosine Similarity)
- <span style="color:red;">코사인 거리(Cosine Distance) = 1- 코사인 유사도(Cosine Similarity)</span>

![cosine](https://user-images.githubusercontent.com/64063767/94420915-c7f47480-01bf-11eb-8315-6edcc44782bb.png)

> 두 벡터 간의 코사인 각도를 이용하여 유사도를 측정한다. 두 벡터의 값이 오나전 동일하면1, 반대방향이면 -1, 90도의 각을 이루면 0이 된다. 1에 가까울 수록 유사도가 높다.



- 유클리드 거리(Euclidean Distance)

![Euclidean](https://user-images.githubusercontent.com/64063767/94421351-61238b00-01c0-11eb-965e-8e5a805be410.png)

> 두 점 사이의 유클리드 거리 공식은 피타고라스의 정리를 통해 두 점 사이의 거리를 구하는 것과 동일하다.

```R
install.packages("proxy")
library(proxy)

dd <- NULL
d1 <- c("aaa bbb ccc")
d2 <- c("aaa bbb ddd")
d3 <- c("aaa bbb ccc")
d4 <- c("xxx yyy zzz")
dd <- c(d1, d2, d3, d4)

cps <- Corpus(VectorSource(dd))
dtm <- DocumentTermMatrix(cps)
m <- as.matrix(dtm); m
com <- m %*% t(m); com

# 코사인 거리(Cosine Distance) = 1 - 코사인 유사도(Cosine Similarity)
dist(com, method = "cosine")
# 유클리드 거리
dist(com, method = "Euclidean")

```