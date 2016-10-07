##ptt crawler
library(rvest)
library(dplyr)
library(data.table)

ptt_list_crawler <- function(link, min=1, max=9999999, forum_name = paste0('ptt ',substr(link,unlist(gregexpr(pattern ='bbs',link))+4,unlist(gregexpr(pattern ='index',link))-2))){
  ##
  link <- substr(link, 1, 
                 gregexpr("index",link)[[1]][length(gregexpr("index",link)[[1]])] + 4)
  article_url_list <- {}
  ##Get posts' urls form lists of pages.
  print(forum_name)
  for(i in min:max){
    tmp <- paste(i, ".html", sep="")
    url <- paste(link, tmp, sep="")
    tryCatch({
      ##articles' url
      article_url <- read_html(url) %>% html_nodes(".title") %>% html_nodes("a") %>% html_attr('href')
      
      article_url_list <- c(article_url_list,article_url)
      gc() 
      cat("\r ", forum_name, "- Page: ", i)
      Sys.sleep(runif(1,2,5))
      
      e <- i
      }, error = function(e) {
        ##conditionMessage(e)
        ##e$message <- paste0(forum_name, " latest page: ", i-1)
        ##stop(e)
    })
    ## Has Accessed to the last page: break
    if(e!=i){
      break
    }
  }
  cat("\r ", forum_name, " latest page: ", i-1)
  ##latest page
  cat("\n ")
  
  ##default value of max
  if(max==9999999)
    max <- i - 1 
  
  print(paste0('Has Accessed to the last page : Page ', max))
  article_url_list <- unique(article_url_list)
  
  ptt_df <- data.frame("Url" = paste0("https://www.ptt.cc", article_url_list),
                       "Title"="", "Date"="", "Author"="", "Content"="", "Reply"="", 
                       "Repliers"="", stringsAsFactors=F)
  
  output_list <- list(forum_name, min, max, ptt_df)
  names(output_list) <- c("forum_name", "min", "max", "ptt_df")
  return(output_list)
}

ptt_article_crawler <- function(x = "", stuck = "n"){
  if(x != ""){
    forum_name <- x$forum_name
    min        <- x$min
    max        <- x$max
    ptt_df     <- x$ptt_df
    rm(x)
    
    cat("Create output folders...")
    dir.create(paste0(".\\output\\", forum_name, "\\raw data\\tmp"), showWarnings = FALSE, recursive = TRUE)
  }else{
    ##if x == "", stuck should be "y"
    print("please select the tmp file which you want to keep on crawling...")
    ptt_df <- fread(file.choose())
    start  <- which(ptt_df[,2:6]=="")[1]
    
    forum_name <- readline("enter a forum name: ")
    min        <- readline("enter a min for: ")
    max        <- readline("enter a forum name: ")
    ptt_df     <- x$ptt_df
    rm(x)
    
    cat("Create output folders...")
    dir.create(paste0(".\\output\\", forum_name, "\\raw data\\tmp"), showWarnings = FALSE, recursive = TRUE)
    
  }
  
  ##Start to crawl out the contents...
  ##if stucked...
  if(stuck=="y"){
    print("please select the tmp file which you want to keep on crawling...")
    ptt_df <- fread(file.choose())
    start  <- which(ptt_df[,2:6]=="")[1]
  }else{
    start <- 1 
  }
  for(i in start:nrow(ptt_df)){
    tryCatch({
      url       <- ptt_df$Url[i]
      total_css <- read_html(url) 
      
      content_css <- total_css %>% html_nodes("#main-content") %>% html_text() # %>% iconv(., "UTF-8")
      
      meta_value  <- total_css %>% html_nodes(".article-meta-value") %>% html_text()
      if(length(meta_value)==4){
        author <- meta_value[1]
        title  <- meta_value[3] # %>% iconv(., "UTF-8")
        date   <- meta_value[4]
      }
      
      reply_msg <- total_css %>% html_nodes(".push-content") %>% html_text() %>% 
        paste(., collapse="\n") #%>% iconv(., "UTF-8")
      reply_id  <- total_css %>% html_nodes(".push-userid") %>% html_text() %>% paste(., collapse="\n")
      
      content <- substr(content_css, gregexpr("\n", content_css, fixed=TRUE)[[1]][1], gregexpr("發信站: 批踢踢實業坊(ptt.cc)", content_css, fixed=TRUE)[[1]][1] - 3)
      
      ptt_df$Title[i]    <- title
      ptt_df$Date[i]     <- date
      ptt_df$Author[i]   <- author
      ptt_df$Content[i]  <- content
      ptt_df$Reply[i]    <- reply_msg
      ptt_df$Repliers[i] <- reply_id
      
      gc()
      write.csv(ptt_df, paste0(".\\output\\", forum_name, "\\raw data\\tmp\\", forum_name,"_", min, "_", max, "_tmp.csv"), row.names=FALSE)
      Sys.sleep(runif(1,2,5))
      cat("\r PTT article: ",i, " ==>", i/nrow(ptt_df)*100, "% completed.",paste(replicate(50, " "), collapse = ""))
    }, error = function(e) {
      cat("\n ")
      print(paste0(forum_name, " PTT article: ", i, " failed. ", i/nrow(ptt_df)*100, "%"))
      Sys.sleep(runif(1,2,5))
    })
  }
  cat("\n ")
  print(paste0(forum_name,' : ',nrow(ptt_df),' articles.'))
  
  ptt_df = unique(ptt_df)
  
  #write.csv(ptt_df, paste0(".\\output\\", forum_name,"\\raw data\\", "\\", forum_name,"_", min, "_", max, ".csv"), row.names=F)
  
  ## split the data frame into multiple output files
  ptt_df$split_id <- sort(rep(1:((nrow(ptt_df) %/% 10000)+1),10000))[1:nrow(ptt_df)]
  spt_ptt_df <- split(ptt_df, ptt_df$split_id) 
  ##invisible: stop lapply from printing to console
  lapply(names(spt_ptt_df), function(x){
    write.csv(spt_ptt_df[[x]] %>% select(-split_id), paste0(".\\output\\", forum_name,"\\raw data\\", forum_name,"_", min, "_", max, "-", x, ".csv"), row.names = FALSE)
  }) %>% invisible
}
