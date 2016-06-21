rm(list = ls()) #去除工作空間中所有物件
gc() #記憶體釋放
#path<-"D:\\abc\\wjhong\\projects\\school_performence_analysis"
#setwd(path)

library(httr)
library(rvest)
library(tmcn)

##getting urls
all_links = c()
for(i in 1:19){
  if(i<10){
    url = paste0('http://campus4.ncku.edu.tw/uac/cross_search/class_info/D0',i,'.html')
    
    ##有些頁有問題, 加入此encoding
    total_css = read_html(url,encoding="ISO-8859-1")
    link_css = total_css %>% html_nodes("td a") %>% html_attr("href")
    link_css = unlist(lapply(link_css,function(link_css){
      unlist(strsplit(link_css,'/'))[length(unlist(strsplit(link_css,'/')))]
    }))
    
    links = paste0('http://campus4.ncku.edu.tw/uac/cross_search/dept_info/',link_css)
    
    all_links = c(all_links,links)
    cat(paste0('\r',i/19*100,'%'))
    Sys.sleep(runif(1,2,5))
  }else{
    url = paste0('http://campus4.ncku.edu.tw/uac/cross_search/class_info/D',i,'.html')
    
    ##有些頁有問題, 加入此encoding
    total_css = read_html(url,encoding="ISO-8859-1")
    link_css = total_css %>% html_nodes("td a") %>% html_attr("href")
    link_css = unlist(lapply(link_css,function(link_css){
      unlist(strsplit(link_css,'/'))[length(unlist(strsplit(link_css,'/')))]
    }))    
    links = paste0('http://campus4.ncku.edu.tw/uac/cross_search/dept_info/',link_css)
    
    all_links = c(all_links,links)
    cat(paste0('\r','抓取各頁內部網址 : ',format(round(i/19*100,2),nsmall=2),'%',paste(replicate(50, " "), collapse = "")))
    Sys.sleep(runif(1,2,5))
  }
  
}

##getting datas
output_df = data.frame('學校'=character(),'學系'=character(),'連結'=character(),'代碼'=character(),'學科能力測驗及英語聽力檢定標準'=character(),'學科能力測驗及英語聽力檢定標準2'=character(),'指定考試採計科目及方法'=character(),'同分參酌方式1'=character(),'同分參酌方式2'=character(),'同分參酌方式3'=character(),'選系說明'=character(),stringsAsFactors=F)
#total_css <-html(url,encoding="gb2312")

all_links = unique(all_links)
error = 0
x=1
for(i in 93:length(all_links)){
  tryCatch({
    total_css = read_html(all_links[i],encoding="big5")
    content_css = total_css %>% html_nodes("tr td") %>% html_text()
    title_css = total_css %>% html_nodes("title") %>% html_text()
    ##有亂碼問題
    ##content_css = iconv(content_css,'utf8')
    content_css = toUTF8(content_css)
    content_css = gsub(' ','',content_css)
    #content_css = gsub('    ','',content_css)
    title_css = toUTF8(title_css)
    cat(paste0('\r',title_css,' : ',format(round(i/length(all_links)*100,2),nsmall=2),'%',paste(replicate(50, " "), collapse = "")))
    title_css = unlist(strsplit(title_css,' -'))[1]
    
    Sys.sleep(runif(1,2,4))
    
    output_df[x,] = c(title_css,content_css[1],all_links[i],unlist(strsplit(unlist(strsplit(all_links[i],'/')),'[.]'))[length(unlist(strsplit(unlist(strsplit(all_links[i],'/')),'[.]')))-1],content_css[2],content_css[9],content_css[3],content_css[5],content_css[8],content_css[11],content_css[6])
    
    if(is.na(output_df[x-1,1])){
      output_df[x-1,] = c('錯誤','錯誤',all_links[i-1],unlist(strsplit(unlist(strsplit(all_links[i-1],'/')),'[.]'))[length(unlist(strsplit(unlist(strsplit(all_links[i-1],'/')),'[.]')))-1],'錯誤','錯誤','錯誤','錯誤','錯誤','錯誤','錯誤')
    }
    x = x + 1
  }, error = function(e) {
    #output_df[x,] <<- c('錯誤','錯誤',all_links[i],unlist(strsplit(unlist(strsplit(all_links[i],'/')),'[.]'))[length(unlist(strsplit(unlist(strsplit(all_links[i],'/')),'[.]')))-1],'錯誤','錯誤','錯誤','錯誤','錯誤','錯誤','錯誤')
    x <<- x + 1
    error <<- error + 1
    print(paste0(error,'筆錯誤'))
    print(paste0('錯誤率為 ', round(error/length(all_links),2)))
  })
}





library(XML)
library(RCurl)

get_url = getURL(url,encoding = "gb2312")
get_url_parse = htmlParse(get_url, encoding = "gb2312")

get_url = getURL(url,encoding = "gbk")
get_url_parse = htmlParse(get_url, encoding = "gbk")
