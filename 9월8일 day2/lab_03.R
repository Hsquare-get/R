#문제1
iris
str(iris) # 데이터프레임 구조 확인


#문제2
df1 <- data.frame(x=c(1,2,3,4,5), y=seq(2,10,2)); df1


#문제3
col1 <- c(1,2,3,4,5)
col2 <- letters[1:5]
col3 <- c(6,7,8,9,10)
df2 <- data.frame(col1, col2, col3); df2


#문제4
제품명 <- c("사과", "딸기", "수박")
가격 <- c(1800, 1500, 3000)
판매량 <- c(24, 38, 13)
df3 <- data.frame(제품명, 가격, 판매량, stringsAsFactors=F)
str(df3)


#문제5
sum(df3$가격) # 과일 가격 총합

mean(df3$가격) # 과일 가격 평균
mean(df3$판매량) # 과일 판매량 평균


#문제6
name <- c("Potter", "Elsa", "Gates", "Wendy", "Ben")
gender <- factor(c("M", "F", "M", "F", "M"))
math <- c(85, 76, 99, 88, 40)
df4 <- data.frame(name, gender, math); df4; str(df4)

df4$stat <- c(76, 73, 95, 82, 35); df4 #파생변수
df4$score <- df4$math + df4$stat; df4
df4$grade <- ifelse(df4$score>=150, "A",
                    ifelse(df4$score>=100, "B",
                           ifelse(df4$score>=70, "C", "D")))
df4$grade <- factor(df4$grade)
df4; str(df4); summary(df4)


#문제7
getwd()
emp <- read.csv("data/emp.csv"); str(emp)


#문제8
emp[c(3,4,5),] # 3,4,5 행만 출력
emp[3:5,]
emp[seq(3,5),]


#문제9 
emp[-4] # 4번열 제외


#문제10
emp$ename # ename열만 출력
emp[2]
emp["ename"]

emp[,2]
emp[,2, drop=F]
emp[,"ename"]
emp[,"ename", drop=F]


#문제11
emp[, c("ename", "sal")]
subset(emp, select=c("ename", "sal"))
subset(emp, select=c(ename, sal)) # subset함수의 특성으로 인용부호 안붙여도됨


#문제12
emp
subset(emp, subset=(emp$job=="SALESMAN"), select=c("ename", "sal", "job"))


#문제13
emp
subset(emp, subset=(emp$sal>=1000 & emp$sal<=3000), select=(c("ename", "sal", "deptno")))


#문제14
emp
emp[emp$job != "ANALYST", c("ename", "job", "sal")]


#문제15
emp
emp[emp$job == "SALESMAN" | emp$job == "ANALYST", c("ename", "job")]


#문제16
emp
emp[is.na(emp$comm), c("ename", "sal")]


#문제 17
emp[order(emp$sal),] # 데이터프레임에서는 sort대신 order(인덱스)
?order
emp[order(emp$sal, decreasing=T),] # 월급 많은순으로 정렬
emp[which.max(emp$sal),] # 월급 제일 많은 사람의 정보들

#문제 18
str(emp)
dim(emp) #행과 열의 개수
