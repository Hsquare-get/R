library(rJava)
library(RJDBC)
library(DBI)
library(dplyr)


# 드라이버 설정
drv <- JDBC(driverClass = 'org.mariadb.jdbc.Driver', 'mariadb-java-client-2.6.2.jar')
# MariaDB 연결
conn <- dbConnect(drv, 'jdbc:mariadb://127.0.0.1:3306/work', 'scott', 'tiger')

emp <- dbReadTable(conn, "emp"); emp

# [문제0] comm열에서 0보다 작은 값을 NA값으로 변경
str(emp); head(emp); View(emp)
emp[emp$comm < 0, "comm"] = NA; emp

emp %>% mutate(comm = ifelse(comm < 0, NA, comm)) # 0보다 작으면 NA 아니면 그대로 comm

# [문제1] 업무가 MANAGER인 직원들의 정보를 추출
emp %>% filter(job == "MANAGER")

# [문제2] emp에서 사번, 이름, 월급을 추출
emp %>% select(empno, ename, sal)

# [문제3] emp에서 사번만 빼고 추출
emp %>% select(-empno)

# [문제4] emp에서 ename과 sal만 추출
emp %>% select(ename, sal)

# [문제5] 업무별 직원수를 추출
emp %>% group_by(job) %>% tally
emp %>% group_by(job) %>% summarise(n=n())
emp %>% count(job)

# [문제6] 월급이 1000이상이고 3000이하인 사원들의 이름, 월급, 부서번호 추출
emp %>% filter(sal>=1000 & sal<=3000) %>% select(ename, sal, deptno)

# [문제7] emp에서 업무가 ANALYST가 아닌 사원들의 이름, 직업, 월급을 추출
emp %>% filter(job != "ANALYST") %>% select(ename, job, sal)

# [문제8] emp에서 업무가 SALESMAN이거나 ANALYST인 사원들의 이름, 직업을 추출
emp %>% filter(job == "SALESMAN" | job == "ANALYST") %>% select(ename, job)

# [문제9] 부서별 직원들 월급의 합
emp %>% group_by(deptno) %>% summarise(salary_sum = sum(sal))

# [문제10] 월급이 적은 순으로 모든 직원 정보를 추출
emp %>% arrange(sal)

# [문제11] 월급이 제일 많은 직원의 정보를 추출
emp %>% arrange(desc(sal)) %>% head(1)

# [문제12] sal 컬럼명을 salary로, comm 컬럼명을 commrate로 변경한 후 empnew라는 새로운 데이터셋을 생성
emp %>% rename(salary=sal, commrate=comm) -> empnew

# [문제13] 가장 많은 인원이 일하고 있는 부서 번호를 추출
emp %>% count(deptno) %>% filter(n==max(n)) %>% select(deptno)

# [문제14] enamelength 컬럼 추가하고 이름이 짧은 순으로 직원이름을 추출
emp %>% mutate(enamelength=nchar(ename)) %>% arrange(enamelength) %>% select(ename)

# [문제15] 커미션이 정해진 직원들의 수를 추출
n <- emp %>% filter(comm != is.na(comm)) %>% count
n[1,1]

emp %>% filter(comm != is.na(comm)) %>% nrow()
emp %>% filter(!is.na(comm)) %>% summarise(n=n())
emp %>% filter(!is.na(comm)) %>% tally
emp %>% filter(!is.na(comm)) %>% count
