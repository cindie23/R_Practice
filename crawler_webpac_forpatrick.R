rm(list = ls()) #去除工作空間中所有物件
gc() #記憶體釋放

path = choose.dir()
setwd(path)
library(rvest)

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

trim_num <- function (x){
  #gsub("^[[:punct:]]+|[[:punct:]]+$", "", x)
  gsub("^[0-9]+|[0-9]+$", "\\1", x)
}

trim_split_punc <- function (x){
  #gsub("^[[:punct:]]+|[[:punct:]]+$", "", x)
  x = gsub("[[:punct:]]", "＊", x)
  x = unlist(strsplit(x,'＊'))
  x = x[which(nchar(x)==max(nchar(x)))][1]
  return(x)
}

##第一PART 爬出ISBN
#TED Talk十八分鐘的祕密
#中國悄悄占領全世界
df = read.csv(file.choose(),stringsAsFactors=F)

name_list = df$書名

export_df = data.frame('名稱'=character(),'ISBN'=character(),'出版年'=character(),'館藏冊數'=character(),stringsAsFactors=F)
export_df[1:length(name_list),1] = name_list

tmp_url='http://webpac.tphcc.gov.tw/toread/opac/search?q='

for(xx in 1:length(name_list)){
  tryCatch({
    n = name_list[xx]
    n_trim = gsub('[a-zA-Z]','+',n)
    n_trim = gsub('%',' ',n_trim)
    n_trim = gsub(' ','+',n_trim)
    n_trim = trim(n_trim)
    n_trim = trim_num(n_trim)
    n_trim = unlist(strsplit(n_trim,'：'))[1]
    n_trim = unlist(strsplit(n_trim,':'))[1]
    n_trim = unlist(strsplit(n_trim,'，'))[1]
    
    
    url = paste0(tmp_url,n_trim)
    total_css = read_html(url)
    content_css = total_css %>% html_nodes("li") %>% html_text()
    content_css = iconv(content_css,'utf8')
    content_css  = gsub('\n','',content_css)
    content_css  = gsub('\r','',content_css)
    content_css = trim(content_css)
    
    #catch_ISBN = content_css[(which(grepl('ISBN',content_css))[1]+1):(length(content_css))]
    #catch_ISBN = content_css[(which(grepl('ISBN',content_css))[1]+1):(length(content_css))]
    #catch_ISBN = content_css[(which(grepl('單行本',content_css) & grepl('中文',content_css) & grepl('ISBN',content_css) & grepl(trim_split_punc(n),content_css))[1]+1):(length(content_css))]
    catch_ISBN = content_css[(which(grepl('單行本',content_css) & grepl('中文',content_css) & grepl('ISBN',content_css) & grepl(trim_split_punc(n_trim),content_css)))]
    catch_ISBN2 =''
    if(length(catch_ISBN)>1){
      catch_ISBN2 = catch_ISBN[which(grepl(substr(df$出版社[xx],1,2),catch_ISBN))]
    }
    if(toString(catch_ISBN2)!=''){
      catch_ISBN = catch_ISBN2
    }
    catch_ISBN = unlist(strsplit(catch_ISBN,'                                      '))
    
    if(is.null(catch_ISBN)){
      catch_ISBN = content_css
    }
    
    books = trim(gsub('館藏流通狀態:','',catch_ISBN[which(grepl('館藏流通狀態',catch_ISBN) & !grepl('版本項',catch_ISBN))]))
    
    for(bl in 1:length(books)){
      books[bl] = substr(books[bl],1,unlist(gregexpr(pattern ='館藏',books[bl]))[1]-2)
    }
    books = sum(as.numeric(books))
    
    export_df[which(export_df$名稱==n),2:4] = c(unique(trim(gsub('ISBN:','',catch_ISBN[which(grepl('ISBN',catch_ISBN) & !grepl('出版',catch_ISBN))])))[1]
                      ,unique(trim(gsub('出版年:','',catch_ISBN[which(grepl('出版年',catch_ISBN) & !grepl('流通',catch_ISBN))])))[1]
                      ,books)
    
    ##
    links = total_css %>% html_nodes("li a") %>% html_attr('href')
    links = links[grepl('bibliographic_view',links)]
    
    cat(paste0('\r','名稱: ',n,'  ',round(xx/length(name_list)*100,3),'%',paste0(rep(' ',50),collapse=' ')))
    Sys.sleep(runif(1,2,5))
  }, error = function(e) {
    print(conditionMessage(e) )# 這就會是"demo error"
    print(n)
  })
 
}

write.csv(export_df,'D:\\abc\\wjhong\\projects\\webpac_forpatrick_2013_非文學.csv',row.names=F)

##第二PART 用ISBN逆爬
library(tmcn)

file_name= file.choose()
df = read.csv(file_name,stringsAsFactors=F)

df$ISBN逆查書名=''

for(i in 1:nrow(df)){
  if(!grepl(';',df$ISBN[i]) & !is.na(df$ISBN[i]) & nchar(df$ISBN[i])>5){
    url = paste0(tmp_url,df$ISBN[i])
    total_css = read_html(url)
    
    content_css = total_css %>% html_nodes("li") %>% html_text()
    content_css = toUTF8(content_css)
    content_css  = gsub('\n','',content_css)
    content_css  = gsub('\r','',content_css)
    content_css = trim(content_css)
    
    catch_ISBN = content_css[(which(grepl('單行本',content_css) & grepl('中文',content_css) & grepl('ISBN',content_css)))]
    catch_ISBN = unlist(strsplit(catch_ISBN,'                                      '))
    catch_ISBN = catch_ISBN[1]
    catch_ISBN = trim(substr(catch_ISBN, max(unlist(gregexpr('\t',catch_ISBN)))+3,nchar(catch_ISBN)-1))
    if(toString(catch_ISBN)==''){
      catch_ISBN='錯誤'
    }
    df$ISBN逆查書名[i] = catch_ISBN
  }else if(grepl(';',df$ISBN[i])){
    df$ISBN逆查書名[i] = "多個ISBN"
  }else if(is.na(df$ISBN[i])){
    df$ISBN逆查書名[i] = "錯誤"
  }
  
  cat(paste0('\r','ISBN: ',df$ISBN[i],' 書名:',df$ISBN逆查書名[i],'  ',round(i/nrow(df)*100,3),'%',paste0(rep(' ',50),collapse=' ')))
  Sys.sleep(runif(1,2,5))
}

write.csv(df,paste0('逆查',basename(file_name)),row.names=F)
basename(file_name)

##用不到
if(F){
  export_df$ISBN = trim(gsub('ISBN:','',export_df$ISBN))
  #export_df$ISBN = format(export_df$ISBN, scientific = FALSE)
  export_df$ISBN = as.character(export_df$ISBN)
  export_df$出版年 = trim(gsub('出版年:','',export_df$出版年))
  export_df$館藏冊數 = trim(gsub('館藏流通狀態:','',export_df$館藏冊數))
  for(i in 1:nrow(export_df)){
    export_df$館藏冊數[i] = substr(export_df$館藏冊數[i],1,unlist(gregexpr(pattern ='館藏',export_df$館藏冊數[i]))[1]-2)
  }
  export_df$館藏冊數 = trim(export_df$館藏冊數)
}




