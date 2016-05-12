library(rvest)

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

#TED Talk十八分鐘的祕密
#中國悄悄占領全世界
name_list = c('別相信任何人','TED Talk十八分鐘的祕密','中國悄悄占領全世界')

export_df = data.frame('名稱'=character(),'ISBN'=character(),'出版年'=character(),'館藏冊數'=character())
x=1

for(xx in 1:length(name_list)){
  n = name_list[xx]
  n_trim = gsub('[a-zA-Z0-9]','',n)
  n_trim = trim(n_trim)
  tmp_url='http://webpac.tphcc.gov.tw/toread/opac/search?q='
  
  url = paste0(tmp_url,n_trim)
  total_css = read_html(url)
  content_css = total_css %>% html_nodes("li") %>% html_text()
  content_css = iconv(content_css,'utf8')
  content_css  = gsub('\n','',content_css)
  content_css  = gsub('\r','',content_css)
  content_css = trim(content_css)
  
  #catch_ISBN = content_css[(which(grepl('ISBN',content_css))[1]+1):(length(content_css))]
  #catch_ISBN = content_css[(which(grepl('ISBN',content_css))[1]+1):(length(content_css))]
  catch_ISBN = content_css[(which(grepl('單行本',content_css) & grepl('中文',content_css) & grepl('ISBN',content_css))[1]+1):(length(content_css))]
    
  export_df[x,] = c(n,catch_ISBN[which(grepl('ISBN',catch_ISBN))],catch_ISBN[which(grepl('出版年',catch_ISBN))],catch_ISBN[which(grepl('館藏流通狀態',catch_ISBN))])
  
  x = x + 1
  cat(paste0('\r','名稱: ',substr(n,1,5),'...'))
  Sys.sleep(runif(1,2,5))

}

export_df$ISBN = trim(gsub('ISBN:','',export_df$ISBN))
#export_df$ISBN = format(export_df$ISBN, scientific = FALSE)
export_df$ISBN = as.character(export_df$ISBN)
export_df$出版年 = trim(gsub('出版年:','',export_df$出版年))
export_df$館藏冊數 = trim(gsub('館藏流通狀態:','',export_df$館藏冊數))
for(i in 1:nrow(export_df)){
  export_df$館藏冊數[i] = substr(export_df$館藏冊數[i],1,unlist(gregexpr(pattern ='館藏',export_df$館藏冊數[i]))[1]-1)
}

write.csv(export_df,'D:\\abc\\wjhong\\projects\\webpac_forpatrick.csv',row.names=F)

