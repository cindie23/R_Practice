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


min=1
max=1000000
tv = min:max

system.time(  for( i in min:max){
  tv[i]=tv[i]*i
}       )

system.time(
  tv<-sapply(min:max,test2 )
  )


test2 = function(x){
  #Sys.sleep(0.1)
  #print(x)
  tv[x] = tv[x]*x
}



system.time(  for( i in min:max){
  tv[i]=tv[i]*i
}       )

##using globle variable
##很快 不過沒loading
##print會慢超多
globle_n <<- 1 
system.time(
  tv<-sapply(tv,function(x){
    x = x*globle_n
    globle_n <<- globle_n + 1
    ##print(x)
    return(x)
  } 
 )
)

##using globle variable
##超慢
globle_n <<- 1 
system.time(
  tv<-pbsapply(tv,function(x){
    x = x*globle_n
    globle_n <<- globle_n + 1
    return(tv)
  } 
  )
)

pb <- txtProgressBar(min = 0, max = max, style = 3)
system.time(  for( i in min:max){
  tv[i]=tv[i]*i
    # update progress bar
    setTxtProgressBar(pb, i)
  
  close(pb)
}       )

##using globle variable

pb <- txtProgressBar(min = 0, max = max, style = 3)
globle_n <<- 1 
system.time(
  tv<-sapply(tv,function(x){
    x = x*globle_n
    globle_n <<- globle_n + 1
    # create progress bar
    # update progress bar
    setTxtProgressBar(pb, globle_n)
    return(tv)
    #close(pb)
    #return(tv)
  } 
  )
)

sapply_pb <- function(X, FUN, ...)
{
  env <- environment()
  pb_Total <- length(X)
  counter <- 0
  pb <- txtProgressBar(min = 0, max = pb_Total, style = 3)
  
  wrapper <- function(...){
    curVal <- get("counter", envir = env)
    assign("counter", curVal +1 ,envir=env)
    setTxtProgressBar(get("pb", envir=env), curVal +1)
    FUN(...)
  }
  res <- sapply(X, wrapper, ...)
  close(pb)
  res
}

##error in allocating vector size
##處理掉了 可跑了
globle_n <<- 0
system.time(
  tv<-sapply_pb(tv,function(x){
    
    globle_n <<- globle_n + 1
    x = x*globle_n
   # return(tv)
  } 
  )
)

##error in allocating vector size
globle_n <<- 0
system.time(
  tv<-sapply(tv,function(x){
    globle_n <<- globle_n + 1
    x = x*globle_n
    # return(tv)
  } 
  )
)




##這個做法有問題
system.time(
  tv<-sapply(min:max,function(x) tv[x] = tv[x]*2 )
)