library(dplyr)
library(ggplot2)

# [문제7]
mpg <- as.data.frame(ggplot2::mpg)
str(mpg); head(mpg)

# 7-1 합산연비 변수 추가
mpg_copy <- mpg %>% mutate(total_fe=hwy+cty); mpg_copy

# 7-2 평균연비 변수 추가
mpg_copy <- mpg_copy %>% mutate(mean_fe=total_fe/2)

# 7-3 평균연비가 높은순
mpg_copy %>% arrange(desc(mean_fe)) %>% head(3)

# 7-4 (7-1,2,3 한번에 해결)
mpg %>% 
  mutate(total_fe=hwy+cty, mean_fe=total_fe/2) %>% 
  arrange(desc(mean_fe)) %>% head(3)


# [문제8]
mpg <- as.data.frame(ggplot2::mpg)
str(mpg); head(mpg)

# 8-1 class별 cty 평균
mpg %>% group_by(class) %>% summarise(mean_cty=mean(cty))

# 8-2 cty 평균이 높은순
mpg %>% group_by(class) %>% summarise(mean_cty=mean(cty)) %>% arrange(desc(mean_cty))

# 8-3 hwy 평균이 높은순
tibb <- mpg %>% group_by(manufacturer) %>% summarise(mean_hwy=mean(hwy)) %>% arrange(desc(mean_hwy)) %>% head(3)
tibb[,1]

# 8-4 각 제조사(회사)별 compact 차종 수의 내림차순 
mpg %>% group_by(manufacturer) %>% filter(class=="compact") %>% count(class) %>% arrange(desc(n))


# [문제9]
mpg <- as.data.frame(ggplot2::mpg)
str(mpg); head(mpg)
View(mpg)

fuel <- data.frame(fl = c('c','d','e','p','r'), 
                   price_fl = c(2.35, 2.38, 2.11, 2.76, 2.22))
str(fuel); head(fuel)

# 9-1 fl열을 기준으로 왼쪽 mpg 데이터프레임에 fuel 데이터프레임을 병합
mpg <- left_join(mpg, fuel, by="fl"); mpg

# 9-2 model, fl, price_fl 변수 추출
mpg %>%  select(model, fl, price_fl) %>% head(5)


# [문제10]
midwest <- as.data.frame(ggplot2::midwest)
str(midwest); head(midwest)

# 10-1 전체인구 대비 미성년인구 백분율
midwest <- midwest %>% mutate(non_adults_rate = (1-(popadults/poptotal))*100); midwest

# 10-2 미성년 인구 백분율이 높은 상위 5개 county지역의 미성년 인구 백분율
midwest %>% arrange(desc(non_adults_rate)) %>% select(county, non_adults_rate) %>% head(5)

# 10-3 미성년 비율 등급 변수를 추가하고, 각 등급에 몇개의 지역이 있는지 확인
midwest <- midwest %>% mutate(grade=ifelse(non_adults_rate >= 40, "large", 
                                ifelse(non_adults_rate >= 30, "middle", "small")))
midwest %>% group_by(grade) %>% count()

# 10-4 하위 10개 지역의 state, county, 아시아인 인구 백분율
midwest %>% mutate(asian_rate = (popasian/poptotal)*100) %>% 
  arrange(asian_rate) %>% select(state, county, asian_rate) %>% head(10)


# [문제11]
??mpg
mpg <- as.data.frame(ggplot2::mpg)
table(is.na(mpg)) # 결측치 개수 세기
mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA # df[행,열] <- NA
table(is.na(mpg)) # 결측치 개수 세기
str(mpg); head(mpg)

# 11-1 drv와 hwy 변수의 결측치 개수
table(is.na(mpg$drv))
table(is.na(mpg$hwy))
mpg %>% select(drv) %>% filter(is.na(drv)) %>% count # 0
mpg %>% select(hwy) %>% filter(is.na(hwy)) %>% nrow # 5

# 11-2 어떤 구동방식의 hwy 평균이 높은지 확인
mpg %>% filter(!is.na(hwy)) %>% group_by(drv) %>% summarise(mean_hwy = mean(hwy)) %>% 
  arrange(desc(mean_hwy))

# [문제12]
mpg <- as.data.frame(ggplot2::mpg)
mpg[c(10, 14, 58, 93), "drv"] <- "k" # 이상치 할당
mpg[c(29, 43, 129, 203), "cty"] <- c(3,4,39,42) # 이상치 할당

# 12-1 drv 이상치를 결측처리
table(mpg$drv) # drv 이상치 확인
# mpg$drv <- ifelse(mpg$drv %in% c("k"), NA, mpg$drv)
mpg[mpg$drv == "k", "drv"] = NA; mpg
mpg <- subset(mpg, drv %in% c("4", "f", "r")) # 결측치 제거

table(mpg$drv) # 이상치의 결측처리 확인

# 12-2 cty 이상치를 결측처리후 
table(mpg$cty) # cty 이상치를 제대로 확인할 수 없다
boxplot(mpg$cty)
boxplot(mpg$cty)$stats

mpg$cty <- ifelse(mpg$cty < 9 | mpg$cty > 26, NA, mpg$cty)
boxplot(mpg$cty)

# 12-3 이상치 제외 후 drv별 cty 평균
table(is.na(mpg$cty)) # 결측치 9개
mpg %>% filter(!is.na(cty)) %>% group_by(drv) %>% summarise(mean_cty = mean(cty, na.rm=T))
