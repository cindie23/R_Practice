##算是樞紐分析吧

library(plyr)
# Let's extract the number of teams and total period of time
# covered by the baseball dataframe
summarise(baseball,
          duration = max(year) - min(year),
          nteams = length(unique(team)))
# Combine with ddply to do that for each separate id
head(ddply(baseball, "id", summarise,
           duration = max(year) - min(year),
           nteams = length(unique(team))))

head(ddply(baseball, .(id,team), c("nrow", "ncol")))

#####
#####

# Summarize a dataset by two variables
dfx <- data.frame(
  group = c(rep('A', 8), rep('B', 15), rep('C', 6)),
  sex = sample(c("M", "F"), size = 29, replace = TRUE),
  age = runif(n = 29, min = 18, max = 54)
)

# Note the use of the '.' function to allow
# group and sex to be used without quoting
ddply(dfx, .(group, sex), summarize,
      mean = round(mean(age), 2),
      sd = round(sd(age), 2))
ddply(dfx, c('group', 'sex'), summarize,
      mean = round(mean(age), 2),
      sd = round(sd(age), 2))


dfx <- data.frame(
  '群組' = c(rep('A', 8), rep('B', 15), rep('C', 6)),
  '性別' = sample(c("M", "F"), size = 29, replace = TRUE),
  '年齡' = runif(n = 29, min = 18, max = 54)
)
ddply(dfx, c('群組', '性別'), summarize,
      mean = round(mean(年齡), 2),
      sd = round(sd(年齡), 2))

# An example using a formula for .variables
ddply(baseball[1:100,], ~ year, nrow)
# Applying two functions; nrow and ncol
ddply(baseball, .(lg), c("nrow", "ncol"))

# Calculate mean runs batted in for each year
rbi <- ddply(baseball, .(year), summarise,
             mean_rbi = mean(rbi, na.rm = TRUE))
# Plot a line chart of the result
plot(mean_rbi ~ year, type = "l", data = rbi)

# make new variable career_year based on the
# start year for each player (id)
base2 <- ddply(baseball, .(id), mutate,
               career_year = year - min(year) + 1
)



###
rm(list = ls()) #去除工作空間中所有物件
gc() #記憶體釋放
path<-"C:\\Documents and Settings\\wjhong\\桌面\\資料探勘\\樞紐分析"
setwd(path)

##中文的樞紐寫法
satisfy <- read.csv('讀者滿意度分析_1041129.csv')
##計算各身分別的個數
ddply(satisfy, c('X2.身份別','X1.性別'), nrow)

##計算各身分別的平均滿意度
ddply(satisfy , 'X2.身份別', summarize, mean = round(mean(X6.同仁服務與態度), 2), sd = round(sd(X6.同仁服務與態度), 2))

ddply(satisfy , c('X2.身份別','X1.性別'), summarize, mean = round(mean(X6.同仁服務與態度), 2), sd = round(sd(X6.同仁服務與態度), 2))

##計算各身分別性別的平均滿意度
rbi <- ddply(satisfy, 'X2.身份別', summarize, mean = round(mean(X6.同仁服務與態度), 2))
plot(mean ~ X2.身份別, type = "l", data = rbi)
#head(ddply(baseball, .(id,team), c("nrow", "ncol")))

# Calculate mean runs batted in for each year
rbi <- ddply(satisfy, 'X2.身份別', nrow)
# Plot a line chart of the result
png(paste("C:\\Documents and Settings\\wjhong\\桌面\\plyr\\身分", ".png", sep = ''), 
    width=1200, height=700)#, units="in", res=700)
plot(V1 ~ X2.身份別, type = "p", data = rbi)
dev.off()


#
#plot type =l =線
#=p = 點
#=b =點線
#=h= histogram