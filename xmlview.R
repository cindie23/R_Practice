#install.packages("C:/Users/mao/Downloads/digest_0.6.9.zip", repos = NULL,type='source')
# devtools::install_github("hrbrmstr/xmlview")
library(xml2)
library(xmlview)
library(magrittr)

## read-in XML document
doc <- xml2::read_html("https://www.ptt.cc/bbs/Stock/M.1452818794.A.FEC.html", encoding = "UTF-8")
# xml_view(doc, add_filter = TRUE)
doc_string <- as.character(doc) %>% `Encoding<-`("UTF-8")
##somethings went wrong
xml_view(doc_string, add_filter=TRUE)
xml_find_all(doc, '//span[@class="f3 push-content"]', ns=xml2::xml_ns(doc))
## or you want to use rvest package
library(rvest)
# doc %>% rvest::html_nodes(xpath = '//span[@class="f3 push-content"]')
doc %>% 
  rvest::html_nodes(xpath = '//span[@class="f3 push-content"]') %>% 
  rvest::html_text() %>% 
  `Encoding<-`("UTF-8") %>% 
  gsub("^: ", "",.)
