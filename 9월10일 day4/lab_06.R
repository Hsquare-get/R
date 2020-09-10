#문제1
exam1 <- function() {
  return(paste(LETTERS, letters, sep=""))
}

result1 <- exam1(); result1


#문제2
exam2 <- function(n) {
  if (is.numeric(n)) {
    sum <- 0
    for (i in 1:n) {
      sum <- sum + i # R은 "+=" 지원 X
    }
    return(sum)
  }
}

result2 <- exam2(10); result2 # 55
result2 <- exam2("10"); result2 # NULL


#문제3
exam3 <- function(p1, p2) {
  ifelse(p1>p2, result<-p1-p2,
         ifelse(p1<p2, result<-p2-p1, result<<-0)) # 전역변수
  return(result)
}

exam3(10, 20) # 10
exam3(20, 5) # 15
exam3(10, 10) # 0


#문제4
exam4 <- function(p1, p2, p3) {
  if (p2 == "+") {result <- p1 + p3}
  else if (p2 == "-") {result <- p1 - p3}
  else if (p2 == "*") {result <- p1 * p3}
  else if (p2 == "%/%") {
    if (p1 == 0) {result <- "오류1"}
    else if (p3 == 0) {result <- "오류2"}
    else {result <- p1 %/% p3}
  }
  else if (p2 == "%%") {
    if (p1 == 0) {result <- "오류1"}
    else if (p3 == 0) {result <- "오류2"}
    else {result <- p1 %% p3}
  }
  else {result <- "규격의 연산자만 전달하세요"}
  return(result)
}

exam4(11, "+", 3)
exam4(11, "-", 3)
exam4(11, "*", 3)
exam4(11, "%/%", 3) # 3, 정수 몫만 반환
exam4(11, "%%", 3) # 2, 나머지 반환

exam4(11, "%%", -3) # -1, 11 = (-4) * (-3) -1
exam4(11, "%/%", -3) # -4, 11 = (-4) * (-3) -1

exam4(2, "**", 3) # 규격 연산자 전달plz!
exam4(0, "%/%", 3) # 오류1
exam4(11, "%/%", 0) # 오류2
exam4(0, "%%", 3) # 오류1
exam4(11, "%%", 0) # 오류2


#문제5
exam5 <- function(p1, p2="#") {
  if (is.numeric(p1) & is.character(p2)) {
    if (p1<0) {return()}
    cat(rep(p2, times=p1), sep="")
  }
}

exam5() # p1 필수인자
exam5(5) # p1만 전달하면 p2는 default
exam5(5, "가나다") # position argument
exam5(p2="가나다", p1=5) # keyword argument
exam5(p1="가나다", p2=5) # 타입제한 오류
exam5(p1=-5, "가나다") # NULL


#문제6
exam6 <- function(...) {
  score <- c(...) # list(...)도 가능
  for (data in score) {
    if (is.na(data)) {print("NA는 처리불가"); next}
    else if (data >= 85) {result <- "상"}
    else if (data >= 70) {result <- "중"}
    else {result <- "하"}
    print(paste0(data, " 점은 ", result, " 등급입니다."))
  }
}

exam6(95, 80, 50, 70, 66, NA, 35)

