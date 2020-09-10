#문제1
L1 <- list(
  name = "scott",
  sal = 3000
)
print(L1)

result1 <- L1[["sal"]]*2; result1
result1 <- L1[[2]]*2; result1
result1 <- L1$sal*2; result1


#문제2
L2 <- list("scott", c(100,200,300)); L2


#문제3
L3 <- list(c(3,5,7), c("A","B","C")); L3
L3[[2]][1] <- "Alpha"; L3


#문제4
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


#문제5
L5 <- list(
  data1 = LETTERS,
  data2 = head(read.csv("data/emp.csv"), n=3),
  data3 = L4
)
print(L5)

L5$data1[1] # "A"
L5$data2$ename # "SMITH" "ALLEN" "WARD"
L5$data3$gamma # 리스트가 아닌 벡터로 반환

L5[["data1"]][1] # "A"
L5[["data2"]]$ename # "SMITH" "ALLEN" "WARD"
L5[["data3"]][[3]] # 리스트가 아닌 벡터로 반환


#문제6
L6 <- list(
  math = list(95,90),
  writing = list(90,85),
  reading = list(85,80)
)
print(L6); unlist(L6) # unlist(L6), named vector

midterm_avg <- sum(unlist(L6)[c(1,3,5)]) / length(L6) # 중간고사 평균
finals_avg <- sum(unlist(L6)[c(2,4,6)]) / length(L6) # 기말고사 평균
semester_avg <- (midterm_avg + finals_avg) / 2 # 전체 평균
mean(unlist(L6)) # 전체 평균

midterm_avg; finals_avg; semester_avg
