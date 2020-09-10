#문제1
grade <- sample(1:6, 1); grade
if (grade >= 1 & grade <= 3){
  cat(grade, "학년은 저학년입니다.")
} else {
  cat(grade, "학년은 고학년입니다.")
}


#문제2
choice <- sample(1:5, 1); choice
cat("결과값 :", switch(EXPR=choice, 300+50, 300-50, 300*50, 300/50, 300%%50))


cat("결과값 :", switch(EXPR=as.character(choice),
                    "1"=300+50, "2"=300-50, "3"=300*50, "4"=300/50, "5"=300%%50))


#문제3
count <- sample(3:10, 1); count
deco <- sample(1:3, 1); deco

i <- 1
while(i <= count) {
  if(deco==1){cat(paste("*"))}
  else if(deco==2){cat(paste("$"))}
  else if(deco==3){cat(paste("#"))}
  i <- i+1
}


count <- sample(3:10, 1); count
deco <- sample(1:3, 1); deco

if (deco == 1) {
  cat(rep('*',times=count))
} else if (deco == 2){
  cat(rep('$',times=count))
} else if (deco == 3){
  cat(rep('#',times=count))
}


#문제4
score <- sample(0:100, 1); score

if (score>=90 & score<=100) {
  score_range <- 1
} else if (score>=80) {
  score_range <- 2
} else if (score>=70) {
  score_range <- 3
} else if (score>=60) {
  score_range <- 4
} else {
  score_range <- 5
}

result <- switch(EXPR=as.character(score_range),"1"="A", "2"="B", "3"="C", "4"="D", "5"="F")
cat(score,"점은", result, "등급입니다.")


score <- sample(0:100, 1)
temp <- score %/% 10 # %/% 정수 몫만 반환
temp <- as.character(temp) 
cat(score, "점은", switch(EXPR = temp, 
                       "10"=, "9"="A", "8"="B", "7"="C", "6"="D", "F"), "등급 입니다.")


#문제5
alpha <- c(); alpha
for(i in 1:length(LETTERS)) {
  alpha[i] <- paste(LETTERS[i], letters[i], sep="")
}
alpha


paste(LETTERS, letters, sep="")
