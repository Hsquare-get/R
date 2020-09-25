# TIL0925 (데이터전처리(dplyr), 데이터정제(결측치,이상치))

## (1) 데이터 전처리 - <span style="color:red;">dplyr 패키지</span>

> <span style="color:red;">Python</span>에서 DataFrame을 다루는 <span style="color:red;">`Pandas` </span>패키지가 있다면 
>
> <span style="color:red;">R</span>에서는 data.frame을 다루기 위한 <span style="color:red;">`dplyr` </span> 패키지가 있다.

---

> <span style="color:red;">데이터프레임에 담겨진 데이터들의 전처리</span>에 가장 많이 사용되는 R 패키지이다.
>
> 데이터를 빨리 쉽게 가공할 수 있도록 도와주는 패키지로서 유연한 데이터 조작문법을 제공하고 C언어로 만들어서 매우 빠르다.

---

| function (%>% 있으면 df전달 안해도됨)          | mean                                          |
| ---------------------------------------------- | --------------------------------------------- |
| filter(df, class == 1)                         | 조건에 맞는 행을 반환하는 함수                |
| slice(df, 5:10)                                | 슬라이싱해서 행을 추출                        |
| arrange(df, desc(math))                        | 행을 정렬해주는 함수                          |
| select(df, class, math, english)               | 열을 선택하는 함수                            |
| rename(df, new_name=old_name)                  | 열 이름을 변경해주는 함수                     |
| distinct(df, var1, var2, ...)                  | 중복없는 유일한 행 추출                       |
| sample_n(df, n)                                | 무작위 표본 행 추출                           |
| sample_n(df, n, replace=T)                     | 무작위 복원 행 추출                           |
| sample_frac(df, ratio)                         | 특정 비율만큼 무작위 행 추출                  |
| mutate(df, total=math+english+science)         | 새로운 파생 변수(열) 생성 (기존변수+신규변수) |
| transmute(df, price_range=Max.Price-Min.Price) | 새로운 변수만을 저장하고 기존변수는 날려버림  |
| summarise(df, math_mean=mean(math))            | 수치형 값에 대한 요약 통계량 계산             |



```R
??mpg # ?mpg보다 상위에서 찾아줌
str(mpg)
# 각 집단별로 다시 집단 나누기
mpg %>%
  group_by(manufacturer, drv) %>%      # 회사별, 구방방식별 분리
  summarise(mean_cty = mean(cty)) %>%  # cty 평균 산출
  head(10)                             # 일부 출력

#[ 문제 ] 
#회사별로 "suv" 자동차의 도시 및 고속도로 통합 연비 평균을 구해 내림차순으로 정렬하고, 1~5위까지 출력하기
#절차	기능	dplyr 함수
#1	회사별로 분리	group_by()
#2	suv 추출	filter()
#3	통합 연비 변수 생성	mutate()
#4	통합 연비 평균 산출	summarise()
#5	내림차순 정렬	arrange()
#6	1~5위까지 출력	head()
library(ggplot2)
mpg <- as.data.frame(mpg)
str(mpg)
mpg %>%
  group_by(manufacturer) %>%           # 회사별로 분리
  filter(class == "suv") %>%           # suv 추출
  mutate(tot = (cty+hwy)/2) %>%        # 통합 연비 변수 생성
  summarise(mean_tot = mean(tot)) %>%  # 통합 연비 평균 산출
  arrange(desc(mean_tot)) %>%          # 내림차순 정렬
  head(5)                              # 1~5위까지 출력

mpg %>%
  filter(class == "suv") %>%           
  mutate(tot = (cty+hwy)/2) %>% 
  group_by(manufacturer) %>%           
  summarise(mean_tot = mean(tot)) %>%  
  arrange(desc(mean_tot)) %>%          # 내림차순 정렬
  head(5)
```



| function    | mean                                                    |
| ----------- | ------------------------------------------------------- |
| bind_rows() | 데이터프레임에 행 덧붙이기                              |
| bind_cols() | 데이터프레임에 열 덧붙이기 (관측치 개수가 동일해야한다) |



#### **- join() 함수**

![join.png](./join.png)

| join()       | 공통 변수에 기반하여 결합                           |
| ------------ | --------------------------------------------------- |
| left_join()  | 왼쪽 자료의 항목을 기준으로 결합                    |
| right_join() | 오른쪽 자료의 항목을 기준으로 결합                  |
| inner_join() | 두 자료의 공통 항목만을 결합 (다르면 제외)          |
| full_join()  | (일치하는 행이 없더라도) 두 자료의 모든 항목을 결합 |

```R
##### join() #####
# 가로로 합치기
# 중간고사 데이터 생성
test1 <- data.frame(id = c(1,2,3,4,5,6), midterm = c(60,80,70,90,85,100))
# 기말고사 데이터 생성
test2 <- data.frame(id = c(1,5,3,4,2,7), final = c(70,80,65,95,83,0))

# id 기준으로 합치기
total1 <- inner_join(test1, test2, by="id") # id 기준으로 공통된 것만 합침
total2 <- full_join(test1, test2, by="id")  # id 기준으로 모든 데이터를 합침

# 다른 데이터 활용해 변수 추가하기
# 반별 담임교사 명단 생성
name <- data.frame(class = c(1,2,3,4,5), 
                   teacher = c("kim", "lee", "park", "choi", "jung"))

# class 기준 합치기
exam
exam_new <- left_join(exam, name, by="class")

# 세로로 합치기, bind_rows()
# 학생 1~5번 시험 데이터 생성
group_a <- data.frame(id = c(1, 2, 3, 4, 5), test = c(60, 80, 70, 90, 85))
# 학생 6~10번 시험 데이터 생성
group_b <- data.frame(id = c(6, 7, 8, 9, 10), test = c(70, 83, 65, 95, 80))

group_all <- bind_rows(group_a, group_b) # 밑에 행에 덧붙인다
```



## (2) 데이터 정제 (결측치, 이상치 처리)

### (I) 결측치(Missing Value) 

- 누락된 값, 비어있는 값 (R 에서는 NA)
- 함수 적용 불가, 분석 결과를 왜곡하므로 제거 후 분석

```R
df <- data.frame(sex = c("M", "F", NA, "M", "F"), score = c(5, 4, 3, 4, NA))

# 결측치 확인하기
is.na(df)         # 결측치 확인
table(is.na(df))  # 결측치 빈도 출력
# 변수별로 결측치 확인하기
table(is.na(df$sex))    # sex 결측치 빈도 출력
table(is.na(df$score))  # score 결측치 빈도 출력
# 결측치 포함된 상태로 분석
mean(df$score)  # 평균 산출 불가
sum(df$score)   # 합계 산출 불가
# 결측치 있는 행 제거하기
df %>% filter(is.na(score))   # score가 NA인 데이터만 출력
df %>% filter(!is.na(score))  # score 결측치 제거
# 결측치 제외한 데이터로 분석하기
df_nomiss <- df %>% filter(!is.na(score))  # score 결측치 제거
mean(df_nomiss$score)                      # score 평균 산출
sum(df_nomiss$score)                       # score 합계 산출

# 여러 변수 동시에 결측치 없는 데이터 추출하기
# score, sex 결측치 제외
df_nomiss <- df %>% filter(!is.na(score) & !is.na(sex))
df_nomiss  
# 결측치가 하나라도 있으면 제거하기
df_nomiss2 <- na.omit(df)  # NA는 버리고 데이터 추출

# 분석에 필요한 데이터까지 손실 될 가능성 유의
# 함수의 결측치 제외 기능 이용하기 (na.rm = T)
mean(df$score, na.rm = T)  # 결측치 제외하고 평균 산출
sum(df$score, na.rm = T)   # 결측치 제외하고 합계 산출
# summarise()에서 na.rm = T 사용하기
# 결측치 생성
exam <- read.csv("data/csv_exam.csv")
table(is.na(exam))
exam[c(3, 8, 15), "math"] <- NA # 3, 8, 15행의 math에 NA 할당
# 평균 구하기
exam %>% summarise(mean_math = mean(math))             # 평균 산출
exam %>% summarise(mean_math = mean(math, na.rm = T))  # 결측치 제외하고 평균 산출
# 다른 함수들에 적용
exam %>% summarise(mean_math = mean(math, na.rm = T),      # 평균 산출
                   sum_math = sum(math, na.rm = T),        # 합계 산출
                   median_math = median(math, na.rm = T))  # 중앙값 산출
boxplot(exam$math)
mean(exam$math, na.rm = T) # 결측치 제외하고 math 평균 산출
# 평균으로 대체하기
exam$math <- ifelse(is.na(exam$math), 55, exam$math)  # math가 NA면 미리계산한 평균으로 대체
table(is.na(exam$math))                               # 결측치 빈도표 생성
mean(exam$math) # math 평균 산출
```



### (II) 이상치(Outlier)

- 정상범주에서 크게 벗어난 값

```R
# 이상치 포함된 데이터 생성 (이상치: sex=3, score=6)
outlier <- data.frame(sex = c(1,2,1,3,2,1), score = c(5,4,3,4,2,6)) 

# 이상치 확인하기
table(outlier$sex)
table(outlier$score)

# 이상치 처리하기 - sex
# sex가 3이면 NA 할당
outlier$sex <- ifelse(outlier$sex == 3, NA, outlier$sex)

# 이상치 처리하기 - score
# score가 1~5 아니면 NA 할당
outlier$score <- ifelse(outlier$score > 5, NA, outlier$score)

# 이상치 제외하고 분석
outlier %>%
  filter(!is.na(sex) & !is.na(score)) %>%
  group_by(sex) %>%
  summarise(mean_score = mean(score))
```



```R
# 박스플롯으로 이상치 판단
mpg <- as.data.frame(ggplot2::mpg)
View(mpg)
boxplot(mpg$hwy)
boxplot(mpg$hwy, range=2) # range = 0 (이상치판단을 안하겠다)
summary(mpg$hwy)

# boxplot은 그래프와 함께 리스트도 반환
boxplot(mpg$hwy)$stats # 상자그림 통계치 출력

# 이상치 처리하기
# 12~37 벗어나면 NA 할당
mpg$hwy <- ifelse(mpg$hwy < 12 | mpg$hwy > 37, NA, mpg$hwy)
table(is.na(mpg$hwy))

# 결측치 제외하고 분석하기
mpg %>%
  group_by(drv) %>%
  summarise(mean_hwy = mean(hwy, na.rm = T))
```

