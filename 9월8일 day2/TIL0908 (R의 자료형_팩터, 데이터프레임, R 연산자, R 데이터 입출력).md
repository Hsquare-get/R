# TIL0908 (R의 자료형_팩터, 데이터프레임 / R연산자 / R데이터 입출력)

## (3) R의 데이터셋

### (IV) 팩터(Factor)

> **범주형 데이터는 질적자료로써** 측정 대상의 특성을 분류하거나 확인할 목적으로 부여한 값 들로서 값들의 순서 적용 여부에 따라서 **명목형**과 **순서형**으로 나뉜다.

- 특별한 벡터
- <span style="color:red">**동일 타입의 데이터만으로 구성**</span>

- **가능한 범주값(level)만으로 구성되는 벡터**이다. 즉, 질적자료로만 인식한다.
- 팩터 생성 방법
  - factor(벡터)
  - factor(벡터, levels=레벨벡터)
  - factor(벡터, levels=레벨벡터, **ordered=TRUE**) #순서형
- 팩터의 레벨 정보 추출 : levels(팩터변수)

```R
##### Factor #####

score <- c(1,3,2,4,2,1,3,5,1,3,3,3)
class(score) # 어떤 타입의 데이터들로 구성되어있는지
summary(score) # 요약

f_score <- factor(score)
class(f_score) # 범주형(이산형) 데이터들로 구성되어있는 데이터셋이다!
f_score # Levels 1 2 3 4 5 / 이 팩터를 구성하고 있는 범주 정보를 같이 반환
summary(f_score) # 범주형데이터로서 각 레벨의 개수를 세어준다
levels(f_score)

plot(score) # 산점도 등 데이터셋에 알맞는 그래프 시각화 함수
plot(f_score) # x축은 레벨(범주), y축은 개수


data1 <- c("월", "수", "토", "월", "목", "화")
data1
class(data1) # 벡터에 대해 수행했을 경우 벡터 안의 데이터값들의 타입을 알려준다.
summary(data1)
day1 <- factor(data1)
day1
class(day1) # 팩터에 대해 수행하면 팩터임을 알려줄 뿐이다.
summary(day1)
levels(day1)

week.korabbname <- c("일", "월", "화", "수", "목", "금", "토")
day2 <- factor(data1, 
               levels=week.korabbname)
day2
summary(day2)
levels(day2)



btype <- factor(
  c("A", "O", "AB", "B", "O", "A"), 
  levels=c("A", "B", "O"))
btype # 범주를 지정해줬지만 AB는 범주에 해당하지 않기 때문에 결측치로 처리됨
summary(btype)
levels(btype)

gender <- factor(c(1,2,1,1,1,2,1,2), 
                 levels=c(1,2), 
                 labels=c("남성", "여성")) # labels는 level의 라벨
gender
summary(gender)
levels(gender)
```



---



![image-20200908103702683](C:\Users\user\AppData\Roaming\Typora\typora-user-images\image-20200908103702683.png)



### (V) 데이터프레임(data.frame)

- 2차원 구조 (열 : 변수, 행 : 관측치)
- **열 단위로 서로다른 타입의 데이터들로 구성이 가능**하다.

- <span style="color:red">**모든 열의 데이터 개수(행의 개수)는 동일해야 한다.**</span>
  - 달라야하는 경우 List를 활용 

- 데이터프레임 생성 방법
  - data.frame(v1, v2, v3... )
  - data.frame(열이름=v1, 열이름=v2, 열이름=v3...)
  - date.frame(v1, v2, v3..., **stringsAsFactors=FALSE**) default
    - 문자열(chr)을 팩터로 바꾸지 않는 것이 default
  - as.data.frame(벡터 or 행렬)
- 데이터프레임 변환 : rbind(df, 벡터), cbind(df, 벡터)
- 데이터프레임의 구조 확인
  - **str(df)** : structure 약어
  - dim(df) : 행과열의 개수를 알려준다
- 인덱싱
  - [행 인덱싱, 열 인덱싱]
  - [열 인덱싱]
  - df$열이름
  - [[열 인덱싱]]

- 원하는 행과 열 추출 : subset(df, subset=(행조건), select=열이름들)

```R
##### Dataframe #####
# 내장 데이터셋
data()
iris; 
head(iris); tail(iris) # 앞 6개, 뒤 6개 (head(df, n=3))
View(iris) # 데이터셋을 파악할 때 엑셀처럼 시각화하여 새 창으로
str(iris) # 데이터프레임 구조 확인 (150 obs. of 5 variables <--- 150개 행, 5개 열)


# Dataframe 실습
no <- c(1,2,3,4)
name <- c('Apple','Banana','Peach','Berry')
qty <- c(5,2,7,9)
price <- c(500,200,200,500)

fruit <- data.frame(no, name, qty, price)
str(fruit)
View(fruit)

fruit[1,]
fruit[-1,]
fruit[,2]
fruit[,3] # 하나의 열만 추출할 때 벡터로 추출하지만
fruit[,3, drop=F] # 데이터프레임 구조를 유지하고 싶으면 drop=F
fruit[, c(3,4)]
fruit[3,2]
fruit[3,1]

# 특정 열 추출
fruit[,3]
fruit$qty # df$열이름
fruit[[3]]
fruit[3]  # 데이터프레임 형식 유지

str(fruit$qty)
str(fruit[3])

```



```R
# dataframe exam1
english <- c(90, 80, 60, 70)
math <- c(50, 60, 100, 20)
classnum <- c(1,1,2,2)

df_midterm <- data.frame(english, math, classnum)
df_midterm
str(df_midterm)
colnames(df_midterm) # names(df_midterm), 열이름 우선
rownames(df_midterm)
mean(df_midterm$english)
mean(df_midterm$math)

df_midterm2 <- data.frame(
  c(90, 80, 60, 70), 
  c(50, 60, 100, 20), 
  c(1,1,2,2))
colnames(df_midterm2) # names(df_midterm2), 열이름 우선
rownames(df_midterm2)
df_midterm2

df_midterm2 <- data.frame(
  영어=c(90, 80, 60, 70), 
  수학=c(50, 60, 100, 20), 
  클래스=c(1,1,2,2))
df_midterm2
df_midterm2$영어

df <- data.frame(var1=c(4,3,8), 
                 var2=c(2,6)) # 오류
df <- data.frame(var1=c(4,3,8), 
                 var2=c(2,6,1))
str(df)

df$var_sum <- df$var1 + df$var2 # 기존 열의 합으로 새로운 열생성(파생변수)
df$var_mean <- df$var_sum/2 # 기존 열의 평균으로 새로운 열생성(파생변수)
# ifelse(조건, 조건이 참이면 두번째 반환, 아니면 세번째 반환)
df$result <- ifelse(df$var1>df$var2, "var1이 크다", "var1이 작다")
str(df)

```



```R
#csv파일열기
getwd() # setwd('xxx')

score <- read.csv("data/score.csv")
score
str(score)
score$sum <- score$math + score$english + score$science
score$result <- ifelse(score$sum >= 200, 
                       "pass", "fail")
score; View(score)

summary(score$result) # pass, fail이 chr 벡터이기 때문에 summary로 개수를 셀 수 X
summary(factor(score$result)) # factor형이어야만 summary로 개수를 세어준다
table(score$result) # 집계표를 만든다

score$result = factor(score$result) 
score$id = as.character(score$id)
score$class = factor(score$class)
str(score)
summary(score)

score$grade <- ifelse(score$sum >= 230,"A",
                      ifelse(score$sum >= 215,"B",
                             ifelse(score$sum >=200,"C","D")))
score$grade = factor(score$grade)

str(score); score

```



```R
# order() 와 sort()
v <- c(10,3,7,4,8)
sort(v) # 데이터 값을 sorting
order(v) # 실제 데이터 값을 오름차순으로 sorting하고 인덱스를 반환
emp[order(emp$sal),] # [1]  1 12 11  3  5 14 10  2  7  6  4  8 13  9
					 #	제일작은값 
					 #	   두번째작은값(인덱스12) ---------------> 제일큰값
emp[order(emp$sal, decreasing=T),] # 월급 많은순으로 정렬

emp <- read.csv(file.choose(), stringsAsFactors = F)
emp
str(emp)

# emp에서 직원 이름
emp$ename
emp[,2]
emp[,"ename"] 
emp[,2, drop=FALSE] 
emp[,"ename",drop=F] 
emp[2] # 기본으로 drop=F
emp["ename"] 

# emp에서 직원이름, 잡, 샐러리
emp[,c(2,3,6)]
emp[,c("ename","job","sal")]
subset(emp,select = c(ename, job, sal)) # 원하는 행과 열 추출
?subset

# emp에서 1,2,3 행 들만
emp[1:3,]
emp[c(1,2,3),]
?head
head(emp)
head(emp, n=1)

# ename이 "KING"인 직원의 모든 정보
emp[9,] 
emp$ename=="KING" # F,F,F,F,F,F,F,F, T, F,F,F,F,F,F,F,F,F,F,F
emp[c(F,F,F,F,F,F,F,F, T, F,F,F,F,F,F,F,F,F,F,F),]
emp[emp$ename=="KING",]
subset(emp,subset=emp$ename=="KING") # 행조건을 줌
subset(emp,emp$ename=="KING") 


# 커미션을 받는 직원들의 모든 정보 출력
emp[!is.na(emp$comm),] # !not
subset(emp, !is.na(emp$comm))
View(emp)

# select ename,sal from emp where sal>=2000
subset(emp, select=c("ename","sal"), subset=(emp$sal>=2000))
subset(emp, emp$sal>=2000, c("ename","sal"))
emp[emp$sal>=2000, c("ename","sal")]

# select ename,sal from emp where sal between 2000 and 3000
subset(emp, select=c("ename","sal"), subset=(sal>=2000 & sal<=3000))
emp[emp$sal>=2000 & emp$sal<=3000, c("ename","sal")] 
# 행 인덱싱에는 비교식 사용가능, 열 인덱싱에는 비교식 사용불가

```



## (4) R 연산자

![image-20200908170526894](C:\Users\user\AppData\Roaming\Typora\typora-user-images\image-20200908170526894.png)

```R
##### R 연산자 #####
y <- c(0, 25, 50, 75, 100)
z <- c(50, 50, 50, 50, 50)
y == z # F F T F F
y != z
y > z # F F F T T
y < z
y >= z # F F T T T
y <= z
y == 50 # c(50, 50, 50, 50, 50)
y > 50

num1 <- 11 # c(11)
num2 <- 3  # c(3)
num1 / num2
num1 %% num2 # 나머지
num1 %/% num2 # 몫
```



## (5) R 데이터 입출력

- print(x, ...)
- cat() : 하나의 문자열로 만들어서 출력한다. 인덱스 보여주지 않음. 자동으로 개행처리 X (옵션에 \n 추가)

```R
##### R 데이터 입출력 #####
print(100)
print(pi)
data <- "가나다"
print(data)
print(data, quote=FALSE) # 인용부호 제거후 출력
v1 <- c("사과", "바나나", "포도")
print(v1)
print(v1, print.gap=10)
cat(100)
cat(100,200)
cat(100,200,"\n")
cat("aaa", "bbb", "ccc", "ddd", "\n")
cat(v1, "\n")
cat(v1, sep="-", "\n")
cat(v1, sep="\n")

print(paste("R", "은 통계분석", "전용 언어입니다."))
cat("R", "은 통계분석", "전용 언어입니다.", "\n")

```



- 지금까지 만들어진 데이터셋과 함수 저장하기

```R
ls()
length(ls())
save(변수명,  file="one.rda") # xxx.RData, 하나의 변수만 저장
save(list=ls(), file="all.rda") # varience will save in "all.rda" of Rexam
# rm(list=ls()) # 지금까지 만든 변수 모두 삭제
ls()
getwd()
load("all.rda")
ls()
```



- 파일에서 데이터 읽어들이기

```R
# scan : 숫자 읽어오는데 특화
nums <- scan("sample_num.txt")
words_ansi <- scan("sample_ansi.txt", what="") 
# what="" : what 매개변수에 null문자 주어서 숫자가 아닌 데이터(문자열or문자열+숫자)도 읽어온다.

words_utf8 <- scan("sample_utf8.txt", what="", encoding="UTF-8") # UTF-8 반드시 대문자
words_utf8_new <- scan("data/sample_utf8.txt", what="") # encoding="UTF-8" 없으면 한글 깨짐


# 행단위로 읽음
lines_ansi <- readLines("sample_ansi.txt")
lines_urf8 <- readLines("sample_utf8.txt", encoding="UTF-8")


# read.csv, 첫번째 행을 헤더로 인식해서 읽어온다
# read.table, 데이터프레임 형식으로 읽어온다(헤더가 없으면 자동으로 열이름을 붙여준다)
df1 <- read.csv("CSV파일 or CSV를 응답하는 URL")
df2 <- read.table("일정한 단위(공백 또는 탭등)로 구성되어 있는 텍스트 파일 or URL")


# 데이터 수집해온 것을 저장
write.csv(파일명) # csv 파일로 저장
write.table(파일명) # 일정 규격으로 blank or tab or delimeter 형식으로 저장

```

