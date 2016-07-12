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

