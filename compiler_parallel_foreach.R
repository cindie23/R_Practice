##將函數編譯成二進制程序，加快速度
myFunction<-function() { for(i in 1:1e7) { 1*(1+1) } }
library(compiler)
myCompiledFunction <- cmpfun(myFunction) # ??????函???
system.time( myFunction() )
system.time( myCompiledFunction() )
##

library(parallel)
n=5e6
doit <- function(x)(x)^2+2*x
system.time(res<-lapply(1:n,doit))
rm(res)
gc()
cl <-makeCluster(getOption("cl.cores",3) )
system.time(res<-parLapply(cl,1:n,doit))
stopCluster(cl)
##

func <- function(x) {
  n = 1
  raw <- x
  while (x > 1) {
    x <- ifelse(x%%2==0,x/2,3*x+1)
    n = n + 1
  }
  return(c(raw,n))
}
library(parallel)
# 用system.time???返回???算所需??????
system.time({
  x <- 1:1e6
  cl <- makeCluster(4)  # 初始化四核心集群
  results <- parLapply(cl,x,func) # lapply的并行版本
  res.df <- do.call('rbind',results) # 整合???果
  stopCluster(cl) # ??????集群
})
# 找到最大的步?????????的???字
res.df[which.max(res.df[,2]),1]

##
library(foreach)
# 非并行???算方式，???似于sapply函???的功能
x <- foreach(x=1:1000,.combine='rbind') %do% func(x)
system.time(foreach(x=1:1000,.combine='rbind') %do% func(x))
res<-parLapply(cl,1:n,doit)
system.time(res = foreach(x=1:n,.combine=rbind) %do% doit(x))

# ???用parallel作???foreach并行???算的后端
library(doParallel)
cl <- makeCluster(4)
registerDoParallel(cl)
# 并行???算方式
system.time(foreach(x=1:1000,.combine='rbind') %dopar% func(x))
x <- foreach(x=1:1000,.combine='rbind') %dopar% func(x)
stopCluster(cl)
##


# ???机森林的并行???算
library(randomForest)
cl <- makeCluster(4)
registerDoParallel(cl)
rf <- foreach(ntree=rep(25000, 4), 
              .combine=combine,
              .packages='randomForest') %dopar%
  randomForest(Species~., data=iris, ntree=ntree)
stopCluster(cl)
###
##test
n=5e6
##normal
system.time(res<-lapply(1:n,doit))
#compile
system.time(res<-lapply(1:n,cmpfun(doit)))
#parallel
cl <-makeCluster(getOption("cl.cores",3) )
system.time(res<-parLapply(cl,1:n,doit))
stopCluster(cl)
#compile + parallel
cl <-makeCluster(getOption("cl.cores",3) )
system.time(res<-parLapply(cl,1:n,cmpfun(doit)))
stopCluster(cl)


##參考資料
#http://www.seekingqed.com/programming/r/acceleration
#http://www.r-bloggers.com/lang/chinese/1131