library(rJava)
library(RJDBC)
library(DBI)
# library(datasets)
# data(iris), iris 내장 데이터셋 초기화

# 드라이버 설정
drv <- JDBC(driverClass = 'org.mariadb.jdbc.Driver', 'mariadb-java-client-2.6.2.jar')
# MariaDB 연결
conn <- dbConnect(drv, 'jdbc:mariadb://127.0.0.1:3306/work', 'scott', 'tiger')


# (1) R 내장 iris 데이터셋 구조와 상위 데이터 6개 확인
str(iris); head(iris, n=6)
View(iris)


# (2) iris 데이터셋의 변수명 변경 (데이터베이스에서는 . 연산자를 변수로 사용할 수 없기 때문에)
names(iris) # names(iris)[i] <- c("colName")
names(iris) <- c("slength", "swidth", "plength", "pwidth", "species"); head(iris)


# (3) 변수명을 변경한 iris를 MariaDB 서버에 iris라는 테이블명으로 저장
dbWriteTable(conn, "iris", iris)


# (4) iris 테이블의 모든 데이터를 읽어서 iris_all에 저장
query <- "SELECT * FROM iris"
iris_all <- dbGetQuery(conn, query); iris_all

dbReadTable(conn, "iris")


# (5) iris 테이블에서 species가 ‘setosa’인 데이터들만 추출하여 iris_setosa에 저장
query <- "SELECT * FROM iris WHERE species='setosa'"
iris_setosa <- dbGetQuery(conn, query); iris_setosa


# (6) iris 테이블에서 species가 ‘versicolor’인 데이터들만 추출하여 iris_versicolor에 저장
query <- "SELECT * FROM iris WHERE species='versicolor'"
iris_versicolor <- dbGetQuery(conn, query); iris_versicolor


# (7) iris 테이블에서 species가 ‘virginica’인 데이터들만 추출하여 iris_virginica에 저장
query <- "SELECT * FROM iris WHERE species='virginica'"
iris_virginica <- dbGetQuery(conn, query); iris_virginica


# (8) "data/product_click.log" 데이터 파일을 읽어서 productdf라는 데이터프레임을 생성
# read.csv, 첫번째 행을 헤더로 인식해서 읽어온다
# read.table, 데이터프레임 형식으로 읽어온다(헤더가 없으면 자동으로 열이름을 붙여준다)
clicklog <- read.table("C:/Rexam/data/product_click.log")
productdf <- data.frame(clicklog)
str(productdf); View(productdf)


# (9) productdf 데이터셋의 변수명을 변경
names(productdf)[1] <- c("clicktime")
names(productdf)[2] <- c("pid")
str(productdf); View(productdf)


# (10) 변수명을 변경한 productdf를 MariaDB 서버에 productlog라는 테이블명으로 저장
dbWriteTable(conn, "productlog", productdf)
dbReadTable(conn, "productlog")


# (11) 상품 id가 ‘p003’인 데이터들만 추출하여 p003이라는 변수에 저장
query <- "SELECT * FROM productlog WHERE pid='p003'"
p003 <- dbGetQuery(conn, query); p003


# (12) "data/emp.csv" 데이터 파일을 읽어서 emp라는 데이터프레임을 생성
emp <- data.frame(read.csv("C:/Rexam/data/emp.csv"))
str(emp); View(emp)


# (13) emp를 MariaDB 서버에 emp라는 테이블명으로 저장
# 데이터 입력될 때부터 NA값은 최저값으로 대체해서 들어간다 (데이터베이스에는 NA를 허용하지 않는다)
dbWriteTable(conn, "emp", emp)
dbReadTable(conn, "emp")


# (14) emp 테이블에서 월급이 높은 순으로 데이터를 읽어와서 result1에 저장
query <- "SELECT * FROM emp ORDER BY sal desc"
result1 <- dbGetQuery(conn, query); result1


# (15) emp 테이블에서 입사한지 오래된 순으로 데이터를 읽어와서 result2에 저장
query <- "SELECT * FROM emp ORDER BY hiredate asc"
result2 <- dbGetQuery(conn, query); result2


# (16) emp 테이블에서 월급이 2000 이상인 데이터를 읽어와서 result3에 저장
query <- "SELECT * FROM emp WHERE sal >= 2000"
result3 <- dbGetQuery(conn, query); result3


# (17) emp 테이블에서 월급이 2000 이상이고 3000 미만인 데이터를 읽어와서 result4에 저장
query <- "SELECT * FROM emp WHERE sal >= 2000 AND sal < 3000" # "SELECT * FROM emp WHERE (sal >= 2000 && sal < 3000)"
result4 <- dbGetQuery(conn, query); result4
str(result4)
