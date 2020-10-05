# TIL1005 (ggplot2 시각화 응용, 탐색적 데이터분석 EDA, 산점도와 상관행렬)

## (1) ggplot2 패키지로 시각화 응용

```R
library(ggplot2)

diamonds
g <- diamonds[order(diamonds$table), ]
head(g)
tail(g)

### 스타일 설정 ###
gg <- ggplot(diamonds, aes(x=carat, y=price))
gg + geom_point()
gg + geom_point(size=1, shape=2, color="steelblue", stroke=1)
gg + geom_point(aes(size=carat, shape=cut, color=color, stroke=carat))

gg1 <- gg + geom_point(aes(color=color))
gg2 <- gg1 + labs(title="Diamonds", x="Carat Layer", y="Price Layer"); gg2

gg1 <- gg + geom_point(aes(color=color))
gg2 <- gg1 + labs(title="Diamonds", x="Carat", y="Price")
gg2 + theme(text=element_text(color="red"))

gg1 <- gg + geom_point(aes(color=color))
gg2 <- gg1 + labs(title="Diamonds", x="Carat", y="Price")
gg3 <- gg2 + theme(plot.title=element_text(size=25), 
                   axis.title.x=element_text(size=20), 
                   axis.title.y=element_text(size=20), 
                   axis.text.x=element_text(size=15), 
                   axis.text.y=element_text(size=15)); gg3

gg3 + labs(title="Plot Title \nSecond Line of Plot Title") + 
  theme(plot.title=element_text(face="bold", color="steelblue", lineheight=1.2))

gg1 <- gg + geom_point(aes(color=color))
gg2 <- gg1 + labs(title="Diamonds", x="Carat", y="Price")
gg3 <- gg2 + theme(plot.title=element_text(size=25), 
                   axis.title.x=element_text(size=20), 
                   axis.title.y=element_text(size=20), 
                   axis.text.x=element_text(size=15), 
                   axis.text.y=element_text(size=15)); gg3

gg3 + scale_colour_manual(name='칼라',
                          values=c('D'='grey', 'E'='red', 'F'='blue','G'='yellow',
                                   'H'='black', 'I'='green', 'J'='firebrick'))

gg1 <- gg + geom_point(aes(color=color))
gg2 <- gg1 + labs(title="Diamonds", x="Carat", y="Price")
gg3 <- gg2 + theme(plot.title=element_text(size=25), 
                   axis.title.x=element_text(size=20), axis.title.y=element_text(size=20), 
                   axis.text.x=element_text(size=15), axis.text.y=element_text(size=15)); gg3

# x축, y축 범위설정과 대략적인 선 그려주기
gg3 + coord_cartesian(xlim=c(0,3), ylim=c(0, 5000)) + geom_smooth()

gg1 <- gg + geom_point(aes(color=color))
gg2 <- gg1 + labs(title="Diamonds", x="Carat", y="Price")
gg3 <- gg2 + theme(plot.title=element_text(size=25), 
                   axis.title.x=element_text(size=20), axis.title.y=element_text(size=20), 
                   axis.text.x=element_text(size=15), axis.text.y=element_text(size=15))

gg3 + coord_flip() # x축-y축 전환

gg1 <- gg + geom_point(aes(color=color))
gg2 <- gg1 + labs(title="Diamonds", x="Carat", y="Price")
gg3 <- gg2 + theme(plot.title=element_text(size=25), 
                   axis.title.x=element_text(size=20), axis.title.y=element_text(size=20), 
                   axis.text.x=element_text(size=15), axis.text.y=element_text(size=15))

gg3 + theme(plot.background=element_rect(fill="yellowgreen"),
            plot.margin = unit(c(2, 4, 1, 3), "cm")) # 시계방향(top-right-bottom-left)

gg1 <- gg + geom_point(aes(color=color))
gg2 <- gg1 + labs(title="Diamonds", x="Carat", y="Price")
gg3 <- gg2 + theme(plot.title=element_text(size=25), 
                   axis.title.x=element_text(size=20), axis.title.y=element_text(size=20), 
                   axis.text.x=element_text(size=15), axis.text.y=element_text(size=15))

# 수평선 그리기
p1 <- gg3 + geom_hline(yintercept=5000, size=2, linetype="dotted", color="blue"); p1 #
```



```R
library(ggplot2)
theme_set(theme_bw()) 

data("mtcars") # 데이터를 읽는다.
mtcars$'car name' <- rownames(mtcars) # 차 이름을 위한 칼럼을 만든다.

mtcars$mpg_z <- round((mtcars$mpg - mean(mtcars$mpg))/sd(mtcars$mpg), 2) 

mtcars$mpg_type <- ifelse(mtcars$mpg_z < 0, "below", "above") 
mtcars <- mtcars[order(mtcars$mpg_z), ] # 정렬한다.
mtcars$'car name' <- factor(mtcars$'car name', levels = mtcars$'car name')

ggplot(mtcars, aes(x='car name', y=mpg_z, label=mpg_z)) + 
  geom_bar(stat='identity', aes(fill=mpg_type), width=.5) +
  scale_fill_manual(name="Mileage",
                    labels = c("Above Average", "Below Average"), 
                    values = c("above"="#00ba38", "below"="#f8766d")) + 
  labs(subtitle="Normalised mileage from 'mtcars'", 
       title= "Diverging Bars") + 
  coord_flip()


library(ggplot2)
theme_set(theme_bw())

# plot
g <- ggplot(mpg, aes(class, cty))
g + geom_violin() + 
  labs(title="Violin plot", 
       subtitle="City Mileage vs Class of vehicle",
       caption="Source: mpg",
       x="Class of Vehicle",
       y="City Mileage")


# qplot = ggplot + geom
qplot(Sepal.Length, Petal.Length, data=iris)
qplot(Sepal.Length, Petal.Length, data = iris, color = Species, size = Petal.Width)
qplot(Sepal.Length, Petal.Length, data = iris, geom = "line", color = Species)
qplot(age, circumference, data = Orange, geom = "line", colour = Tree, main = "How does orange tree circumference vary with age?")
```



## (2) 탐색적 데이터 분석 EDA

> **탐색적 데이터 분석(EDA)**
>
> 목적 : *데이터에 대한 이해*
>
> 데이터를 수집 및 전처리하고, 정제된 데이터셋을 준비하여 본격적으로 데이터 분석을 하기 위한 일련의 과정

- 개념적 데이터 탐색과정

  탐색적 데이터 분석과정은 개념적으로 다음 두가지 질문으로 귀결된다.

  - 데이터에 포함된 변수에 내재된 변동성(variation) 유형은 어떻게 되는가?
  - 변수들 간의 공분산(covariation)은 어떻게 되는가?



- 데이터 특성에 따른 기술통계분석 선택하기

![graph for variable type](https://user-images.githubusercontent.com/64063767/95032977-869c2180-06f7-11eb-87ab-b89ef677b5d5.png)



```R
##### EDA 실습 (타이타닉) #####
# https://www.kaggle.com/c/titanic/data

train <- read.csv('data/train.csv')
test <- read.csv('data/test.csv')

str(train)
head(train)
tail(train)
dim(train)
View(train)

str(test)
head(test)
tail(test)
dim(test)
View(test)

summary(train)
summary(is.na(train)) # 결측치 확인
summary(train == '')
names(train)


library(ggplot2)
df <- NULL
bar_chart <- function(feature){
  select_v <- c("Survived", feature)
  print(select_v)
  df <<- train[select_v]
  df$Survived <<- ifelse(df$Survived == 1, 'Survived', 'Dead')
  ggplot(df, aes(Survived)) + geom_bar(aes(fill=factor(.data[[feature]])))
}

bar_chart('Sex')
bar_chart('Pclass')
bar_chart('SibSp')
bar_chart('Parch')
bar_chart('Embarked')

# mosaicplot, 모자이크 플롯 #
str(Titanic)
mosaicplot(Titanic, main="Titanic Data, Class, Sex, Age, Survival", col=TRUE)

# 성별에 따른 생존 여부
select_v <- c('Survived', 'Sex')
df <- train[select_v]; df
df$Survived <- ifelse(df$Survived == 1, 'Survived', 'Dead')
ggplot(df, aes(Survived)) + geom_bar(aes(fill=Sex))

mosaicplot(Survived ~ Sex,
           data = df, col = TRUE,
           main = "Survival rate by passengers gender")

# 선실 등급에 따른 생존 여부
select_v <- c('Survived', 'Pclass')
df <- train[select_v]; df
df$Survived <- ifelse(df$Survived == 1, 'Survived', 'Dead')
ggplot(df, aes(Survived)) + geom_bar(aes(fill=factor(Pclass)))

# 함께 탑승한 형제 또는 배우자 수에 따른 생존 여부
select_v <- c('Survived', 'SibSp')
df <- train[select_v]; df
df$Survived <- ifelse(df$Survived == 1, 'Survived', 'Dead')
ggplot(df, aes(Survived)) + geom_bar(aes(fill=factor(SibSp)))

# 함께 탑승한 부모 또는 자녀 수에 따른 생존 여부
select_v <- c('Survived', 'Parch')
df <- train[select_v]; df
df$Survived <- ifelse(df$Survived == 1, 'Survived', 'Dead')
ggplot(df, aes(Survived)) + geom_bar(aes(fill=factor(Parch)))

# 탑승한 항구에 따른 생존 여부
select_v <- c('Survived', 'Embarked')
df <- train[select_v]; df
df <- df[df$Embarked != '',]
df$Survived <- ifelse(df$Survived == 1, 'Survived', 'Dead')
ggplot(df, aes(Survived)) + geom_bar(aes(fill=Embarked))

# 나이에 따른 생존 여부
library(dplyr)
install.packages("gridExtra")
library(gridExtra)

df <- train
age.p1 <- df %>% 
  ggplot(aes(Age)) + 
  # 히스토그램 그리기, 설정
  geom_histogram(breaks = seq(0, 80, by = 1), # 간격 설정 
                 col    = "red",              # 막대 경계선 색깔 
                 fill   = "green",            # 막대 내부 색깔 
                 alpha  = .5) +               # 막대 투명도 = 50% 
  # Plot title
  ggtitle("All Titanic passengers age hitogram") +
  theme(plot.title = element_text(face = "bold",    # 글씨체 
                                  hjust = 0.5,      # Horizon(가로비율) = 0.5
                                  size = 15, color = "darkblue"))

age.p2 <- df %>% 
  filter(!is.na(Survived)) %>% 
  ggplot(aes(Age, fill = Survived)) + 
  geom_density(alpha = .5) +
  ggtitle("Titanic passengers age density plot") + 
  theme(plot.title = element_text(face = "bold", hjust = 0.5,
                                  size = 15, color = "darkblue"))

grid.arrange(age.p1, age.p2, nrow = 2)

# dplyr::case_when
?case_when
x <- 1:50
case_when(
  x %% 35 == 0 ~ "둘리", # if처럼 첫번째 조건이 참이면 밑에는 적용X
  x %% 5 == 0 ~ "듀크",
  x %% 7 == 0 ~ "유니코",
  TRUE ~ as.character(x)
)

df <- train %>%
  # 결측치(NA)를 먼저 채우는데 결측치를 제외한 값들의 평균으로 채움.
  mutate(Age = ifelse(is.na(Age), mean(train$Age, na.rm = TRUE), Age),
         # Age 값에 따라 범주형 파생 변수 Age.Group 를 생성
         Age.Group = case_when(Age < 13             ~ "Age.0012",
                               Age >= 13 & Age < 18 ~ "Age.1317",
                               Age >= 18 & Age < 60 ~ "Age.1859",
                               Age >= 60            ~ "Age.60inf"),
         # Chr 속성을 Factor로 변환 
         Age.Group = factor(Age.Group))

df <- df %>% 
  # SibSp, Parch와 1(본인)을 더해서 FamilySize라는 파생변수를 먼저 생성  
  mutate(FamilySize = .$SibSp + .$Parch + 1,
         # FamilySize 의 값에 따라서 범주형 파생 변수 FamilySized 를 생성 
         FamilySized = dplyr::case_when(FamilySize == 1 ~ "Single",
                                        FamilySize >= 2 & FamilySize < 5 ~ "Small",
                                        FamilySize >= 5 ~ "Big"),
         # Chr 속성인 FamilySized를 factor로 변환하고
         # 집단 규모 크기에 따라 levels를 새로 지정
         FamilySized = factor(FamilySized, levels = c("Single", "Small", "Big")))


title <- train$Name; title

# .*\\. (임의의문자가 몇개가 오든 뒤에 오는 조건이 만족될때까지 뽑는다) 
# .*?\\. (임의의 문자가 몇개가 오든 처음만나는 .만을 구분)
# 정규표현식과 gsub()을 이용해서 성별과 관련성이 높은 이름만 추출해서 title 벡터로 저장 
title <- gsub("^.*, (.*?)\\..*$", "\\1", title); title

df$title <- title
install.packages("descr")
descr::CrossTable(df$title) # 집계표

# 5개 범주로 단순화 시키는 작업 
df <- df %>%
  # "%in%" 대신 "=="을 사용하게되면 Recyling Rule 때문에 원하는대로 되지 않습니다.
  mutate(title = ifelse(title %in% c("Mlle", "Ms", "Lady", "Dona"), "Miss", title),
         title = ifelse(title == "Mme", "Mrs", title),
         title = ifelse(title %in% c("Capt", "Col", "Major", "Dr", "Rev", "Don",
                                     "Sir", "the Countess", "Jonkheer"), "Officer", title),
         title = factor(title))

# 파생변수 생성 후 각 범주별 빈도수, 비율 확인 
descr::CrossTable(df$title)
head(df)

df <- df %>% 
  select("Pclass", "Sex", "Embarked", "FamilySized",
         "Age.Group", "title", "Survived")

View(df)
```



## (3) 산점도와 상관행렬

### (I) 산점도

```R
##### Scatterplot, 산점도 #####
options(scipen=999) # turn-off scientific notation like 1e+48

library(ggplot2)
theme_set(theme_bw()) # black&white 기본테마로 설정
data("midwest", package = "ggplot2")
head(midwest)

gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state, size=popdensity)) + 
  geom_smooth(method="loess", se=F) + 
  xlim(c(0, 0.1)) + 
  ylim(c(0, 500000)) + 
  labs(subtitle="Area Vs Population", 
       y="Population", 
       x="Area", 
       title="Scatterplot", 
       caption="Source: midwest")

plot(gg) # print(gg)


g <- ggplot(mpg, aes(cty, hwy))
# Scatterplot 그림을 그린다. 아래의 내용은 배치로 만든후에 실행할 것
# geom_point() : 같은 데이터라도 점이 하나 찍힘
g + geom_point() +
  geom_smooth(method="lm", se=F) +
  labs(subtitle="mpg: city vs highway mileage", 
       y="hwy", 
       x="cty", 
       title="Scatterplot with overlapping points", 
       caption="Source: midwest")

# geom_count() : 같은 데이터값이라면 점의 크기가 커짐(가중치) 
g <- ggplot(mpg, aes(cty, hwy))
g + geom_count(col="tomato3", show.legend=F) +
  labs(subtitle="mpg: city vs highway mileage",
       y="hwy", 
       x="cty", 
       title="Counts Plot")


#install.packages("ggExtra")
library(ggExtra)

mpg_select <- mpg[mpg$hwy >= 35 & mpg$cty > 27, ]
g <- ggplot(mpg, aes(cty, hwy)) +
  geom_count() +
  geom_smooth(method="lm", se=F)

ggMarginal(g, type="histogram", fill="transparent")
ggMarginal(g, type="boxplot", fill="transparent")
```



### (II) 상관행렬

```R
##### Correlation matrix, 상관 행렬 #####
#install.packages("ggcorrplot")
library(ggcorrplot)

data(mtcars); View(mtcars)
corr <- round(cor(mtcars), 1)

# Plot
ggcorrplot(corr, hc.order = TRUE, 
           type="lower", 
           lab=TRUE, 
           lab_size=3, 
           method="circle", 
           colors=c("tomato2", "white", "springgreen3"), 
           title="Correlogram of mtcars", 
           ggtheme=theme_bw)
```



### (III) 공분산(Covariance)과 상관계수(Correlation)

> 확률변수 X가 있을 때 흔히 나타내는 것이 **평균**과 **분산**이다. 평균으로써 분포의 중간부분을 파악하고 분산으로써 분포가 얼마나 퍼져있는지 알아낸다.
>
> 확률변수가 2가지 이상일 때 확률 변수들 서로간의 관계가 어떤 상관이 있는지를 나타내주는 것이 공분산이다. 두 확률 변수 X와 Y가 있을 때 X가 커지면 Y도 커진다거나 반대로 Y는 작아지거나, 아니면 상관이 없음을 알 수 있는 parameter이다.
>
> Cov(x,y) > 0 : X가 증가할 때  Y도 증가
>
> Cov(x,y) < 0 : X가 증가할 때  Y는 감소
>
> Cov(x,y) = 0 : 공분산이 0이라면 일반적으로 두 변수간에는 선형관계가 없으며 서로 독립적인 관계임을 알 수 있다. 그러나 두 변수가 독립적이라면 공분산은 항상 0이 되지만, 공분산이 0이라고해서 항상 독립적이라고 할 수는 없다.



> 공분산은 X의 편차와 Y의 편차를 곱한것의 평균

```R
intall.packages("MASS")
library(MASS)

cov(x=Cars93$MPG.highway,
   y=Cars93$Weight)
[1] -2549.655
```



> 단위에 의존하기 때문에 어느정도로 음의 상관관계를 가지는지 파악이 어렵다.
>
> 이 때 공분산을 표준화한 **상관계수**(cor)를 사용하면 두 변수간의 상관관계 정도를 가늠할 수 있다.
>
> 1. 표준화 변수들의 공분산은 상관계수가 된다.
>
> 2. 상관계수는 -1 <= ρ <= 1 범위의 값을 가진다.
>
> 3. 상관계수 ρ가 +1에 가까울수록 강한 양의 선형관계, ρ가 -1에 가까울수록 강한 음의 선형관계
>
> 4. 상관계수 ρ = 0이면 두 변수간의 선형관계는 없으며, 0에 가까울수록 선형관계가 약해진다.
>
>    (단, 비선형 관계를 가질 수 있음. 그래프 분석 병행 필요)
>
> 5. 위치 변환이나 척도 변환 후에도 상관계수는 변함이 없다.

```R
cor(x=Cars93$MPG.highway,
   y=Cars93$Weight)
[1] -0.8106581
```

