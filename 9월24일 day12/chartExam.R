library(rJava)
library(RJDBC)
library(DBI)

library(showtext)
showtext_auto() # 자동설정 필수
font_add(family = "cat", regular = "fonts/HoonWhitecatR.ttf")
font_add(family = "dog", regular = "fonts/THEdog.ttf")
font_add(family = "maple", regular = "fonts/MaplestoryBold.ttf")


# 드라이버 설정
drv <- JDBC(driverClass = 'org.mariadb.jdbc.Driver', 'mariadb-java-client-2.6.2.jar')
# MariaDB 연결
conn <- dbConnect(drv, 'jdbc:mariadb://127.0.0.1:3306/work', 'scott', 'tiger')

dbReadTable(conn, "productlog")

query <- "SELECT * FROM productlog"
productlog_table <- dbGetQuery(conn, query); productlog_table
str(productlog_table); head(productlog_table, n=5)
View(productlog_table)


##### [문제 1] #####
pid <- as.factor(productlog_table$pid) # pid <- table(productlog_table$pid)
clicknumbers <- summary(pid) # summary 자체가 네임드 벡터
names(clicknumbers)

barplot(clicknumbers, main="세로바 그래프 실습", xlab="상품ID", ylab="클릭수",
        names.arg=names(clicknumbers), col=terrain.colors(10), family="dog")

getwd()
dev.copy(png, "clicklog1.png")
dev.off()


##### [문제 2] #####
str(productlog_table); head(productlog_table, n=5)
View(productlog_table)

productlog_table$clicktime <- strptime(productlog_table$clicktime, format="%Y%m%d%H%M")
str(productlog_table); head(productlog_table)

hour <- as.numeric(substr(productlog_table$clicktime, 12, 13)); hour
clicktimeinfo <- summary(factor(hour)) # summary 자체가 네임드 벡터
labelnames <- as.numeric(names(clicktimeinfo))

pie(clicktimeinfo, main="파이그래프 실습", col=rainbow(17),
    labels=paste0(labelnames, "~", (labelnames+1)))

getwd()
dev.copy(png, "clicklog2.png")
dev.off()


##### [문제 3] #####
record <- read.table("data/성적.txt", header=T)
str(record[3:5])

boxplot(record[3:5], col=rainbow(3), axes=F)
axis(1, at=c(1,2,3), lab=names(record[3:5]), family="maple")
axis(2, at=seq(2,10, 2))
title("과목별 성적 분포", col.main="yellow", family="maple", cex.main=2)
box()

getwd()
dev.copy(png, "clicklog3.png")
dev.off()
