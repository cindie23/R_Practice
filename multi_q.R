library(plyr)

options(stringsAsFactors=F)
people <- read.csv(file.choose())

trim = function(x){
  gsub("^[[:punct:]]+|[[:punct:]]+$", "", x)
}


ddply(people, c('性別','Q1'), nrow)
ddply(people, c('性別','Q2'), nrow)

##該題目欄位數
##改成 想要解的題目col name, 切的變項名稱 , 變像叫啥
multi_q = function(iname,varname){
  i = which(colnames(people)==iname)
  varx = which(colnames(people)==varname)
  levels = unique(people[,varx])
  levels = levels[which(levels!='')]
  for(var in 1:length(levels)){
    if(var==1){
      df = cbind(as.data.frame(table(unlist(strsplit(people[,i],', ')[which(people[,varx]==levels[var])]))),levels[var])
      colnames(df) = c('選項','Freq',varname)
    }else{
      df_tmp = cbind(as.data.frame(table(unlist(strsplit(people[,i],', ')[which(people[,varx]==levels[var])]))),levels[var])
      colnames(df_tmp) = c('選項','Freq',varname)
      df = rbind(df,df_tmp)
    }
  }
  return(df)
}
