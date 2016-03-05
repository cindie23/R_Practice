##平行運算
#install.packages('snow')
#install.packages('Rmpi')

library(snow)
library(Rmpi)
cl <- makeCluster(2,type="MPI")
cl <- makeCluster(3)

result <- rep(NA,1000)
system.time(sapply(1:1000,function(i) mean(rnorm(10000))))
system.time(parSapply(cl,1:1000,function(i) mean(rnorm(10000))))
stopCluster(cl)


##參考文獻
#https://sites.google.com/site/rnotewush/ping-xing-yun-suan
#https://bioinfomagician.wordpress.com/2013/11/18/installing-rmpi-mpi-for-r-on-mac-and-windows/comment-page-1/
#http://www.stats.uwo.ca/faculty/yu/Rmpi/
#http://www.stats.uwo.ca/faculty/yu/Rmpi/windows2.htm
#mpich2-1.4.1p1-win-x86-64.msi