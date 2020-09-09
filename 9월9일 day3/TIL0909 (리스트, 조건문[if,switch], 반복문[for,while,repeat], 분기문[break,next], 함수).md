# TIL0909 (R의 자료형_리스트 / 조건문[if,switch], 반복문[for,while,repeat], 분기문[break,next] / 함수)

## (3) R의 데이터셋

### (VI) 리스트(List)

![image-20200909093745545](C:\Users\user\AppData\Roaming\Typora\typora-user-images\image-20200909093745545.png)

- 모든 유형의 객체 집합

- <span style="color:red;">저장 가능한 데이터의 타입, 데이터 셋의 종류에 제한이 없다.</span>

- 벡터, 행렬, 배열, 데이터프레임, 함수까지 서로 다른 구조의 데이터를 하나로 묶을 수 있는 자료구조

- R에서는 통계 분석 결과가 리스트 구조로 제시되는 경우가 많으며 서로 다른 구조의 다수의 데이터 객체를 개별로 관리하기보다는 리스트라는 하나의 바구니에 정리해서 관리하는 것이 권장된다.

- 리스트 생성

  - list()

- 인덱싱(추출)

  - a[1:2] 리스트 안의 하위 리스트를 <span style="color:red;">**리스트에 담아서 꺼내온다**</span>

  - <span style="color:red;">a[[1]]</span>, <span style="color:red;">a$b</span> 하위 리스트가 포함한 **원소를 추출**하고, **계층구조를 한 단계 벗겨낸다**.

  - <span style="color:red;">unlist()</span> : 리스트 해제, 리스트를 벡터로 반환한다 

    ​			   (기존 리스트가 아닌 새로운 벡터로 반환 **≒ sort**)

![image-20200909092711655](C:\Users\user\AppData\Roaming\Typora\typora-user-images\image-20200909092711655.png)

```R
# 리스트 생성과 인덱싱(추출)
a <- list(
	a = 1:3, # 열이름 a,b,c,d
	b = "a string",
	c = pi,
	d = list(-1,-5)
	)

a[[2]]; a$b; a[4]; a[[4]]; a[[4]][1]; a[[4]][[1]]

```



```R
##### LIST #####
v <- c(1,2,3); v
l <- list(1,2,3); l # 1 벡터, 2 벡터 3 벡터 각각의 데이터셋으로 인식

v[1] # 1
l[1] # list(1), 리스트로 담아서 추출
l[[1]] # 1

lds <- list(1,2,3); lds
lds + 100 # 연산불가

unlist(lds) # 1 2 3
unlist(lds) + 100 # 101 102 103

lds[1] # list(1)
lds[1] + 10 # 리스트로 담아와서 연산불가
lds[[1]] + 10 # 11

# 데이터셋 이름 부여
names(lds) <- LETTERS[1:3]
lds
lds[[2]]
lds[["B"]]
lds$B

#문제4 (lab_04.R)
L4 <- list(
  alpha = 0:4,
  beta = sqrt(1:5),
  gamma = log(1:5)
)
print(L4)

L4[1] + 10 # 리스트로 담아와서 연산 불가
L4[[1]] + 10
L4[["alpha"]] + 10
L4$alpha + 10

a <- list(
    a = 1:3,
    b = "a string",
    c = pi,
    d = list(-1,-5)
); a

a[1]
a[[1]] # a[["a"]]
a$a
a[[1]][1]
a$a[1]
a[1] + 1
a[[1]] + 1
a[[1]][2] <- 100
new_a <- unlist(a[1])
a[1]; new_a
names(a) <- NULL
names(new_a) <- NULL

```



## (6) 제어문

### (I) 조건문 if

```R
# if
if (조건)
    수행명령문장

# else
if (조건)
	수행명령문장1
else {
    수행명령문장2
    수행명령문장3
    }

# else if
if (조건1)
    수행명령문장1
else if(조건2)
    수행명령문장2
else if(조건3)
    수행명령문장3
else
    수행명령문장4
    
# ifelse 함수
ifelse(조건, 조건이 참일 때 명령문1, 조건이 거짓일 때 명령문2)
    
# switch 함수
switch(EXPR=수치데이터, 식1, 식2, 식3...)
switch(EXPR=문자열데이터, 비교값1=식1, 비교값2=식2, 비교값3=, 비교값4=식3, 식4)
													# 그외의 모든 값을 default=식4

```



```R
# if else
randomNum <- sample(1:10,1)
if(randomNum>5){
  cat(randomNum, ":5보다 크군요","\n")
}else{
  cat(randomNum, ":5보다 작거나 같군요","\n")
}

if(randomNum%%2 == 1){
  cat(randomNum, ";홀수\n")
}else{
  cat(randomNum, ";짝수\n")
}

if(randomNum%%2 == 1){
  cat(randomNum, ";홀수","\n")
}else{
  cat(randomNum, ";짝수","\n")
}


score <- sample(0:100, 1) # 0~100 숫자 한 개를 무작위로 뽑아서
if (score >= 90){
  cat(score, "는 A등급입니다","\n")
}else if (score >= 80){
  cat(score, "는 B등급입니다","\n")
}else if (score >= 70){
  cat(score, "는 C등급입니다","\n")
}else if (score >= 60){
  cat(score, "는 D등급입니다","\n")
}else {
  cat(score, "는 F등급입니다","\n")
}

```



```R
# switch 문을 대신하는 함수
month <- sample(1:12,1)
month <- paste(month,"월",sep="") # "3월"
result <- switch(EXPR=month,
                 "12월"=,"1월"=,"2월"="겨울",
                 "3월"=,"4월"=,"5월"="봄",
                 "6월"=,"7월"=,"8월"="여름",
                 "가을")
cat(month, "은 ", result, "입니다\n", sep="")

num <- sample(1:10,1); num
switch(EXPR=num, "A", "B", "C", "D") # 1:A, 2:B, 3:C, 4:D


# 5~10이면 switch함수의 결과로 아무것도 출력되지 않는다
for(num in 1:10){
  cat(num, ":", switch(EXPR=num, "A", "B", "C", "D"), "\n")
}

for(num in 1:10){
  num <- as.character(num) 
  cat(num, ":", switch(EXPR=num,
                       "7"="A", "8"="B", "9"="C", "10"="D", "ㅋ"), "\n")
}

```



### (II) 반복문 for, while, repeat

```R
# for문
# for (변수 in 데이터셋)
#     수행명령문장

for(data in month.name) 
  print(data) # 데이터셋 출력

for(data in month.name) 
  cat(data) # 메시지 출력
  #cat(data, "\n")

sum <- 0
for(i in 5:15){
  if(i%%10==0){
    break
  }
  sum <- sum + i
  print(paste(i,":",sum))
}

sum <- 0
for(i in 5:15){
  if(i%%10==0){
    break
  }
  sum <- sum + i
  cat(i,":",sum,"\n")
}

sum <-0
for(i in 5:15){
  if(i%%10==0){
    next;  #continue
  }
  sum <- sum + i
  print(paste(i,":",sum))
}

```



```R
# for 실습
for(data in month.name) 
  print(data)
for(data in month.name)print(data);print("ㅋㅋ")
for(data in month.name){print(data);print("ㅋㅋ")}


for(n in 1:5)
  cat("hello?","\n")

for(i in 1:5){
  for(j in 1:5){
    cat("i=",i,"j=",j,"\n")
  }
}

# 구구단
for(dan in 1:9){
  for(num in 1:9){
    cat(dan,"x",num,"=",dan*num,"\n") # \n : 개행문자, \t : 탭문자
  }
  cat("\n")
}

# 가장 가까운 반복문 하나만 종료
for(i in 1:9){
  for(j in 1:9){
    if(i*j>30){
      break
    } 
    cat(i,"*",j,"=",i*j,"\n")
  }
  cat("\n")
}

# 변수를 써서 모든 반복문 종료
bb <- F
for(i in 1:9){
  for(j in 1:9){
    if(i*j>30){
      bb<-T
      break
    } 
    cat(i,"*",j,"=",i*j,"\n")
  }
  cat("\n")
  if(bb) #bb가 TRUE이면
    break
}

```



---



```R
# while문
# while (조건)
#     수행명령문장

sumNumber <- 0
while(sumNumber <= 20) { 
  i <- sample(1:5, 1) 
  sumNumber <- sumNumber+i; 
  cat(sumNumber,"\n")
}

```



```R
# while문
i<-1
while(i <= 10){
  cat(i,"\n")
  i <- i+1
}
cat("종료 후 i :",i,"\n")

i<-1
while (i<=10) {
  cat(i,"\n")
}

i<-1
while (i<=10) {
  cat(i,"\n")
  i<-i+2 # 결국 i 제어로 반복횟수 결정 가능
}

```



---



```R
# repeat 명령문 # while TRUE
 			   # 적어도 한 번 이상 명령문을 수행 
			   # 무한루프탈출 분기문을 반드시 포함

repeat {
  cat("ㅋㅋㅋ\n")
}

# 무한루프 탈출
sumNumber <- 0
repeat { 
  i <- sample(1:5, 1) 
  sumNumber <- sumNumber+i; 
  cat(sumNumber, "\n")
  if(sumNumber > 20)
    break;
}

```



### (III) 분기문

```R
break
	해당 반복문(루프) 종료, 가장 가까운 반복문 하나만 종료
next
	현재 반복을 종료하고 다음 반복문으로 이동 # continue 대신 next
```



## (7) 함수

- 특정 작업을 독립적으로 수행하는 프로그램 코드 집합 (반복연산을 효율적처리)

- print() : <span style="color:red;">하나의 숫자 또는 문자를 출력해주는 함수</span>

- cat() : <span style="color:red;">여러 숫자 또는 문자를 출력해주는 함수</span>, 자동 개행X (개행해주려면 \n )

```R
# 함수정의(익명함수)
함수이름 <- function([매개변수]) {
    수행명령문장
    [return (리턴하려는 값)]
}

# 함수호출
변수명 <- 함수명()
함수명()

```

- **리턴할 데이터셋이 없으면 NULL을 리턴함**
- return() 문이 생략된 경우에는 마지막으로 출력된 데이터 값이 자동으로 리턴된다. (권장X)
- <span style="color:red;">아규먼트의 타입을 제한</span>하려는 경우에는 **is.XXX()** 함수를 활용
- **함수내에서 전역변수에 값을 저장**하려는 경우 대입연산자로 **<span style="color:red;"><<-</span>** 을 사용



```R
# 함수의 정의와 호출 예제들
f1 <- function() print("TEST"); f1()

f2 <- function(num) {print("TEST"); print(num)}; f2(100) 

f3 <- function(p="R") print(p)
f3() # 아규먼트를 생략하면 p="R" 기본값 
f3(p="PYTHON")

f4 <- function(p1="ㅋㅋㅋ",p2) # p1="ㅋㅋㅋ"(default)
    for(i in 1:p2)
        print(p1)
f4(p1="abc", p2=3), f4("abc", 3)
f4(5) # 호출 불가
f4(p2=5) # 호출 가능

```

