library(tidyr)
library(dplyr)

#gather 將幾個col轉換成新的一個col,產生下一個col為原本對應值
#separate將col依照符號拆解成多個col

messy <- data.frame(
  name = c("Wilbur", "Petunia", "Gregory"),
  a = c(67, 80, 64),
  b = c(56, 90, 50)
)
messy %>% gather(drug, heartrate, a:b) ##drug變為col名稱，包含是a還b
#heartrate就是對應的原本數值，原本col a與b對應的數值

set.seed(1)
messy <- data.frame(
  id = 1:4,
  trt = sample(rep(c('control', 'treatment'), each = 2)),
  work.T1 = runif(4),
  home.T1 = runif(4),
  work.T2 = runif(4),
  home.T2 = runif(4)
)

tidier <- messy %>%
  gather(key, time, -id, -trt) ##除了id跟trt?

tidy <- tidier %>% ##把key拆解(依照點點)
  separate(key, into = c("location", "time.T"), sep = "\\.") 

##
##
set.seed(100)
DT = expand.grid(LETTERS[1:2], LETTERS[3:4]) %>% data.table %>%
  setnames(c("col1","col2")) %>% '['(rep(1:nrow(.), 2)) %>% ##複製原row一次
  '['(,values := rpois(8,2)) ##產生新col叫values

dcast.data.table(DT, col1~col2) #保留col1 轉col2中的值成col 新增value 欄位做對應值

dcast.data.table(DT, col1~col2, sum) ##把個數值作sum

DT[, values2 := rpois(8, 3)]
dcast.data.table(DT, col1~col2, sum, value.var = "values") ##指定+values,忽視values2
dcast.data.table(DT, col1~col2, sum, value.var = "values2")
DT[, col3 := rep(LETTERS[5:6],,,4)]##??????三個逗號讓她成為"E" "E" "E" "E" "F" "F" "F" "F"而非"E" "F" "E" "F" "E" "F" "E" "F"
dcast.data.table(DT, col1+col2~col3, sum, value.var = "values")



(DT = data.table(id = paste0("P", 1:2), O1 = c(12,13), O2 = c(18,15)))

(DT_long = melt(DT, "id", variable.name = "O", value.name = "V"))##col轉成內容
##
##
#melt
DT = data.table(ID1 = paste0("ID1_", 1:20),
                ID2 = sample(paste0("ID2_", 1:20)),
                O1 = rnorm(20), O2 = rnorm(20), O3 = rnorm(20))

## 以ID1跟ID2作為展開，其他column (O1 ~ O3)會疊成一個變數
## 還會有一個新類別去label後面的value來自哪一個變數
melt(DT, c("ID1", "ID2"), c("O1", "O2", "O3"),
     variable.name = "O", value.name = "V")

## 以ID1作為展開，其他column (O1 ~ O3)會疊成一個變數
## 還會有一個新類別去label後面的value來自哪一個變數
melt(DT, "ID1", c("O1", "O2", "O3"),
     variable.name = "O", value.name = "V")

## 以ID1作為展開，其他column (O1 ~ O2)會疊成一個變數
## 還會有一個新類別去label後面的value來自哪一個變數
melt(DT, "ID1", c("O1", "O2"),
     variable.name = "O", value.name = "V")

##
##gather
##
(DT = data.table(id = paste0("P", 1:2), O1 = c(12,13), O2 = c(18,15)))
#    id O1 O2
# 1: P1 12 18
# 2: P2 13 15

(DT_long = gather(DT, O, V, -id))
#    id  O  V
# 1: P1 O1 12
# 2: P2 O1 13
# 3: P1 O2 18
# 4: P2 O2 15

DT = data.table(ID1 = paste0("ID1_", 1:20),
                ID2 = sample(paste0("ID2_", 1:20)),
                O1 = rnorm(20), O2 = rnorm(20), O3 = rnorm(20))
gather(DT, O, V, -ID1, -ID2) ##保留ID1 ID2 作melt
gather(DT, O, V, -ID1, -ID2) %>% select(-ID2) ##剔除ID2
gather(DT, O, V, -ID1, -ID2) %>% select(-ID2) %>% filter(O!="O3")

#spread
#提供gather的反向操作
DT = data.table(id = paste0("P", 1:2), O1 = c(12,13), O2 = c(18,15))
DT_long = gather(DT, O, V, -id)
DT_long %>% spread(O, V)

#separate
#把特定column做strsplit，並設定成新的變數
DT = data.table(x = paste0(sample(LETTERS, 5), ",", sample(LETTERS, 5)))
DT %>% separate(x, paste0("V", 1:2))

DT = data.table(x = paste0(sample(LETTERS, 5), sample(LETTERS, 5)))
DT %<>% mutate(x = gsub("([A-Z])", "\\1, ", x))
DT %>% separate(x, paste0("V", 1:3)) %>% select(-V3)
