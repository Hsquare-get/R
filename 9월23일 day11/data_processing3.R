# 문제 1
my_birthday <- as.Date("1994-03-17", format = "%Y-%m-%d"); str(my_birthday)
mother_birthday <- as.Date("1967-06-02", format = "%Y-%m-%d")

cat("최현호", " 는 ", format(my_birthday, "%a"), "요일에 태어났어요", "\n", sep="")
cat("마더", " 는 ", format(mother_birthday, "%a"), "요일에 태어났어요", "\n", sep="")


# 문제 2
today <- Sys.Date()
x <- format(today, "%Y년 %m월 %d일")
unclass(today - my_birthday)
y <- unclass(today - my_birthday)[1]

cat("오늘은 ", x, " 이고 내가 태어난지 ", y, "일째되는 날이당", "\n", sep="")


# 문제 3
current_time <- Sys.time()
format(current_time, format = "%Y년 %m월 %d일 %H시 %M분 %S초")


# 문제 4
df <- data.frame(datetime = c('12/25/2020 23:59:59', '1/25/2021 23:59:59', '2/25/2021 23:59:59'))
str(df)

df$datetime <- strptime(df$datetime, format="%m/%d/%Y %H:%M:%S")
View(df)

# 문제 5
start <- as.Date("2020-06-01")
end <- as.Date("2020-06-07")
day <- seq(start, end, 1)
format(day, "%a-%m%d")


# 하루는 86400s
oneday <- as.POSIXlt("2020-06-01"); str(oneday)

yoil <- c()
days <- c()
for (x in seq(0,518400, 86400)) {
  yoil <- c(yoil, (format(oneday + x, "%a")))
  days <- c(days, (format(oneday + x, "%m%d")))
}
yoil; days

for (i in 1:7) {
  processed_day <- paste0(yoil, "-", days)
}
processed_day


# 문제 6
v1 <- c("Happy", "Birthday", "to", "You"); v1
length(v1) + sum(nchar(v1)) # 22, 벡터의 길이 4와 각 요소별 문자수의 합


# 문제 7
v2 <- paste(v1, collapse=" "); v2
length(v2) + nchar(v2) # 22, 벡터의 길이 1과 문자열 길이의 합


# 문제 8
constv <- 1:10; LETTERS[1:10]
v3 <- paste(LETTERS[1:10], constv); v3
v4 <- paste0(LETTERS[1:10], constv); v4


# 문제 9
strsplit("Good Morning", split=" ") # strsplit("str", split=" "), 리스트로 반환
unlist(strsplit("Good Morning", split=" "))
strsplit(unlist(strsplit("Good Morning", split=" ")), split=" ")

list(unlist(strsplit("Good Morning", split=" "))[1], unlist(strsplit("Good Morning", split=" "))[2])


# 문제 10
v5 <- c("Yesterday is history, tomorrow is a mystery, today is a gift!", "That's why we call it the present - from kung fu Panda")
v6 <- gsub("  ", " ", gsub("[,-]", "", v5)); v6
v7 <- strsplit(v6, " "); v7

gsub("\\s+", " ", gsub("[,-]", "", v5)) # 다중공백 제거
gsub("\\s{2,}", " ", gsub("[,-]", "", v5)) # 2개 이상 공백 제거

##### 문제 11, 주민등록 뒷번호 *처리
ssn <- c("941215-1234567", "850605-2345678", "760830-1357913")
processed_ssn <- sapply(ssn, function(p) gsub(substr(p, 8, 14), "*******", p))
names(processed_ssn) <- NULL
processed_ssn

?substr # getter/setter
substr(ssn, nchar(ssn)-6, nchar(ssn)) <- "*******"; ssn

# 문제 12
s1 <- "@^^@Have a nice day!! 좋은 하루!! 오늘도 100점 하루...."

r1 <- gsub("[가-힣]", "", s1); r1 # 모든 한글 제거
r2 <- gsub("[[:punct:]]", "", s1); r2 # 모든 특문 제거
r3 <- gsub("[[:punct:]]|[가-힣]", "", s1); r3 # 모든 특문 or 한글 제거
# gsub("[[가-힣][:punct:]]", "", s1) # POSIX와 일반 정규표현식을 같이 쓸 수 없기때문에 '|'로 나눈다
r4 <- gsub("100", "백", s1); r4

