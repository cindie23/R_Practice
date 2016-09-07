#https://www.youtube.com/watch?v=PYy5C9IIgp8
#http://stackoverflow.com/questions/29861117/r-rvest-scraping-a-dynamic-ecommerce-page

#Run selenium server
#cmd
#java -jar selenium-server-standalone-2.53.1.jar
library(RSelenium)
library(rvest)
library(httr)
library(jiebaR)
library(text2vec)

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

#url= "https://www.ptt.cc/bbs/car-pool/index.html"
remDr <- remoteDriver(remoteServerAddr = "localhost"
                      , port = 4444
                      , browserName ="firefox"
)
remDr$open() #open browser
remDr$getStatus()#check the status of browser

url = "http://icap.wda.gov.tw/Resources/resources_Datum.aspx"

remDr$navigate(url)# website to crawl

for(pagelimit in 1:8){
  #get the page 
  page_source<-remDr$getPageSource()
  #parse it
  html_source <- read_html(page_source[[1]])
  links  <- html_source %>% html_nodes("td a") %>%  html_attr("href")
  fnames <- html_source %>% html_nodes("td a") %>%  html_text()
  fnames <- fnames[grepl("pdf", links)]
  links  <- links[grepl("pdf", links)]
  
  for(i in 1:length(fnames)){
    destfile <- paste0(fnames[i], "職能基準.pdf")
    destfile <- gsub("/", "／",destfile)
    url <- paste0("http://icap.wda.gov.tw/", links[i] %>% substr(., 4, nchar(links[i])))
    download.file(url, destfile, mode="wb")
    Sys.sleep(runif(1, min = 1, max = 3))
  }
  if(pagelimit < 8){
    webElem <- remDr$findElement("id","ctl00_ContentPlaceHolderNoMenu_pager_lbtn_nextpage")
    webElem$clickElement()
    Sys.sleep(runif(1, min = 3, max = 5))
  }
}

