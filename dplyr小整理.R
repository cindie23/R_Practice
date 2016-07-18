library(dplyr)
library(FSAdata)
library(plotrix)

##dplyr
##select 抓出col
##filter 篩選出col中為某值
##arrange 用來排序
##xtabs 觀看某col分布狀況
## group_by + summarize 類似樞紐分析
##mutate增加以及轉換col內容
##mutate_each 轉換所有col

data(RuffeSLRH92) ##FSAdata
str(RuffeSLRH92)
RuffeSLRH92 <- select(RuffeSLRH92,-fish.id,-indiv,-day,-year) ##剔除fish.id....
str(RuffeSLRH92)
ruffeLW <- select(RuffeSLRH92,length,weight) ##選出length...
str(ruffeLW)
ruffeL <- select(RuffeSLRH92,contains("l")) ##選出名稱含有l..
str(ruffeL)


male <- filter(RuffeSLRH92,sex=="male") ##篩選出sex=male的資料集..
xtabs(~sex,data=male) #the distribution of one factor variable;
                      #the relationship between two factor variables.
male <- droplevels(male) #drop unused levels from a factor or, more commonly, from factors in a data frame.
xtabs(~sex,data=male)

maleripe <- filter(RuffeSLRH92,sex=="male",maturity=="ripe")
xtabs(~sex+maturity,data=maleripe)
xtabs(~sex+maturity,data=maleripe %>% droplevels)

maleripe2 <- filter(RuffeSLRH92,sex=="male" | maturity=="ripe")
xtabs(~sex+maturity,data=maleripe2)

malea <- arrange(male,length) #The arrange() function can be used to order individuals. 
                              #The first argument is the data.frame 
                              # and the following arguments are the variables to sort by.
head(malea)
head(arrange(male,-length))
arrange(male,desc(length)) %>% head

ruffe2 <- arrange(RuffeSLRH92,length,weight)
head(ruffe2)

ruffeLW <- mutate(ruffeLW,LplusW=(length+weight),LminusW=(length-weight))
head(ruffeLW)
mutate(ruffeLW,LplusW=(length+weight),"L-W"=(length-weight)) %>% head

##類似樞紐分析
byMon <- group_by(RuffeSLRH92,month) ##以month為基準
sumMon <- summarize(byMon,count=n()) 

byMonSex <- group_by(RuffeSLRH92,month,sex)
sumMonSex <- summarize(byMonSex,count=n())

LenSumMon <- summarize(byMon,n=n(),mn=mean(length),sd=sd(length))

fnl1 <- RuffeSLRH92 %>%
  group_by(month) %>%
  summarize(n=n()) %>%
  mutate(prop.catch=n/sum(n)) %>%
  arrange(desc(prop.catch))
fnl1
fnl1$prop.catch %>% sum

fnl2 <- RuffeSLRH92 %>%
  group_by(month) %>%
  summarize(n=n(),mn=mean(length),sd=sd(length)) %>%
  mutate(se=sd/sqrt(n),LCI=mn+qnorm(0.025)*se,UCI=mn+qnorm(0.975)*se)
fnl2

dfx <- data.frame(
  group = c(rep('A', 8), rep('B', 15), rep('C', 6)),
  sex = sample(c("M", "F"), size = 29, replace = TRUE),
  age = runif(n = 29, min = 18, max = 54)
)
ddply(dfx, .(group, sex), summarize,
      mean = round(mean(age), 2),
      sd = round(sd(age), 2))
ddply(dfx, c('group', 'sex'), summarize,
      mean = round(mean(age), 2),
      sd = round(sd(age), 2))


mutate(airquality, Ozone = -Ozone) %>% head ##把Ozone的值變成-的
mutate(airquality, Temp = (Temp - 32) / 1.8, OzT = Ozone / Temp) %>% head ##轉換跟增加col


airquality %>% mutate_each(funs(-(.))) %>% head ##一次處理全部COL
# mutate is rather faster than transform
system.time(transform(baseball, avg_ab = ab / g))
system.time(mutate(baseball, avg_ab = ab / g))
