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

min=1
max=1000000
tv = min:max

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

globle_n <<- 0
system.time(
  tv<-sapply(tv,function(x){
    globle_n <<- globle_n + 1
    x = x*globle_n
    # return(tv)
  } 
  )
)

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