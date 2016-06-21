trim_mix = function(x){
  
  x = gsub("^\\)+|\\(+$",'',x)
  ##trim要重複用
  ##才刪個乾淨
  
  x = gsub("^[0-9０-９a-zA-Z一-十四√]+[:、‧ )）.]",'',x)
  
  ##..國字也可以?真是驚奇的發現
  ##真怪 四沒自動處理掉
  x = gsub("^[(（][0-9０-９a-zA-Z一-十四]+[)）]",'',x)
  
  x = gsub("^◎",'',x)
  
  if(grepl('^[(（＜]+',x) &　grepl('[)）＞]+$',x)){
    x = gsub("^[(（＜]+|[(（＜]+$",'',x)
  }
    
  
  x = gsub("^[0-9０-９]+[-][0-9０-９]+",'',x)
  
  if(grepl('\\)',x) & grepl('\\(',x) & length(unlist(gregexpr('\\)',x)))==1 & length(unlist(gregexpr('\\(',x)))==1){
    if(unlist(gregexpr('\\)',x)) < unlist(gregexpr('\\(',x))){
      x='' ##最後要移除
    }
  }
  
  if(grepl('[0-9][0-9]:[0-9][0-9]',x)){
    x = ''
  }
  ##有時間就移除
  if(grepl('[0-9][/][0-9]',x)){
    x = ''
  }
  
  
  ##次數大於1移除?
  #if(length(unlist(gregexpr(pattern ="[0-9０-９a-zA-Z]+[、‧ )）.]",x)))>1 | unlist(gregexpr(pattern ="[0-9０-９a-zA-Z]+[.]",x))>1){
  #  #print(x)
  #  x = ''
  #}
  return(x)
}