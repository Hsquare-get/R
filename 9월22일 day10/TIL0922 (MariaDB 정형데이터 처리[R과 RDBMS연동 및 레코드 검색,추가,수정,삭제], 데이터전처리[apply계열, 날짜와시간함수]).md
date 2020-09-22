# TIL0922 (MariaDB 정형데이터 처리[R과 RDBMS연동 및 레코드 검색,추가,수정,삭제] / 데이터전처리[apply계열, 날짜와시간함수])

# (0) 패키지

```R
# 새로운 R 패키지 설치
install.packages("패키지명")

# 이미 설치된 R 패키지 확인
installed.packages()
library()

# 설치된 패키지 삭제
remove.packages("패키지명")

# 설치된 패키지의 버전 확인
packageVersion("패키지명")

# 설치된 패키지 업데이트
update.packages("패키지명")

# 설치된 패키지 로드
library(패키지명)
require(패키지명)

# 로드된 패키지 언로드
detach("package:패키지명")

# 로드된 패키지 점검
search()
```



# (1) Maria DB

> oracle에 먹혀서 거의 유료화된 MySQL 기능을 무료로 사용가능 (license free)
>
> MariaDB는 MySQL과 같은 소스 코드를 기반으로 만들어진 오픈소스의 관계형 데이터베이스 관리 시스템(RDBMS)으로 사용방법과 구조도 MySQL과 거의 동일 (MySQL과 높은 호환성)
>
> (컴퓨터 전원이켜지면 MariaDB 자동으로 기동)

```mariadb
# [접속방법1_계정으로 접속]
# C:\Windows\System32>mysql -u root -p # 계정이 root인 user
```

```mariadb
# [접속방법2]
# Enter password: bigdata
# Commands end with ';' or '\g'
show databases; # 기본 데이터베이스 보기
use test; # test 데이터베이스 사용
show tables; # 'test' 데이터베이스 내의 테이블 목록 보기, Empty set(테이블 없음)

create database work; # 'work' 데이터베이스 생성
show databases;
use work;

# 4개의 column을 가지는 goods 테이블 생성
create table goods(
    code int primary key,
    name varchar(20) not null, # varchar, 실제 저장되는 바이트 수만큼만 저장
    su int,
    dan int
);

# insert 명령으로 goods 테이블에 레코드를 추가
insert into goods values(1, '냉장고', 2, 850000);
insert into goods values(2, '세탁기', 3, 550000);
insert into goods values(3, '전자레인지', 2, 350000);
insert into goods values(4, 'HDTV', 3, 1500000);

# select 명령으로 레코드 조회
select * from goods;

```



> MariaDB를 사용하면서 사용자 계정으로 MariaDB의 관리자인 "root" 계정을 이용하고 있다. 사용자 계정을 만들고, 등록된 사용자에게 권한을 설정한다.

```mariadb
# localhost에 scott이라는 사용자 계정만들기(비밀번호는 tiger)
create user 'scott'@'localhost' identified by 'tiger';

# work 데이터 베이스에서 'scott'@'localhost'에게 모든 권한을 부여
grant all privileges on work.* to 'scott'@'localhost';

# 사용자 생성 마무리
flush privileges;

quit
```



---



## (I) R과 RDBMS 연동

> R이라는 언어로 데이터베이스에 테이블 생성, 데이터 삽입, 데이터 수정, 데이터 삭제, 테이블 삭제, 데이터 추출 등의 작업을 프로그래밍(구현)하는 것을 말한다

1. 드라이버 프로그램 로딩 `JDBD()`

   (드라이버 프로그램이란 R, Java, Python 등의 언어로 DB를 연동할 때 여러가지 세부적인 작업을 대신 수행해주는 프로그램)

2. MariaDB 서버에 접속(연결) `dbConnect()`

3. 수행하려는 CRUD에 알맞는 SQL 명령을 처리하거나 API에서 제공하는 함수를 이용하여 처리한다`dbGetQuery()`, `dbSendUpdate()`, `dbWriteTable()`, `dbReadTable()`, `dbRemoveTable()`
4. MariaDB 서버 접속(연결) 해제 `dbDisconnect()`

```R
# RJDBC 패키지를 사용하기 위해서는 Java 응용프로그램을 실행할 수 있는 실행환경이 요구된다. 
# rJava 패키지를 로드한 뒤에 RJDBC 패키지를 로드해야한다.
install.packages("rJava")

# 데이터베이스 서버에 접속하는데 필요한 함수를 제공
# Java 언어로 만들어진 R 패키지 프로그램으로 DBMS에 연결하기 위해서 JDBC의 API를 지원한다.
install.packages("RJDBC")

# 여러가지 SQL 명령(CRUD)수행과 관련하여 기능을 제공
install.packages("DBI")

library(rJava)
library(RJDBC)
library(DBI)

# 드라이버 설정 (working directory인 Rexam에 .jar파일이 있으면 경로 지정안해줘도 된다)
drv <- JDBC(driverClass = 'org.mariadb.jdbc.Driver', 'mariadb-java-client-2.6.2.jar')

# MariaDB 연결, dbConnect(Driver, URL, 사용자ID, 사용자PW)
conn <- dbConnect(drv, 'jdbc:mariadb://127.0.0.1:3306/work', 'scott', 'tiger')

```



## (II) 데이터베이스로부터 레코드 검색, 추가, 수정, 삭제

> dbWriteTable(conn, "emp", emp)
>
> str()로 데이터프레임 변수의 자료형을 파악해봐서 chr일 경우에는 NA를 NULL로 변환해주지만 
>
> num일 경우에는 최저값으로 대체해서 넣어주는데 이것은 DB에 따라 다를 수 있다. 
>
> (데이터베이스에는 NA를 허용하지 않는다)

```R
##### 데이터베이스로부터 레코드 검색, 추가, 수정, 삭제 #####
# 모든 레코드 조회
query <- "select * from goods"
goodsAll <- dbGetQuery(conn, query); goodsAll
dbReadTable(conn, 'goods')

# 조건검색 - 수량(su)이 3이상인 데이터
query <- "select * from goods where su >=3"
goodsOne <- dbGetQuery(conn, query); goodsOne

# 정렬검색 - 단가(dan)를 내림차순으로 정렬
query <- "SELECT * FROM goods order by dan desc"
dbGetQuery(conn, query)


##### 데이터프레임 자료를 테이블에 저장하기 #####
# 데이터프레임 자료를 테이블에 저장, dbWriteTable(db연결객체, "테이블명", 데이터프레임)
# 데이터 입력될 때부터 NA값은 최저값으로 대체해서 들어간다 (데이터베이스에는 NA를 허용하지 않는다)
insert.db <- data.frame(code=5, name='식기세척기', su=1, dan=250000)
dbWriteTable(conn, "goods", insert.db) # Error, 이미 존재하는 테이블에 저장할 수 없음
dbWriteTable(conn, "goods1", insert.db) # dbWriteTable()는 새로운 테이블을 만들고 데이터를 저장하는 함수이기 때문

query <- "select * from goods1"
goodsAll <- dbGetQuery(conn, query); goodsAll
dbReadTable(conn, 'goods1')


##### csv 파일의 자료를 테이블에 저장하기 #####
# 파일 자료를 테이블에 저장하기
recode <- read.csv("C:/Rexam/data/recode.csv")
dbWriteTable(conn, "goods2", recode)

# 테이블 조회
query <- "select * from goods2"
goodsAll <- dbGetQuery(conn, query); goodsAll


##### 테이블에 자료 추가, 수정, 삭제 #####
# 테이블에 레코드 추가
query <- "insert into goods2 values(6, 'test', 1, 1000)"
dbSendUpdate(conn, query)

query <- "select * from goods2"
goodsAll <- dbGetQuery(conn, query); goodsAll

# 테이블의 레코드 수정
query <- "update goods2 set name = '테스트' where code = 6"
dbSendUpdate(conn, query)

query <- "select * from goods2"
goodsAll <- dbGetQuery(conn, query); goodsAll

# 테이블의 레코드 삭제
delquery <- "delete from goods2 where code = 6" # where 절이 없으면 모든 행에 적용
dbSendQuery(conn, delquery)

query <- "select * from goods2"
goodsAll <- dbGetQuery(conn, query); goodsAll

```



```R
##### 예제 #####
dbWriteTable(conn, "book", data.frame(bookname=c("파이썬 정복", "하둡 완벽 입문", "R 프로그래밍"), price=c(25000, 25000, 28000)))
dbGetQuery(conn, "SELECT * FROM book")

# dbWriteTable 옵션(append, overwrite)
head(mtcars) # R 내장 데이터셋
str(mtcars)

dbSendUpdate(conn, "drop table mtcars") # 테이블 삭제
dbWriteTable(conn, "mtcars", mtcars[1:5, ])
dbReadTable(conn, "mtcars")

dbWriteTable(conn, "mtcars", mtcars[6:10, ], append = TRUE) # 이미 만들어진 테이블에 행 추가
dbReadTable(conn, "mtcars")

dbWriteTable(conn, "mtcars", mtcars[1:2, ], overwrite = TRUE) # 이미 만들어진 테이블을 새로운 테이블로 대체
dbReadTable(conn, "mtcars")


head(cars)
str(cars)
dbSendUpdate(conn, "drop table cars") # 테이블 삭제
dbWriteTable(conn, "cars", head(cars,3))
dbGetQuery(conn, "SELECT * FROM cars")


# 데이터 수정
dbSendUpdate(conn, "INSERT INTO cars(speed, dist) VALUES(1,1)")
dbSendUpdate(conn, "INSERT INTO cars(speed, dist) VALUES(2,2)")
dbReadTable(conn, "cars")

dbSendUpdate(conn, "UPDATE CARS SET DIST=DIST*100 WHERE SPEED=1")
dbReadTable(conn, "cars")
dbSendUpdate(conn, "UPDATE CARS SET DIST=DIST*3") # 모든 레코드에 적용
dbReadTable(conn, "cars")

# 테이블 삭제
dbRemoveTable(conn, "cars")

```



# (2) 데이터 전처리 - apply계열의 함수

> R에는 벡터, **행렬**, 데이터프레임에 임의의 함수를 적용한 결과를 얻기 위한 apply 계열 함수가 있다.
>
> 이 함수들은 **데이터 전체에 함수를 한번에 적용하는 벡터 연산을 수행**하므로 속도도 빠르고 구현도 간단하다.



| 함수     | 설명                                                         | 다른 함수와 비교했을 때 특징                           |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------ |
| apply()  | 배열 또는 행렬에 주어진 함수를 적용한 뒤 그 결과를 벡터,  배열 또는 리스트로 반환 | 배열 또는 행렬에 적용                                  |
| lapply() | 벡터, 리스트 또는 표현식에 함수를 적용하여 그 결과를 리스트로 반환 | **결과가 리스트**                                      |
| sapply() | lapply와 유사하나 결과를 가능한 심플한 데이터셋(벡터or리스트)으로 반환 | **결과가 심플데이터셋**                                |
| tapply() | 벡터에 있는 데이터를 특정 기준에 따라 그룹으로 묶은 뒤 각 그룹마다 주어진 함수를 적용하고 그 결과를 반환 | **데이터를 그룹으로 묶은 뒤 함수를 적용**              |
| mapply() | sapply의 확장된 버전으로, 여러 개의 벡터 또는 리스트를 인자로 받아 함수에 각 데이터의 첫째 요소들을 적용한 결과, 둘째 요소들을 적용한 결과, 셋째 요소들을 적용한 결과 등을 반환 | **여러 데이터셋의 데이터를 함수의 인자로 적용한 결과** |



- apply()는 행렬의 행 or 열 방향으로 특정 함수를 적용하는 데 사용한다.

- apply : 배열 or 행렬에 함수 FUN을 MARGIN 방향으로 적용하여 결과를 벡터, 배열 또는 리스트로 반환한다.

  ```R
  apply(
      X, # 배열 또는 행렬
      MARGIN, # 함수를 적용하는 방향(1은 행방향, 2는 열방향)
      FUN, # 적용할 함수
      ... # optional arguments to FUN
  )
  ```

  

```R
# 쉬운 예제1
d <- matrix(1:9, ncol=3); d
apply(d, 1, sum) # [1] 12 15 18, 행방향 합
apply(d, 2, sum) # [1] 6 15 24, 열방향 합
```



```R
##### 데이터 전처리 #####
# 데이터 전처리(1) - apply 계열의 함수를 알아보자
weight <- c(65.4, 55, 380, 72.2, 51, NA)
height <- c(170, 155, NA, 173, 161, 166)
gender <- c("M","F","M","M","F","F")

df <- data.frame(w=weight, h=height); df

?apply
apply(df, 1, sum)
apply(df, 1, sum, na.rm=TRUE) # 함수 뒤의 아규먼트들은 함수에 적용된다
apply(df, 2, sum, na.rm=TRUE)
lapply(df, sum, na.rm=TRUE) # 열단위로 합을 구해서 리스트로 리턴
sapply(df, sum, na.rm=TRUE) # 열단위로 합을 구해서 named vector로 심플하게 리턴
tapply(1:6, gender, sum, na.rm=TRUE) # 1,3,4 합을 구하고 2,5,6 합을 구해서 named vector로 반환
tapply(df$w, gender, mean, na.rm=TRUE)
mapply(paste, 1:5, LETTERS[1:5], month.abb[1:5])


v <- c("abc", "DEF", "TwT")
sapply(v, function(d) paste("-", d, "-", sep="")) # 가지고 있는 요소마다 적용

l <- list("abc", "DEF", "TwT")
sapply(l, function(d) paste("-", d, "-", sep=""))
lapply(l, function(d) paste("-", d, "-", sep=""))

       
flower <- c("rose", "iris", "sunflower", "anemone", "tulip")
length(flower)
nchar(flower) # nchar(), 각각의 요소마다 문자열의 길이 반환
sapply(flower, function(d) if(nchar(d) > 5) return(d))
sapply(flower, function(d) if(nchar(d) > 5) d)
sapply(flower, function(d) if(nchar(d) > 5) return(d) else return(NA))
sapply(flower, function(d) paste("-", d, "-", sep=""))
sapply(flower, function(d, n=5) if(nchar(d) > n) return(d)) # defalut n=5
sapply(flower, function(d, n=5) if(nchar(d) > n) return(d), 3) # n=3
sapply(flower, function(d, n=5) if(nchar(d) > n) return(d), n=4) # n=4

    
count <- 1
myf <- function(x, wt=T){
  print(paste(x, "(", count, ")"))
  Sys.sleep(1)
  if(wt) 
    r <- paste("*", x, "*")
  else
    r <- paste("#", x, "#")
  count <<- count + 1;
  return(r)
}

df
result <- sapply(df$w, myf)
result # sapply의 특성상 함수를 원소마다 적용하여 저장하고있다가 최종적으로 하나의 벡터(또는 리스트)로 출력
length(result)
sapply(df$w, myf, F)
sapply(df$w, myf, wt=F)
rr1 <- sapply(df$w, myf, wt=F)
str(rr1)


count <- 1
sapply(df, myf) # 데이터 프레임이 왔을 때는 열단위 통째로(하나의 열을 하나의 원소로) 함수가 호출된다
rr2 <- sapply(df, myf)
str(rr2)
rr2[1,1]
rr2[1,"w"]

```





# (3) 데이터 전처리 - 날짜와 시간관련 함수들

- 현재날짜 : Sys.Date()
- 현재날짜 및 시간 : Sys.time()
- 미국식 날짜 및 시간 : date()

- 년월일 시분초 타입의 문자열을 시간으로 변경
  - as.Date("년-월-일 시:분:초")
  - as.Date("년/월/일 시:분:초")
- 특정 포맷을 이용한 날짜 및 시간 : as.Date("날짜 및 시간 문자열", format="포맷")
- 날짜 데이터끼리 연산 가능
  - 날짜끼리 뺄셈가능, 날짜와 정수의 덧셈뺄셈 가능 (하루를 1로 간주, 소숫점 생략)
  - 날짜 데이터끼리 연산할 때 소숫점을 표현하고자 하는 경우는 as.Date 대신에 **as.POSIXct** 함수를 이용



| Symbol | Meaning                | Example |
| ------ | ---------------------- | ------- |
| %d     | day as a number (1-31) | 01-31   |
| %a     | abbreviated weekday    | Mon     |
| %A     | unabbreviated weekday  | Monday  |
| %m     | month (01-12)          | 01-12   |
| %b     | abbreviated month      | Jan     |
| %B     | unabbreviated month    | January |
| %y     | 2-digit year           | 20      |
| %Y     | 4-digit year           | 2020    |



```R
# 데이터 전처리(2) - 날짜와 시간 관련 기능을 지원하는 함수들
(today <- Sys.Date()) # "2020-09-22"
str(today)
format(today, "%Y년 %m월 %d일") # "2020년 09월 22일"
format(today, "%d일 %B %Y년") # "22일 9월 2020년"
format(today, "%y") # "20"
format(today, "%Y") # "2020"
format(today, "%B") # "9월"
format(today, "%a") # "화"
format(today, "%A") # "화요일"
weekdays(today) # "화요일"
months(today) # "9월"
quarters(today) # "Q3"
unclass(today)  # 1970-01-01을 기준으로 얼마나 날짜가 지났지는 지의 값을 가지고 있다.
Sys.Date() # "2020-09-22"
Sys.time() # "2020-09-22 16:37:52 KST"
Sys.timezone() # "Asia/Seoul"

# format 은 생략 가능
as.Date('1/15/2018', format = '%m/%d/%Y') # "2018-01-15"
as.Date('4월 26, 2018', format = '%B %d, %Y') # "2018-04-26"
as.Date('110228', format = '%d%b%y') # NA, %b는 숫자 한자리만 표현
as.Date('110228', format = '%d%m%y') # "2028-02-11"
as.Date('11228', format = '%d%b%y') # "2028-02-11"

```

