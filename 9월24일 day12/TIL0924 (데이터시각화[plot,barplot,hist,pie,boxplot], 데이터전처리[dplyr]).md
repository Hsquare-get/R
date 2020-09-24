# TIL0924 (데이터시각화[plot,barplot,hist,pie,boxplot], 데이터전처리[dplyr])

## (1) <span style="color:red;">데이터시각화</span>

> 자동으로 로드되는 기본 패키지 graphics로 데이터를 시각화 할 수 있다.
>
> 기본적으로 plot 영역은 하나의 그래프만 허용한다. 여러개의 그래프를 같이 표현하고싶으면 레이아웃을 나누어 그리고자 하는 공간을 분리해야한다.

- 고수준 함수 : `plot()`, `boxplot()`, `hist()`, `pie()`, `barplot()`
- 저수준 함수 : `title()`, `lines()`, `axis()`, `legend()`, `points()`, `text()`
- 칼라팔레트 함수 : `rainbow()`, `cm.colors()`, `topo.colors()`, `terrian.colors()`, `heat.colors()`



| 함수        | 주용도     |
| ----------- | ---------- |
| `plot()`    | 산포도     |
| `barplot()` | 막대그래프 |
| `hist()`    | 히스토그램 |
| `pie()`     | 원형그래프 |
| `boxplot()` | 상자그래프 |



### (I) 산점도 plot()

```R
##### 데이터 시각화 #####
search()
install.packages("showtext")
library(showtext)
showtext_auto() # 자동설정 필수
font_add(family = "cat", regular = "fonts/HoonWhitecatR.ttf")
font_add(family = "dog", regular = "fonts/THEdog.ttf")
font_add(family = "maple", regular = "fonts/MaplestoryBold.ttf")
rainbow(10); rainbow(20)

국어 <- c(4,7,6,8,5,5,9,10,4,10)  
plot(국어) # 가로축은 자동으로 index

plot(국어, type="o", col="blue", family="maple")
title(main="성적그래프", col.main="red", font.main=4, family="maple")


국어 <- c(4,7,6,8,5,5,9,10,4,10)
수학 <- c(7,4,7,3,8,10,4,10,5,7)

plot(국어, type="o", col="blue")
lines(수학, type="o", pch=16, lty=2, col="red")     
title(main="성적그래프", col.main="red", font.main=3)


국어 <- c(4,7,6,8,5,5,9,10,4,10)
par(mar=c(1,1,1,1), mfrow=c(4,2)) # 그래프 영역 레이아웃 나누기

plot(국어, type="p", col="blue", main="type = p", xaxt="n", yaxt="n")
plot(국어, type="l", col="blue", main="type = l", xaxt="n", yaxt="n")
plot(국어, type="b", col="blue", main="type = b", xaxt="n", yaxt="n")
plot(국어, type="c", col="blue", main="type = c", xaxt="n", yaxt="n")
plot(국어, type="o", col="blue", main="type = o", xaxt="n", yaxt="n")
plot(국어, type="h", col="blue", main="type = h", xaxt="n", yaxt="n")
plot(국어, type="s", col="blue", main="type = s", xaxt="n", yaxt="n")
plot(국어, type="S", col="blue", main="type = S", xaxt="n", yaxt="n")


par(mar=c(5,5,5,5), mfrow=c(1,1))

국어 <- c(4,7,6,8,5,5,9,10,4,10); 
수학 <- c(7,4,7,3,8,10,4,10,5,7)

plot(국어, type="o", col="blue", ylim=c(0,10), axes=FALSE, ann=FALSE)

# x, y 축 추가하기
axis(1, at=1:10, lab=c("01","02","03","04", "05","06","07","08","09","10"), family="maple") # x축 추가
axis(2, at=c(0,2,4,6,8,10), family="maple") # y축 추가

# 그래프 추가하고, 그래프에 박스 그리기
lines(수학, type="o", pch=16, lty=2, col="red")    
box() # 박스 그리기


# 그래프 제목, 축의 제목, 범례 나타내기
title(main="성적그래프", col.main="red", font.main=4, family="maple") 
title(xlab="학번", col.lab=rgb(0,1,0), family="maple")  
title(ylab="점수", col.lab=rgb(1,0,0), family="maple")  
legend(8, 3, c("국어","수학"), cex=0.8, col=c("blue","red"), pch=c(21,16), lty=c(1,2))

```



```R
### 그려진 그래프를 이미지 파일로 내보내기 ###
png("test.png", height=500, width=400, bg="white")
그래프 그리기
dev.off()

(성적 <- read.table("data/성적.txt", header=TRUE))

plot(성적$학번, 성적$국어, main="성적그래프", xlab="학번", ylab="점수", xlim=c(0, 11), ylim=c(0, 11))

ymax <- max(성적[3:5]) # 성적 데이터 중에서 최대값을 찾는다(y 축의 크기 제한)
ymax
pcols <- c("red", "blue", "green")
png(filename="성적.png", height=400, width=700, bg="white") # 출력을 png파일로 설정
plot(성적$국어, type="o", col=pcols[1], ylim=c(0, ymax), axes=FALSE, ann=FALSE)
axis(1, at=1:10, lab=c("01","02","03","04","05","06","07","08","09","10"))
axis(2, at=c(0,2,4,6,8,10), lab=c(0,2,4,6,8,10))
box()
lines(성적$수학, type="o", pch=16, lty=2, col=pcols[2])
lines(성적$영어, type="o", pch=23, lty=3, col=pcols[3])
title(main="성적그래프", col.main="red", font.main=4)
title(xlab="학번", col.lab=rgb(1,0,0))
title(ylab="점수", col.lab=rgb(0,0,1))
legend(1, ymax, names(성적)[c(3,4,5)], cex=0.8, col=pcols, pch=c(21,16,23), lty=c(1,2,3))

###
dev.off() # 출력방향을 다시 종료시킨다
###

plot(국어, 수학) # x축:국어 / y축:수학
plot(수학~국어) # formula 식, 국어점수에 따른 수학점수와의 관계

# 그래프를 그린 후에 파일에도 저장하는 방법
그래프를 그린다
dev.copy(png, "test.png")
dev.copy(pdf, "test.pdf")
dev.off()

```



### (II) 막대그래프 barplot()

```R
library(showtext)
showtext_auto() # 자동설정 필수
font_add(family = "cat", regular = "fonts/HoonWhitecatR.ttf")
font_add(family = "dog", regular = "fonts/THEdog.ttf")
font_add(family = "maple", regular = "fonts/MaplestoryBold.ttf")


### 막대그래프 그리기 barplot() ###
barplot(국어)

coldens <- seq(from=10, to=100, by=10)   # 막대그래프의 색밀도 설정을 위한 벡터
xname <- 성적$학번 # X축 값설정을 위한 벡터
barplot(성적$국어, main="성적그래프", xlab="학번", ylab="점수", border="red", col="green", density=coldens, names.arg=xname, family="dog")

# 학생의 각 과목에 대한 각각의 점수에 대한 그래프
성적1 <- 성적[3:5] # 국어,수학,영어 성적만
str(성적1) # dataframe
par(mar=c(5,5,5,5), mfrow=c(1,1))
barplot(as.matrix(성적1), main="성적그래프", 
        beside=T, ylab="점수", col=rainbow(10), family="cat") # beside=T, 쌓지않고 옆으로 그리겠다

par(mar=c(5,5,5,5), mfrow=c(1,2))
barplot(as.matrix(성적1), main="성적그래프", ylab="점수", col=rainbow(10))
barplot(t(성적1), main="성적그래프", ylab="점수", col=rainbow(10)) # t(), 행x열 -> 열x행

par(mar=c(5,5,5,5), mfrow=c(1,1)) # mar(상,하,좌,우)
# 학생의 각 과목에대한 합계 점수에 대한 그래프
xname <- 성적$학번 # x축 레이블용 벡터
par(xpd=T, mar=par()$mar + c(0,0,0,4)); # 우측에 범례가 들어갈 여백을 확보
barplot(t(성적1), main="성적그래프", ylab="점수", col=rainbow(3), space=0.1, cex.axis=0.8, names.arg=xname, cex=0.8)
legend(11,30, names(성적1), cex=0.8, fill=rainbow(3));

par(xpd=T, mar=c(5,5,5,5)) # 우측에 범례가 들어갈 여백을 확보
barplot(t(성적1), main="성적그래프", ylab="점수", col=rainbow(3), space=0.1, cex.axis=0.8, names.arg=xname, cex=0.8)
legend(11,30, names(성적1), cex=0.8, fill=rainbow(3));


# 학생의 각 과목에 대한 합계 점수에 대한 그래프(가로막대 그래프)
xname <- 성적$학번 # x축 레이블용 벡터
barplot(t(성적1), main="성적그래프", ylab="학번", col=rainbow(3), space=0.1, cex.axis=2.0, names.arg=xname, cex.lab=3.0, horiz=T);
legend(30,11, names(성적1), cex=0.8, fill=rainbow(3))

?barplot

```



### (III) 파이그래프 pie()

```R
### 파이그래프 pie() ###
# 3시부터 반시계방향으로 그리는 것이 Default
(성적 <- read.table("data/성적.txt", header=TRUE));
pie(성적$국어, labels=paste(성적$성명, "-", 성적$국어), col=rainbow(10))
pie(성적$국어, clockwise=T, labels=paste(성적$성명, "-", 성적$국어), col=rainbow(10)) 
# clockwise=T, 12시부터 시계방향으로
pie(성적$국어, density=10, clockwise=T, labels=paste(성적$성명, "-", 성적$국어), col=rainbow(10))
pie(성적$국어, labels=paste(성적$성명, "-", 성적$국어), col=rainbow(10), main="국어성적", edges=10)
pie(성적$국어, labels=paste(성적$성명,"\n","(",성적$국어,")"), col=rainbow(10))
pie(rep(1, 24), col = rainbow(24), radius = 0.5)

```



### (IV) 히스토그램 hist()

```R
### 히스토그램 hist() ###
# 히스토그램 (데이터의 분포를 구간을 나눠서 시각화해주는 그래프)
hist(성적$국어, main="성적분포-국어", 
       xlab="점수", breaks=5, # breaks, 나눠진 구간(계급)수 (계급수 지정해도 적당하게 적용함)
       col = "lightblue", border = "pink", family='dog') 
hist(성적$수학, main="성적분포-수학", 
       xlab="점수", col = "lightblue", 
       breaks=2, border = "pink")
hist(성적$국어, main="성적분포-국어", prob=T, # prob=T, 상대도수로 표현
       xlab="점수", ylab="도수", 
       col=rainbow(12), border = "pink")

nums <- sample(1:100, 30)
hist(nums, family='maple')
hist(nums, breaks=c(0,10,20,30,40,50,60,70,80,90,100))
hist(nums, breaks=c(0,50,100), probability = T)
hist(nums, breaks=c(0,33,66,100))

# 적당한 계급수 구하기
# 5*log10(데이터수), 5*log(데이터수,10)
nclass.Sturges(nums)
nclass.scott(nums)
nclass.FD(nums)

```



### (V) 상자그래프 boxplot()

```R
### 박스플롯(상자그래프) boxplot() ###
summary(성적$국어)
boxplot(성적$국어, col="yellow",  ylim=c(0,10), xlab="국어", ylab="성적", family='dog')


성적2 <- 성적[,3:5]
boxplot(성적2, col=rainbow(3), ylim=c(0,10), ylab="성적")

data <- read.table("data/온도.txt", header=TRUE, sep=",") # read.table(header=T, sep=",")는 read.csv와 같다
head(data, n=5)
dim(data) # 행수 열수
boxplot(data)
boxplot(data, las = 2) # las는 눕혀서 쓰기
boxplot(data, las = 2, at = c(1,2,3,4, 6,7,8,9, 11,12,13,14))
chtcols = rep(c("red","sienna","palevioletred1","royalblue2"), times=3)
chtcols
boxplot(data, las = 2, at = c(1,2,3,4, 6,7,8,9, 11,12,13,14), col=chtcols)
grid(col="gray", lty=2, lwd=1)

boxplot(data, family='maple')  # 박스플롯은 전체 폰트적용 X

boxplot(data, axes=F)
axis(1, at=1:12, lab=names(data), family="maple") # x축 추가
axis(2, at=seq(-5, 15, 5), family="dog")
title("다양하게 폰트를 지정한 박스플롯", family="cat", cex.main=2)
box()

# 색상
rainbow(10)
heat.colors(10)
terrain.colors(10)
topo.colors(10)
cm.colors(10)
gray.colors(10)

```



---



## (2) 데이터 전처리 - <span style="color:red;">dplyr 패키지</span>

> <span style="color:red;">데이터프레임에 담겨진 데이터들의 전처리</span>에 가장 많이 사용되는 R 패키지이다.
>
> 데이터를 빨리 쉽게 가공할 수 있도록 도와주는 패키지로서 유연한 데이터 조작문법을 제공하고 C언어로 만들어서 매우 빠르다.

- ~~ `%>%` ~~ : 연산자가 아닌 함수이다, 앞에 구현된 내용을 다음 명령어의 데이터로 줘라라는 뜻

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
##### dplyr 패키지 #####
install.packages("dplyr")
library(dplyr)
install.packages("ggplot2")

str(ggplot2::mpg) # ggplot2에 있는 mpg 데이터셋
head(ggplot2::mpg)
mpg <- as.data.frame(ggplot2::mpg)
head(mpg)

exam <- read.csv("data/csv_exam.csv")
str(exam)
dim(exam)
head(exam);tail(exam)
View(exam)
```



```R
### filter(), 조건에 맞는 행을 반환하는 함수
# exam에서 class가 1인 경우만 추출하여 출력
exam %>% filter(class == 1) # [참고] 단축키 [Ctrl+Shit+M]으로 %>% 기호 입력
# 2반인 경우만 추출
exam %>% filter(class == 2)
# 1반이 아닌 경우
exam %>% filter(class != 1)
# 3반이 아닌 경우
exam %>% filter(class != 3)
# 수학 점수가 50점을 초과한 경우
exam %>% filter(math > 50)
# 수학 점수가 50점 미만인 경우
exam %>% filter(math < 50)
# 영어점수가 80점 이상인 경우
exam %>% filter(english >= 80)
# 영어점수가 80점 이하인 경우
exam %>% filter(english <= 80)
# 1반 이면서 수학 점수가 50점 이상인 경우
exam %>% filter(class == 1 & math >= 50) # 각각의 원소마다 비교해야하기 때문에 &&이 아닌 & 사용
# 2반 이면서 영어점수가 80점 이상인 경우
exam %>% filter(class == 2 & english >= 80)
# 수학 점수가 90점 이상이거나 영어점수가 90점 이상인 경우
exam %>% filter(math >= 90 | english >= 90)
# 영어점수가 90점 미만이거나 과학점수가 50점 미만인 경우
exam %>% filter(english < 90 | science < 50)
# 목록에 해당되는 행 추출하기
exam %>% filter(class == 1 | class == 3 | class == 5) # 1, 3, 5 반에 해당되면 추출
# %in% 연산자 이용하기, "뒤에 오는 요소중에 하나라도 있으면~"
exam %>% filter(class %in% c(1,3,5)) # 1, 3, 5 반에 해당하면 추출
# 추출한 행으로 데이터 만들기
class1 <- exam %>% filter(class == 1) # class가 1인 행 추출, class1에 할당
class2 <- exam %>% filter(class == 2) # class가 2인 행 추출, class2에 할당
mean(class1$math)                     # 1반 수학 점수 평균 구하기
mean(class2$math)                     # 2반 수학 점수 평균 구하기
```



```R
### select(), 열을 지정하는 함수
exam %>% select(math) # math 추출
exam %>% select(english) # english 추출
# 여러 변수 추출하기
exam %>% select(class, math, english) # class, math, english 변수 추출
# 변수 제외하기
exam %>% select(-math) # math 제외
exam %>% select(-math, -english) # math, english 제외


# dplyr 함수 조합하기
# class가 1인 행만 추출한 다음 english 추출
exam %>% filter(class == 1) %>% select(english)
# 가독성 있게 줄 바꾸기 (체이닝기호 %>%는 반드시 뒤에 와야한다)
exam %>% 
        filter(class == 1) %>%  # class가 1인 행 추출
        select(english)         # english 추출
# 일부만 출력하기
exam %>%
        select(id, math) %>%  # id, math 추출
        head                  # 앞부분 6행까지 추출
# 일부만 출력하기
exam %>%
        select(id, math) %>%  # id, math 추출
        head(10)              # 앞부분 10행까지 추출


data(iris) # data() 아규먼트에 지정된 객체(데이터셋)를 로드하는 기능
iris %>% pull(Species) # 팩터형식의 벡터로 추출
iris %>% select(Species) # 데이터 프레임 구조를 유지하면서 추출
iris %>% select_if(is.numeric) %>% head
iris %>% select(-Sepal.Length, -Petal.Length)

# Select column whose name starts with "Petal"
iris %>% select(starts_with("Petal")) # 대문자
iris %>% select(starts_with("petal")) # 소문자
iris %>% select(starts_with("Petal", ignore.case=T)) # 대소문자 무시X, 구분하겠다

# Select column whose name ends with "Width"
iris %>% select(ends_with("Width"))

# Select columns whose names contains "etal"
iris %>% select(contains("etal"))

# Select columns whose name maches a regular expression
iris %>% select(matches(".t."))
iris %>% select(one_of("aa", "bb", "Petal.Length", "Petal.Width"))
```



```R
### arrange(), 정렬함수
# 오름차순으로 정렬하기
exam %>% arrange(math)  # math 오름차순 정렬
# 내림차순으로 정렬하기
exam %>% arrange(desc(math))  # math 내림차순 정렬
# 정렬 기준 변수 여러개 지정
exam %>% arrange(desc(class), desc(math))  # class 내림차순 정렬 후 math 내림차순 정렬
exam %>% arrange(desc(math)) %>% head(1) # 수학 1등의 데이터가 출력
```



```R
### mutate(), 파생변수를 추가해주는 함수
exam %>%
        mutate(total = math + english + science) %>%  # 총합 변수 추가
        head                                          # 일부 추출
#여러 파생변수 한 번에 추가하기
exam %>%
        mutate(total = math + english + science,          # 총합 변수 추가
               mean = (math + english + science)/3) %>%   # 총평균 변수 추가
        head     
exam %>%
        mutate(total = math + english + science,          # 총합 변수 추가
               mean = total/3) %>%   # 총평균 변수 추가
        head 


# 일부 추출
# mutate()에 ifelse() 적용하기
exam %>%
        mutate(test = ifelse(science >= 60, "pass", "fail")) %>%
        head
#추가한 변수를 dplyr 코드에 바로 활용하기
exam %>%
        mutate(total = math + english + science) %>%  # 총합 변수 추가
        arrange(total) %>%                            # 총합 변수 기준 정렬
        head                                          # 일부 추출
```



```R
### summarise(), 요약하여 데이터프레임으로 반환
# 전체 요약하기
exam %>% summarise(n = n()) # n()은 행의 개수를 세어주는 함수
exam %>% tally()

exam %>% summarise(mean_math = mean(math))  # math 평균 산출
mean(exam$math)

str(exam %>% summarise(mean_math = mean(math),
                       mean_english = mean(english),
                       mean_science = mean(science))) # 모든 과목의 평균 산출
```



```R
### group_by(), 조건별로 그룹화(분리)해주는 함수 {count() 깔끔하게 개수를 세어준다}
# 집단별로 요약하기
exam %>%
        group_by(class) %>% summarise(n = n()) 
exam %>%
        group_by(class) %>% tally()   
exam %>% count(class)         # count() = group_by() + tally()
# add_tally() 와 add_count(..) 도 있음

exam %>%
        group_by(class) %>%                # class별로 분리
        summarise(mean_math = mean(math))  # math 평균 산출

exam %>%
        group_by(class) %>%                   # class별로 분리
        summarise(mean_math = mean(math),     # math 평균
                  sum_math = sum(math),       # math 합계
                  median_math = median(math), # math 중앙값
                  n = n())                    # 학생 수
```



