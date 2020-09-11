#문제8
getwd()
nums <- scan("data/iotest1.txt"); nums

cat("오름차순 :", sort(nums), "\n")
cat("내림차순 :", sort(nums, decreasing=T), "\n")
cat("합 :", sum(nums), "\n")
cat("평균 :", mean(nums), "\n")
