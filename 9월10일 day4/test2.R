#문제9
getwd()
words <- scan("data/iotest2.txt", what="", encoding="UTF-8"); words
#words_line <- readLines("data/iotest2.txt", encoding="UTF-8"); words_line

summary(factor(words)) # vector
which.max(summary(factor(words))) # 최대값의 인덱스 반환
names(which.max(summary(factor(words)))) # 최대값의 범주형변수 이름 반환

print(paste("가장 많이 등장한 단어는", names(which.max(summary(factor(words)))), "입니다."))
