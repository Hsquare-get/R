library(rvest)
library(XML)
library(httr)

#[OPEN API 실습1]
searchUrl <- "https://openapi.naver.com/v1/search/blog.xml"
Client_ID <- "izGsqP2exeThwwEUVU3x"
Client_Secret <- "WrwbQ1l6ZI"

query <- URLencode(iconv("맛집", "euc-kr", "UTF-8")) # euc-kr에서 UTF-8로 변환
url <- paste0(searchUrl, "?query=", query, "&display=100")
doc <- GET(url, add_headers("Content_Type" = "application/xml",
                            "X-Naver-Client-Id" = Client_ID, "X-Naver-Client-Secret" = Client_Secret))
doc # XML 형식

# 블로그 내용에 대한 리스트 만들기		
doc2 <- htmlParse(doc, encoding="UTF-8")
text <- xpathSApply(doc2, "//item/description", xmlValue); text
text <- gsub("</?b>", "", text); text

getwd(); setwd("C:/Rexam/9월17일 day7")
write.table(text, "naverblog.txt")


#[OPEN API 실습2]
packageVersion("rtweet")
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
  access_secret = access_token_secret
  )

key <- "코로나"
key <- enc2utf8(key) # CP949 -> UTF-8
result <- search_tweets(key, n=100, token = twitter_token)
str(result)
result$retweet_text
content <- result$retweet_text
content[is.na(content)] <- ""; content 
#content <- content[!is.na(content)] # 데이터가 사라져서 100개의 칸이 아니라 지워지고 85개로 남는 차이가 있다
content <- gsub("[[:punct:][:lower:][:upper:]]", "", content) # [:alpha:]는 영어중에서도 대문자, 소문자 구분해서 한글도 같이 제외됨
content # url에서 영어는 지워지고 숫자만 살아남음
write.table(content, "twitter.txt")

#[OPEN API 실습3]
library(XML)
API_key  <- "%2BjzsSyNtwmcqxUsGnflvs3rW2oceFvhHR8AFkM3ao%2Fw50hwHXgGyPVutXw04uAXvrkoWgkoScvvhlH7jgD4%2FRQ%3D%3D"
bus_No <- "360"
url <- paste("http://ws.bus.go.kr/api/rest/busRouteInfo/getBusRouteList?ServiceKey=", API_key, "&strSrch=", bus_No, sep="")
# URL : http://ws.bus.go.kr/api/rest/busRouteInfo/getBusRouteList?ServiceKey=%2BjzsSyNtwmcqxUsGnflvs3rW2oceFvhHR8AFkM3ao%2Fw50hwHXgGyPVutXw04uAXvrkoWgkoScvvhlH7jgD4%2FRQ%3D%3D&strSrch=360
doc <- xmlParse(url, encoding="UTF-8")
top <- xmlRoot(doc) # 최상위 태그부터
top
df <- xmlToDataFrame(getNodeSet(doc, "//itemList")) # 태그명이 컬럼명으로 변환
df
str(df)
View(df)

#[360번 버스정보]
busRouteId <- df$busRouteId[1] # 노선ID
cat(paste0("노선ID : ", busRouteId), "\n")

length <- df$length[1] # 노선 길이
cat(paste0("노선길이 : ", length, " km"), "\n")

stStationNm <- df$stStationNm[1] # 기점
cat(paste0("기점 : ", stStationNm), "\n")

edStationNm <- df$edStationNm[1] # 종점
cat(paste0("종점 : ", edStationNm), "\n")

term <- df$term[1] # 배차간격
cat(paste0("배차간격 : ", term, " 분"), "\n")

#[OPEN API 실습4]
# 네이버 뉴스 연동
library(jsonlite)
searchUrl<- "https://openapi.naver.com/v1/search/news.json"
Client_ID <- "izGsqP2exeThwwEUVU3x"
Client_Secret <- "WrwbQ1l6ZI"
query <- URLencode(iconv("빅데이터","euc-kr","UTF-8"))
url <- paste0(searchUrl, "?query=", query, "&display=100")
doc <- GET(url, add_headers("Content_Type" = "application/json",
                            "X-Naver-client-Id" = Client_ID, "X-Naver-Client-Secret" = Client_Secret))
doc # Json 형식

# 뉴스 제목
json_data <- content(doc, type = "text", encoding="UTF-8")
json_obj <- fromJSON(json_data)
text <- json_obj$items$title

text <- gsub("</?b>", "", text)
text <- gsub("&.+t;", "", text)
text
View(text)
getwd(); # C:/Rexam/9월17일 day7
write.table(text, "navernews.txt")
