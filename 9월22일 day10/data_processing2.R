getwd()

lines <- readLines("data/memo.txt", encoding="UTF-8")
lines <- lines[nchar(lines) > 0] # 빈 행 제거

lines[1]
lines[1] <- gsub("[&$!#@%]", "", lines[1])

lines[2]
# gsub("[a-z]", "E", lines[2]), gsub의 두번째 argument는 정규표현식으로 인식하지 않는다
lines[2] <- gsub("[a-z]", "E", lines[2]) # toupper(lines[2])

lines[3]
lines[3] <- gsub("[[:digit:]]", "", lines[3]) 
# gsub("[0-9]", "", lines[3])
# gsub("\\d", "", lines[3])

lines[4]
lines[4] <- gsub("  ", " ", gsub("[A-Za-z]", "", lines[4]))

lines[5]
lines[5] <- gsub("[(!<>)[:digit:]]", "", lines[5])

lines[6]
lines[6] <- gsub("\\s", "", lines[6])

lines[7]
lines[7] <- gsub("  ", " ", tolower(lines[7]))

lines

getwd()
?write.table()
write.table(lines, "memo_new.txt", row.names=F, col.names=F)
