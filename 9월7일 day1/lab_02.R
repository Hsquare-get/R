#문제1
ls()
y1 <- seq(10, 38, 2)
m1 <- matrix(y1, nrow=3, ncol=5, byrow=TRUE); m1
m2 <- m1 + 100; m2

(m_max_v <- max(m1)) # m1에서 최대값
(m_min_v <- min(m1)) # m1에서 최소값

m1; (row_max <- apply(m1, 1, max)) # 행단위 최대값
m1; (col_max <- apply(m1, 2, max)) # 열단위 최대값

m1; m2; m_max_v; m_min_v; row_max; col_max


#문제2
n1 <- c(1,2,3)
n2 <- c(4,5,6)
n3 <- c(7,8,9)
m2 <- cbind(n1, n2, n3); m2 # 열 단위로 붙여서 행렬 생성

num <- c(n1,n2,n3)
matrix(num, nrow=3)
colnames(m2) <- NULL; m2


#문제3
m3 <- matrix(1:9, nrow=3, ncol=3, byrow=T); m3


#문제4
(m4 <- m3)
rownames(m4) <- c("row1", "row2", "row3")
colnames(m4) <- c("col1", "col2", "col3")
print(m4)


#문제5
(char <- letters[1:6])
(alpha <- matrix(char, nrow=2, ncol=3))
(alpha2 <- rbind(alpha, c('x','y','z'))) # 행 단위로 붙임
(alpha3 <- cbind(alpha, c('s','p'))) # 열 단위로 붙임임


#문제6
a <- array(1:24, dim=c(2,3,4)); a
a[2,3,4] # 2행 3열 4층 데이터 출력
a[2,,] # 각 층마다 2행의 데이터 출력
a[,1,] # 각 층마다 1열의 데이터 출력
a[,,3] # 3층의 모든 데이터 출력
(a + 100) # a 배열의 모든 데이터에 +100
(a[,,4] * 100) # 4층의 모든 데이터에 *100
a[1,2:3,] # 각층의 1행에서 2열과 3열만 출력 a[1,-1,] = a[1,c(2,3),]
a[2,,2] <- a[2,,2] + 100; a # 2층 2행 데이터들의 값에 100을 더한 값으로 변경
a[,,1] <- a[,,1] - 2; a # 1층 모든 데이터들의 값에 2를 뺀 값으로 변경
(a <- a * 10) # a배열의 모든 데이터에 * 10
a; rm(a)
