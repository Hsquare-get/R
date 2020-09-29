library(dplyr)
library(ggplot2)

# [문제1]
str(ggplot2::mpg)
mpg <- as.data.frame(ggplot2::mpg)

str(mpg)
nrow(mpg); ncol(mpg); dim(mpg)
head(mpg, n=10)
tail(mpg, n=10)
View(mpg)
mpg %>% summary() # summarise는 수치형 데이터에 대한 요약 통계량 제공
mpg %>% group_by(manufacturer) %>% count()
mpg %>% group_by(manufacturer, model) %>% summarise(n=n())
#mpg %>% group_by(manufacturer, model) %>% tally()


# [문제2]
# 복사본 데이터를 이용하여 cty, hwy 변수명 수정
mpg <- mpg %>% rename(city=cty, highway=hwy)
mpg %>% slice(5:10)


# [문제3]
midwest <- as.data.frame(ggplot2::midwest)
# 3-1
str(midwest); head(midwest)
# 3-2
midwest <- midwest %>% rename(total=poptotal, asian=popasian)
str(midwest)
# 3-3
midwest <- midwest %>% mutate(asian_rate=(asian/total)*100)
# 3-4
midwest %>% summarise(asian_mean_rate=(sum(asian)/sum(total)*100)) -> asian_mean_rate
midwest %>% mutate(over_mean = ifelse(asian_rate > asian_mean_rate, "large", "small"))


# [문제4]
mpg <- as.data.frame(ggplot2::mpg)
str(mpg); View(mpg)

# 4-1
displ_under4 <- mpg %>% filter(displ <= 4) %>% summarise(mean_hwy = mean(hwy)) # 25.96
displ_over5 <- mpg %>% filter(displ >= 5) %>% summarise(mean_hwy = mean(hwy)) # 18.07
cat("배기량 4이하 자동차의 고속도로 연비 평균은", displ_under4[[1]], "이고,",
    "배기량 5이상 자동차의 고속도로 연비 평균은", displ_over5[[1]], "이다", "\n")

# 4-2
mpg %>%
  filter(manufacturer %in% c("audi", "toyota")) %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty = mean(cty))
mpg %>% filter(manufacturer=="audi") %>% summarise(mean_cty = mean(cty)) # 17.61
mpg %>% filter(manufacturer=="toyota") %>% summarise(mean_cty = mean(cty)) # 18.52

# 4-3
mpg %>% 
  filter(manufacturer %in% c("chevrolet","ford","honda")) %>% 
  group_by(manufacturer) %>% 
  summarise(mean_hwy=mean(hwy))
mpg %>% filter(manufacturer=="chevrolet") %>% summarise(mean_hwy = mean(hwy)) # 21.89
mpg %>% filter(manufacturer=="ford") %>% summarise(mean_hwy = mean(hwy)) # 19.36
mpg %>% filter(manufacturer=="honda") %>% summarise(mean_hwy = mean(hwy)) # 32.55
mpg %>% 
  filter(manufacturer=="chevrolet" | manufacturer=="ford" | manufacturer=="honda") %>% 
  summarise(mean_hwy = mean(hwy)) # 23.44 3개 제조사의 고속도로 연비평균


# [문제5]
mpg <- as.data.frame(ggplot2::mpg)
str(mpg); head(mpg)

# 5-1
new_mpg <- mpg %>% select(class, cty); head(new_mpg)

# 5-2
new_mpg %>% 
  filter(class %in% c("suv","compact")) %>% 
  group_by(class) %>% 
  summarise(mean_cty=mean(cty))
new_mpg %>% filter(class=="suv") %>% summarise(mean_cty = mean(cty)) # 13.5
new_mpg %>% filter(class=="compact") %>% summarise(mean_cty = mean(cty)) # 20.12


# [문제6]
mpg <- as.data.frame(ggplot2::mpg)
str(mpg); head(mpg)
View(mpg)
mpg %>% filter(manufacturer=="audi") %>% arrange(desc(hwy)) %>% head(5)
