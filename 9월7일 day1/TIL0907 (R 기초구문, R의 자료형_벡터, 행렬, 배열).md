# TIL0907 (R 기초구문, R의 자료형_벡터, 행렬, 배열)

- 방대한 데이터의 경우 분산저장하여 분산처리를 하는데 그 때 사용되는 것이 Spark.
- Spark는 R/Python/JAVA/SQL 등을 활용하여 데이터 저장소 + 데이터 처리 역할을 할 수 있다.

- EDA : 데이터를 탐색하고 탐색한 데이터를 처리하는 작업과정 (EDA를 통해 시각화와 전처리)



## (0) R

- 통계분석, 즉 데이터처리를 하기 위해 만들어진 프로그래밍 언어
- 반복문을 쓰지 않고도 대량의 데이터를 처리할 수 있다.



## (1) R의 자료형

- 문자형(character) : 문자, 문자열
- 수치형(numeric) : 정수(integer), 실수(double)
- 복소수형(complex) : 실수 + 허수
- 논리형(logical) : TRUE or FALSE



## (2) R의 리터럴(literal_데이터 값(상수))

> R은 대소문자 구분함
>
> R도 데이터셋을 객체로 본다. But, R은 class 지원X

- 문자형(character) 리터럴 : "가나다", '가나다', "", '', '123', "abc"

- 수치형(numeric) 리터럴 : 100, 3.14, 0

- 논리형(logical) 리터럴 : TRUE(T), FALSE(F)

- NULL : 데이터 셋 자체가 비어있음

- NA(Not Available) : 데이터 셋은 있지만 그 안의 특정위치의 데이터가 없는 것, 

  ​								  데이터 셋의 내부에 존재하지 않는 값(결측값)을 의미.

  ​								  10개의 수학성적을 평균내고 싶을 때 1개의 데이터만 NA이어도 평균을 낼 								  수 없음.

- NaN(Not a Number) : 숫자가 아님, Inf(무한대값)



- [타입 체크 함수]

  | type check function           |                                 |
  | ----------------------------- | ------------------------------- |
  | is.character(x) - 문자형이냐? | is.null(x) - null 값이냐?       |
  | is.logical(x) - 논리형이냐?   | is.na(x) - na 값이냐?           |
  | is.numeric(x) - 수치형이냐?   | is.nan(x) - nan 값이냐?         |
  | is.double(x) - 실수형이냐?    | is.finite(x) - 유한한 값이냐?   |
  | is.integer(x) - 정수형이냐?   | is.infinite(x) - 무한한 값이냐? |



- [자동형변환 룰]

  >문자형 > 복소수형 > 수치형 > 논리형 (문자형과 수치형이 붙으면 문자형 우선)



- [강제형변환 함수]
  - as.character(x) : 문자화
  - as.integer(x) : 정수화
  - as.double(x) : 실수화
  - as.numeric(x) : 수치화
  - as.complex(x) : 복소수화
  - as.logical(x) : 논리화



- [자료형 or 구조확인 함수]
  - class(x)
  - str(x)
  - mode(x)
  - typeof(x)



## (3) R의 데이터셋

> 벡터(Vector)+팩터(Factor), 행렬(Matrix), 배열(Array) / 데이터프레임(Dataframe) / 리스트(List)

![image-20200907110451458](C:\Users\user\AppData\Roaming\Typora\typora-user-images\image-20200907110451458.png)

![image-20200907192909228](C:\Users\user\AppData\Roaming\Typora\typora-user-images\image-20200907192909228.png)



### (I) 벡터(Vector)

![image-20200907160044178](C:\Users\user\AppData\Roaming\Typora\typora-user-images\image-20200907160044178.png)

- 데이터셋(데이터 구조)으로서 1차원으로 사용된다. 하나의 데이터 값도 벡터로 취급된다.

- <span style="color:red">**동일 타입의 데이터만으로 구성**</span>
- 벡터 생성 방법 : c(), seq(), rep(), ':' 연산자
- 내장 상수 벡터들 : pi, LETTERS, letters, month.name, month.abb
- **인덱싱** :  **1부터 시작**
- 주요 함수 : length(), names(), sort(), order() ...

```R
##### Vector #####
v1 <- 1:10
v1
1:100 # 100:1

v2 <- v1 + 100 # 101, 102, 103, 104, 105

v5 <- c(100,200,"삼백",400) # 같은타입의 데이터로만 구성되야함. 따라서 모든 원소들이 문자형으로 자동형변환

seq(1, 10) #마지막 숫자 포함
seq(1, 10, 2)

rep(1, 10) # 1을 10번 반복
rep(1:3, 3) # 1 2 3 1 2 3 1 2 3 
rep(1:3, times=3)
rep(1:3, each=5) # 1 1 1 2 2 2 3 3 3


# 내장함수
LETTERS[1] # "A"
LETTERS[3:5]; LETTERS[5:3] # "C" "D" "E" ; "E" "D" "C"
LETTERS[c(3,4,5)] # "C" "D" "E"
LETTERS[-1] # 첫번째 "A" 만 빼고 나머지 모두


# 정렬 & 기초통계량
x <- c(10, 2, 7, 4, 15); class(x) # numeric, 데이터의 타입 체크
range(x) # MIN & MAX 반환

sort(x) # 기존 벡터 자체를 정렬시키지않고 정렬된 새로운 벡터 반환
sort(x, decreasing = T)
x <- sort(x) # 기존 벡터를 정렬해서 대입

order(x) # 오름차순 기반으로 가장작은 값부터의 인덱스를 알려준다
		 # order()는 Dataframe 정렬에서 사용한다
		 # sort()는 Datafram에서 사용할 수 없다

# 내림차순 정렬을 rev()로 하고 싶으면 기존 벡터를 오름차순으로 바꾼 후 rev()
x <- sort(x)
rev(x)

max(x); min(x); mean(x); sum(x)
summary(x)


# 원소 이름지정, 딕셔너리의 키 지정과 비슷
names(x)
names(x) <- LETTERS[1:5]
names(x) <- NULL #이름 지정 해제
x[2]; x["B"]


# 데이터 추출
x[c(2,4)] # x[2], x[4]
x[c(F,T,F,T,F)] # TRUE만 반환
x[c(T,F)] # T F T F T 반복
x > 5 # F F T T T
x[x > 5] # 3, 4, 5번째 데이터만 꺼내옴 (즉 x벡터에서 5보다 큰 데이터만 추출)
x[x > 5 & x < 15] # & : 원소마다 연산
x[x > 5 && x < 15] # && : 첫번째 원소 하나만 비교연산

rainfall <- c(21.6, 23.6, 45.8, 77.0, 
              102.2, 133.3,327.9, 348.0, 
              137.6, 49.3, 53.0, 24.9)
rainfall > 100 # T or F 반환
rainfall[rainfall > 100] # 100보다 큰 데이터 값을 추출


# which, 조건이 TRUE인 데이터의 인덱스를 추출
which(rainfall > 100) # 100보다 큰 데이터이 인덱스를 추출
month.name[which(rainfall > 100)]
month.abb[which(rainfall > 100)]
month.korname <- c("1월","2월","3월",
                   "4월","5월","6월",
                   "7월","8월","9월",
                   "10월","11월","12월")
month.korname[which(rainfall > 100)]
which.max(rainfall) #최대값 인덱스 반환
which.min(rainfall) #최소값 인덱스 반환
month.korname[which.max(rainfall)]
month.korname[which.min(rainfall)]


# 샘플 추출, random 함수와 비슷
sample(1:45, 6) # 1~45 까지 중에 6개 샘플을 추출 (중복X)
sample(1:45, 6, replace=T) # 중복 허용


# paste, 아규먼트로 주어진 문자열들을 하나로 결합
paste("I'm", "Duli", "!!") # 벡터 3개의 결합
paste("I'm", "Duli", "!!", sep="")
paste0("I'm", "Duli", "!!") #paste0 문자결합시 공백제로

fruit <- c("Apple", "Banana", "Strawberry")
food <- c("Pie", "Juice", "Cake")
paste(fruit, food) # "Apple Pie" "Banana Juice" "Strawberry Cake"
paste(fruit, food, sep="") # "ApplePie" "BananaJuice" "StrawberryCake"
paste(fruit, food, sep="", collapse=":::") #하나의 문자열로 결합
# "ApplePie:::BananaJuice:::StrawberryCake"


#########################################
ls() # 지금까지 만들어져있는 객체들을 return
rm(x) # 객체 x 삭제
#########################################
```



### (II) 행렬(Matrix)

![image-20200907160059400](C:\Users\user\AppData\Roaming\Typora\typora-user-images\image-20200907160059400.png)

- 2차원 벡터
- <span style="color:red">**동일 타입의 데이터만으로 구성**</span>

- 인덱싱 : [**행 인덱싱**, **열 인덱싱**], [행 인덱싱, ], [, 열 인덱싱],

  ​			   **drop 속성 - 행렬구조 유지여부**

- 행렬 생성방법

  - matrix(data=벡터, nrow=행 개수, ncol=열 개수)
  - matrix(data=벡터, nrow=행 개수, ncol=열 개수, **byrow=TRUE**) #행부터 채운다
  - rbind(v1, v2, v3...) : 행 단위로 벡터들을 붙여감
  - cbind(v1, v2, v3...) : 열 단위로 벡터들을 붙여감

- dim(matrix) : 행렬이 몇차원인지 체크 (nrow(행렬) or ncol(행렬))

- colnames(m), rownames(m), rowSums(m), colSums(m), rowMeans(m), colMeans(m)

```R
##### Matrix #####
x1 <-matrix(1:8, nrow = 2) # matrix(1:8), 열부터 채우기 때문에 8행 1열 행렬 생성 
x1
x1 <- x1 * 3
x1

sum(x1); min(x1); max(x1); mean(x1)

x2 <- matrix(1:8, nrow =3) # 3x3 위치의 데이터가 없지만 경고띄우고 알아서 채움 
x2


# 행렬 생성
(chars <- letters[1:10])

mat1 <- matrix(chars)
mat1; dim(mat1) #10행 1열
matrix(chars, nrow=1)
matrix(chars, nrow=5)
matrix(chars, nrow=5, byrow=T)
matrix(chars, ncol=5)
matrix(chars, ncol=5, byrow=T)
matrix(chars, nrow=3, ncol=5)
matrix(chars, nrow=3)


vec1 <- c(1,2,3)
vec2 <- c(4,5,6)
vec3 <- c(7,8,9)
mat1 <- rbind(vec1,vec2,vec3); mat1
mat2 <- cbind(vec1,vec2,vec3); mat2
mat1[1,1]
mat1[2,]; mat1[,3]
mat1[1,1, drop=F] # 매트릭스 구조를 깨트리지 말아라
mat1[2,, drop=F]; mat1[,3, drop=F]

rownames(mat1) <- NULL # 행 이름 삭제
colnames(mat2) <- NULL # 열 이름 삭제
mat1; mat2
rownames(mat1) <- c("row1","row2","row3")
colnames(mat1) <- c("col1","col2","col3")
mat1


# 행렬 기초통계량
mean(x2)
sum(x2)
min(x2)
max(x2)
summary(x2) # 열 단위 요약

mean(x2[2,])
sum(x2[2,])
rowSums(x2); colSums(x2)


# apply(적용할 매트릭스, 행단위(1)/열단위(2), sum)
# R도 argument로 함수를 전달할 수 있는 고차함수를 지원
apply(x2, 1, sum); apply(x2, 2, sum)
?apply
apply(x2, 1, max)
apply(x2, 1, min)
apply(x2, 1, mean)

apply(x2, 2, max)
apply(x2, 2, min)
apply(x2, 2, mean)

```





### (III) 배열(Array)

![image-20200907160156940](C:\Users\user\AppData\Roaming\Typora\typora-user-images\image-20200907160156940.png)

- 3차원 벡터
- <span style="color:red">**동일 타입의 데이터만으로 구성**</span>
- 인덱싱 : [행 인덱싱, 열 인덱싱, **층(면) 인덱싱**]

```R
##### Array #####
a1 <- array(1:30, dim=c(2,3,5)) # 1~30, 2행 3열 5층
a1

a1[1,3,4]
a1[,,3]
a1[,2,]
a1[1,,]
```
