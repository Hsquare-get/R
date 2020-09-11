# R 언어구문 조각모음 (Strings, XPath)

| Input                        | Output                      |
| ---------------------------- | --------------------------- |
| df <- read.table('file.txt') | write.table(df, 'file.txt') |
| df <- read.csv('file.csv')   | write.csv(df, 'file.csv')   |
| load('file.RData')           | save(df, file='file.RData') |

- ## Variable Assignment - Environment

  - ls() : List all variables in the environment
  - rm(x) : Remove x from the environment
  - rm(list=ls()) : Remove all variables from the environment

- ## Strings <span style="font-size:15px;">(ref.https://analysisbugs.tistory.com/49)</span>

  | function | use                                            |
  | -------- | ---------------------------------------------- |
  | grep     | grep(pattern, x, ignore.case = F, value = F)   |
  | grepl    | grepl(pattern, x, ignore.case = F)             |
  | gsub     | gsub(pattern, replacement, x, ignore.case = F) |

  > grep 함수와 grepl 함수는 x라는 문자열에서 해당 패턴이 존재하는가를 알아보는 함수입니다. ignore.case = T 로 바꿀 경우, 해당 패턴에 대하여 대소문자 구분없이 존재하는가를 알려줍니다.  grep 함수는 index를 출력하지만, grepl은 TRUE, FLASE를 출력합니다. 이 때, grep 함수에서 value = T 로 바꿔주면 index가 아닌 문자열이 출력됩니다.
  >
  > gsub 함수는 해당 패턴을 가지는 문자열을 x에서 발견하여, replacement로 바꿔주는 함수입니다.

  ```R
  txt <- c("BigData", "Bigdata", "bigdata", "Data", "dataMining", "class1", "class5")
  grep("data", txt)
  [1] 2 3 5
  
  grep("data", txt, ignore.case = T)
  [1] 1 2 3 4 5
  
  grep("data", txt, value = T)
  [1] "Bigdata" "bigdata" "dataMining"
  
  grepl("data", txt)
  [1] FALSE TRUE TRUE FALSE TRUE FALSE FALSE
  
  gsub("big","small", txt, ignore.case = T)
  [1] "smallData" "smalldata" "smalldata" "Data" "dataMining" "class1" "class5"
  ```

  

  | function | use                    |
  | -------- | ---------------------- |
  | strsplit | strsplit(x, split)     |
  | substr   | substr(x, start, stop) |

  > strsplit 함수는 문자열을 쪼개는 함수이며 substr 함수는 문자열에서 시작위치와 끝위치를 정하여 추출해내는 함수이다.

  ```R
  test = "Text data is very important"
  strsplit(test, ' ')
  [[1]] 
  [1] "Text" "data" "is" "very" "important"
  
  substr("abcdef", 2, 4)
  [1] "bcd"
  ```

  

  | function   | use             |
  | ---------- | --------------- |
  | toupper(x) | toupper("abc")  |
  | tolower(x) | tolower("ABC")  |
  | nchar(x)   | nchar("ab cde") |

  > toupper(x)는 인수로 주어진 문자열을 대문자로 바꿔주고 tolower(x)는 인수로 주어진 문자열을 소문자로 바꿔준다. nchar(x)는 인수로 주어진 문자열의 길이를 반환한다. nchar("ab cde")는 6을 반환.



- ## XPath <span style="font-size:15px;">(ref.https://qssdev.tistory.com/42)</span>

  #### Selection Nodes

  | use             | explanation                                                  |
  | --------------- | ------------------------------------------------------------ |
  | bookstore       | "bookstore"인 이름의 모든 node를 선택합니다.                 |
  | /bookstore      | 루트 요소 bookstore를 선택합니다                             |
  | bookstore/book  | bookstore의 자식인 모든 book 요소를 선택합니다.              |
  | //book          | book이 어디있든지 간에 모든 book 요소를 선택합니다.          |
  | bookstroe//book | bookstore아래에서 어딨든지 간에 모든 book 요소를 선택합니다. |
  | //@lang         | lang이라는 이름의 속성을 모두 선택합니다.                    |

  

  #### Predicates

  > Prediacates는 특별한 값이나 특별한 노드를 찾는데 쓰입니다. Prediacates는 항상 []안에 들어갑니다.

  | use                               | explanation                                               |
  | --------------------------------- | --------------------------------------------------------- |
  | /bookstore/book[1]                | /bookstore 자식인 첫 번째 book 요소를 선택합니다.         |
  | /bookstore/book[last()]           | 마지막 book 요소를 선택합니다                             |
  | /bookstore/book[last()-1]         | 마지막에서 하나를 뺀 요소를 선택합니다.                   |
  | /bookstore/book[position()<3]     | 첫 번째와 두 번째 요소를 선택합니다                       |
  | //title[@lang]                    | lang이라는 속성 이름을 가진 모든 title 요소를 선택합니다. |
  | //title[@lang='en']               | lang이라는 속성에 값이 en인 모든 title 요소를 선택합니다. |
  | /bookstore/book[price > 35]       | price 요소의 값이 35가 넘는 모든 book 요소를 선택합니다   |
  | /bookstore/book[price > 35]/title | price가 35가 넘는 book 요소의 title 요소를 선택합니다.    |
  | /bookstore/book/price[text()]     | price 요소에서 text를 가져옵니다.                         |

  

