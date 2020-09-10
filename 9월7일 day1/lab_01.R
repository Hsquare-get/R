#문제1
test <- c(1,2,3,4,5); rm(test); test
v1 <- 1:10; v1
v2 <- v1 * 2; v2
max_v <- max(v2); max_v # 최대값
min_v <- min(v2); min_v # 최소값
avg_v <- mean(v2); avg_v # 평균값
sum_v <- sum(v2); sum_v # 합
v3 <- v2[-5]; v3

v1; v2; v3; max_v; min_v; avg_v; sum_v;


#문제2
v4 <- seq(1, 10, 2); v4
v5 <- rep(1, 5); v5
v6 <- rep(1:3, times=3); v6
v7 <- rep(1:4, each=2); v7


#문제3
nums <- sample(1:100, 10, replace=F) # 1~100까지 10개 중복X
sort(nums) # 오름차순 정렬
sort(nums, decreasing=T) # 내림차순 정렬
nums[nums>50] # 50보다 큰 값 출력
which(nums<=50); nums # 50보다 같거나 작은 값의 인덱스 출력
which(nums>=max(nums)) # 최대값을 저장하고 있는 원소의 인덱스 출력
which(nums<=min(nums)) # 최소값을 저장하고 있는 원소의 인덱스 출력


#문제4
v8 <- seq(1,10, 3); v8
names(v8) <- LETTERS[1:4]; v8


#문제5
score <- sample(1:20, 5, replace=F); score # 1~20까지 5개 중복X
myFriend <- c("둘리", "또치", "도우너", "희동", "듀크"); myFriend

paste(score, myFriend, sep="-")
myFriend[which(score>=max(score))] # 점수가 가장 높은 친구이름 출력
myFriend[which(score<=min(score))] # 점수가 가장 낮은 친구이름 출력
myFriend[which(score>10)] # 점수가 10점보다 높은 친구이름 출력


#문제6
count <- sample(1:100, 7, replace=F); count # 1~100까지 7개 중복X
week.korname <- c("일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일")

paste(week.korname, count, sep=" : ")
week.korname[which.max(count)] # 값이 가장 큰 요일을 출력
week.korname[which.min(count)] # 값이 가장 작은 요일을 출력
week.korname[which(count>50)] # 50보다 큰 값의 요일을 출력
