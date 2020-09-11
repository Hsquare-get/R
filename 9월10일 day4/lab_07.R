#문제1
countEvenOdd <- function(nums) {
  if(is.vector(nums) & is.numeric(nums)) {
    EvenOdd <- list(
      even = 0,
      odd = 0
    )
    for (data in nums) {
      if (data %% 2 == 0) {
        EvenOdd$even <- EvenOdd$even + 1
      } else {
        EvenOdd$odd <- EvenOdd$odd + 1
      }
    }
    return(EvenOdd)
  } else {return()}
}

nums <- c(1,2,3,4,5,6,7,8,9); class(nums);
countEvenOdd(nums)
countEvenOdd(c("a",1,2,3)) # NULL


#문제2
vmSum <- function(p) {
  if (is.vector(p)) {
    if (is.numeric(p)) {
      return(sum(p))
    } else {
      print("숫자 벡터를 전달하숑!")
      return(0)
    }
  } else {
    print("벡터만 전달하숑!")
  }
}

vmSum(c(1,2,3,4,5)) # 15
vmSum(c(1,2,3,4,5,"abc")) # 문자열벡터, 숫자 벡터를 전달하숑! 0
vmSum(iris) # 데이터프레임, 벡터만 전달하숑!


#문제3
vmSum2 <- function(p) {
  if (is.vector(p)) {
    if (is.numeric(p)) {
      return(sum(p))
    } else {
      warning("숫자 벡터를 전달하숑!") # warning(수행계속, 에러메시지)
      return(0)
    }
  } else {
    stop("벡터만 전달하숑!") # stop(수행중단, 에러메시지)
    return("이 문장은 실행 안할걸?!")
  }
}

vmSum2(c(1,2,3,4,5)) # 15
vmSum2(c(1,2,3,4,5,"abc")) # 문자열벡터, 0 숫자 벡터를 전달하숑!
vmSum2(iris) # 데이터프레임, 벡터만 전달하숑!


#문제4
mySum <- function(v) {
  Sum <- list(
    eventhsum = 0,
    oddthsum = 0
  )
  
  if (is.vector(v)) {
    
    if (any(is.na(v))) {
      warning("NA를 최저값으로 변경하여 처리함!!")
      v[which(is.na(v))] <- min(v, na.rm=T) # which는 TRUE인 인덱스를 c() 벡터 안에 담아서줌
    }
    
    #for (i in 1:length(v)) {
    #  if (i %% 2 == 0) {Sum$eventhsum <- Sum$eventhsum + v[i]}
    #  else {Sum[["oddthsum"]] <- Sum[["oddthsum"]] + v[i]}
    #}
    
    e <- v[seq(0, length(v),2)]; Sum$eventhsum <- sum(e)
    o <- v[seq(1, length(v),2)]; Sum$oddthsum <- sum(o)

    return(Sum)
    
  } else if (!is.vector(v)) {
    if (is.null(v)) {return(NULL)}
    stop("벡터만 처리 가능!!")
  }
}

is.na(c(1,2,3,NA,NA)) # F F F T T
mySum(c()) # NULL
mySum(c(1,2,3,4,5)) # 짝수번째합6, 홀수번째합9
mySum(c(6,7,8,9,NA)) # NA는 6으로 대체, 짝수번째합16, 홀수번째합20, 경고메시지출력
mySum(c(6,7,8,9,NA,NA)) # 2개의 NA는 6으로 대체, 짝수번째합22, 홀수번째합20, 경고메시지출력
mySum(iris) # 벡터만 처리 가능!!


#문제5
myExpr <- function(f) {
  if(is.function(f)) {
    lottonums <- sample(1:45, 6) # summary 함수 이용하기 위해서는 factor(sample(1:45, 6))
    result <- f(lottonums)
  } else if (!is.function(f)) {
    stop("수행 안할꺼임!!")
  }
  return(result)
}

myExpr(c(1,2,3)) # "수행 안할꺼임!!"
myExpr(sum) # 전역변수에 sum이 있다면 오류
myExpr(summary)
myExpr(mean)
myExpr(min); myExpr(max)
myExpr(range)


#문제6
createVector1 <- function(...) {
  parameter <- c(...)
  if (length(parameter) == 0) return(NULL)
  else if (any(is.na(parameter))) return(NA)
  return(parameter)
}

createVector1() # NULL
createVector1(1, 2, 3)
createVector1("가", "나", "다")
createVector1(1, "가나다", TRUE) # class(), character
createVector1(1, "가나다", TRUE, iris) # is.vector(), TRUE
createVector1(1, "가나다", TRUE, NA) # NA


#문제7
createVector2 <- function(...) {
  parameter <- list(...)
  if (length(parameter) == 0) return(NULL)
  
  num_vec <- c()
  chr_vec <- c()
  logic_vec <- c()
  for (i in 1:length(parameter)) {
    if (is.numeric(parameter[[i]])) {num_vec <- c(num_vec, parameter[[i]])}
    else if (is.character(parameter[[i]])) {chr_vec <- c(chr_vec, parameter[[i]])}
    else if (is.logical(parameter[[i]])) {logic_vec <- c(logic_vec, parameter[[i]])}
  }
  
  return(list(num_vec, chr_vec, logic_vec))
}

createVector2() # NULL
createVector2(1, 2, 3)
createVector2("가", "나", "다")
createVector2("가", 10, 20, 30, "나", "다")
createVector2(F, 1,2,3, "가나다", TRUE, NA)


#문제8, test1.R
#문제9, test2.R
