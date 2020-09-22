# 문제1
v <- sample(1:26, 10) # sample()은 중복없이 추출함
v

sapply(v, function(p) for (i in p) return(c(LETTERS[i])))