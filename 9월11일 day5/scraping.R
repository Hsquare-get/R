library(rvest)

url <- "http://unico2013.dothome.co.kr/crawling/exercise_bs.html"
html <- read_html(url); html

# <h1> 태그의 컨텐츠
node1 <- html_node(html, css="h1"); node1 # <h1>, 객체하나를 가져온다
node1 <- html_nodes(html, xpath="/html/body/h1"); node1 # <h1>HTML의 링크 태그</h1>, 객체들을 가져온다
html_text(node1) # 객체의 내용을 가져온다

# <a> 태그의 컨텐츠와 href 속성값
node2 <- html_nodes(html, "body a"); node2 # 자식 선택자 ">", 자손 선택자 " "
html_text(node2, trim=T)
html_attr(node2, "href")

# <img> 태그의 src 속성값
node3 <- html_nodes(html, "a img"); node3
html_attr(node3, "src")

# 첫번째 <h2> 태그의 컨텐츠
node4 <- html_nodes(html, "body > h2"); node4
html_text(node4)[1]

# <ul> 태그의 자식 태그들 중 style 속성의 값이 green으로 끝나는 태그의 컨텐츠
node5 <- html_nodes(html, "ul > [style$=green]"); node5 # $ : ~으로 끝나는
html_text(node5)

# 두번째 <h2> 태그의 컨텐츠
node6 <- html_nodes(html, "body > h2"); node6
html_text(node4)[2]

# <ol> 태그의 모든 자식 태그들의 컨텐츠
node7 <- html_nodes(html, "ol > *"); node7
html_text(node7)

# <table> 태그의 모든 자손 태그들의 컨텐츠
node8 <- html_nodes(html, "table *"); node8
html_text(node8)

# name이라는 클래스 속성을 갖는 <tr> 태그의 컨텐츠
node9 <- html_nodes(html, "tr[class=name]"); node9
html_text(node9)

# target이라는 아이디 속성을 갖는 <td> 태그의 컨텐츠
node10 <- html_nodes(html, "#target"); node10
html_text(node10)
