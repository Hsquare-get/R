# 정적 웹사이트 위키피디아의 테이블을 한번에 읽어오기
library(XML)
library(rvest)
library(dplyr)

# MBC 그남자의기억법 날짜별 시청률 from 위키피디아
url = "https://ko.wikipedia.org/wiki/%EA%B7%B8_%EB%82%A8%EC%9E%90%EC%9D%98_%EA%B8%B0%EC%96%B5%EB%B2%95"
html <- read_html(url) # XML::read_html
parse <- htmlParse(html) # XML::htmlParse
wiki_table <- getNodeSet(parse, "//table")[[2]]
MM_table <- readHTMLTable(wiki_table); MM_table
str(MM_table); View(MM_table) # df

# 방영일자별 시청률 가져오기
d <- MM_table$V2[seq(4,34, 2)]; d
d <- gsub("[가-힣]", "", d); d
d <- as.Date(d, "%m %d"); d

#MM_table[[4]][4]; MM_table[[3]][5]
#MM_table[[4]][6]; MM_table[[3]][7]
#MM_table[[4]][8]; MM_table[[3]][9]
#...
#MM_table[[4]][34]; MM_table[[3]][35]

vr <- c()
for (i in seq(4,34, 2)){
  vr <- c(vr, c(MM_table[[4]][i]))
  vr <- c(vr, c(MM_table[[3]][i+1]))
}
vr
vr <- gsub("%", "", vr)
vr <- as.numeric(vr)

# 날짜열 붙이기
seqday <- as.character(d)
strsp <- unlist(strsplit(seqday, split="-")); strsp

# yyyy-mm-dd 형태의 날짜를 yyyymmdd 형태로 만드는 과정
date <- 0
for(i in seq(1, (length(strsp)-2), 3)){
  paste_date <- paste(strsp[i], strsp[i+1], strsp[i+2], sep = "")
  date <- c(date, paste_date)
}
date <- date[-1] # 첫번째 "0" 제외
date <- c(date, date) # 32회차의 시청률에 cbind할 수 있도록 32개의 행 완성
date <- as.numeric(date) # 정렬하기위해 numeric변환
date <- sort(date)
date <- as.character(date) # 날짜데이터로 읽기위해 다시 character변환

MM_dataset <- data.frame(day=date, view_rating=vr); str(MM_dataset) # 초기 시청률 df
View(MM_dataset)


# 평일 데이터만 남기기
day <- as.Date(MM_dataset$day, "%Y%m%d"); str(day)
yoil <- format(day, "%a"); str(yoil); tail(yoil)

MM_dataset <- MM_dataset %>% mutate(yoil=yoil); View(MM_dataset)


# 데이터셋에 회차(기승전결, 드라마 진행척도)
story_step <- 1:32
for (i in 1:length(story_step)){
  if ((i %/% (length(story_step)/4))+1 == 1){
    story_step[i] <- "기"
  } else if ((i %/% (length(story_step)/4))+1 == 2){
    story_step[i] <- "승"
  } else if ((i %/% (length(story_step)/4))+1 == 3){
    story_step[i] <- "전"
  } else if ((i %/% (length(story_step)/4))+1 == 4){
    story_step[i] <- "결"
  } else if ((i %/% (length(story_step)/4))+1 == 5){
    story_step[i] <- "결"
  }
}
story_step

# 데이터셋에 방송사, 프로그램명, 날짜, 방송요일 , 방송시간, 회차(드라마진행도) cbind하기
MM_dataset <- cbind(MM_dataset,
                    broadcast_station="MBC",
                    program="그남자의기억법",
                    time="22",
                    story_step=story_step)
View(MM_dataset)


# 드라마 방영시간 날씨데이터 불러오기
getwd(); setwd("C:/Rexam/tvcrawling"); getwd()
wheather_data_raw <- read.csv("seoul wheather(time).csv")
str(wheather_data_raw)
wheather_data <- wheather_data_raw %>% rename(time=일시, temp=기온..C., rain=강수량.mm.) %>% select(time, temp, rain) 

# 일강수량, 강수계속시간 결측치NA 0으로 설정
table(is.na(wheather_data$rain)) # 5020개의 데이터가 NA
rain_processed <- ifelse(is.na(wheather_data$rain), 0, wheather_data$rain)

wheather_data <- wheather_data %>% mutate(rain_processed=rain_processed)

wheather_data <- wheather_data %>% select(time, temp, rain_processed) %>% 
  filter(substr(time, 12,16)=="21:00" | substr(time, 12,16)=="22:00")
str(wheather_data)

wheather_data$time <- strptime(wheather_data$time, "%Y-%m-%d %H:%M")
wheather_data <- wheather_data %>% filter(time >= strptime("2020-03-18", "%Y-%m-%d") & time < strptime("2020-05-14", "%Y-%m-%d"))

yoil <- format(wheather_data$time, "%a"); str(yoil); tail(yoil)
wheather_data <- wheather_data %>% mutate(yoil=yoil)
wheather_data <- wheather_data %>% filter(yoil == "수" | yoil == "목")
View(wheather_data)

# 결방한 날짜는 제외하기
wheather_data <- wheather_data %>% mutate(i=c(1:34))
wheather_data <- wheather_data %>% filter(i != 17 & i != 18)

# 날씨데이터 MM_dataset에 cbind하기
temp <- wheather_data$temp
rain <- wheather_data$rain_processed

MM_dataset <- cbind(MM_dataset, temp=temp, rain=rain)
View(MM_dataset)

# 주말여부(휴일) 변수 추가
MM_dataset <- MM_dataset %>% mutate(weekend=ifelse(yoil=="토" | yoil=="일", "Y", "N"))

# 일일유동인구(서울 지하철 승하차인원수) & 이전회차 시청률(or 전작품 평균시청률)
MM_dataset <- MM_dataset %>% mutate(floating_population=NA, pre_view_rating=NA)


MM_dataset <- MM_dataset %>% select(broadcast_station, program, day, yoil, weekend, time, story_step,
                                    temp, rain, floating_population, pre_view_rating, view_rating)

View(MM_dataset)
getwd(); setwd("C:/Rexam/tvcrawling"); getwd()
write.csv(MM_dataset, file="MM.csv")
