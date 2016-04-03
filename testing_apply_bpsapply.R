total <- 200000
# create progress bar
pb <- txtProgressBar(min = 0, max = total, style = 3)
for(i in 1:total){
  #Sys.sleep(0.1)
  # update progress bar
  setTxtProgressBar(pb, i)
}
close(pb)


library(pbapply)

#system.time(pbsapply(l, mean))
#system.time(sapply(l, mean))
test = function(x){
  #Sys.sleep(0.1)
  x = x*2
}

sapply(iris[,1],test)
pbsapply(iris[,1],test)


test2 = function(x){
  #Sys.sleep(0.1)
  #print(x)
  iris[x,1] = iris[x,1]*x
}
pbsapply(1:nrow(iris),test2)
