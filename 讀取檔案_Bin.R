readBin(lvr_land.path, what = "raw", n =3)
readLines(file(lvr_land.path, encoding = "BIG5"), n = 1)
readLines(file(lvr_land.path, encoding = "BIG5"), n = 5)
file.info(lvr_land.path)
lvr_land.info=file.info(lvr_land.path)
colnames(lvr_land.info)
lvr_land.info$size
lvr_land.bin=readBin(lvr_land.path, what = "raw", n = lvr_land.info$size)
library(stringi)
lvr_land.txt<-stri_encode(lvr_land.bin, "BIG-5", "UTF-8")
read.table(lvr_land.path, fileEncoding = "BIG-5")
lvr_land<-read.table(lvr_land.path, fileEncoding = "BIG-5",header = TRUE, sep = ",")
l10n_info()#會回報系統對是否有支援UTF-8

'''
根據經驗，如果`l10n_info()`的輸出中，MBCS為TRUE且UTF-8 為FALSE， 則要使用：`textConnection(lvr_land.txt)`來從`lvr_land.txt`建立一個
connection。除此之外，則使用`textConnection(lvr_land.txt, encoding = "UTF-8")` 即可。請同學依據上一題的結果，在MBCS為TRUE且UTF-8
為FALSE時執行： `read.table(textConnection(lvr_land.txt), header = TRUE, sep = ",")` 否則，執行： `read.table(textConnection(lvr_land.txt,
encoding = "UTF-8"), header = TRUE, sep = ",")`
'''

'''
| 如果要使用R 讀取XML 的資料，可以使用套件XML 。如果要讀取JSON， 可以使用rjsonlite
| 。只要資料格式是公開格式，我們很容易找到R 的套件來 讀取該資料格式。這就是R 是Open Source 的威力！
'''

#' 請同學用這章節所學的技巧，讀取`orglist.path`的檔案
#' 資料來源：<http://data.gov.tw/node/7307>

# <你可以在這裡做各種嘗試>
answer.raw <- readBin(orglist.path, what = "raw", n = file.info(orglist.path)$size)
answer.txt <- stringi::stri_encode(answer.raw, from = "UTF-16", to = "UTF-8")
get_text_connection_by_l10n_info <- function(x) {
  info <- l10n_info()
  if (info$MBCS & !info$`UTF-8`) {
    textConnection(x)
  } else {
    textConnection(x, encoding = "UTF-8")
  }
}
answer <- read.table(get_text_connection_by_l10n_info(answer.txt), header = TRUE, sep = ",")
##
##
##
##測試編碼

readLines(file(hospital_path, encoding = "UTF-8"), n = 6)
readLines(file(hospital_path, encoding = "BIG5"), n = 6)##這才是正確的

hospital <- .read.table.big5(hospital_path, header = TRUE, sep = ",")

##

##lapply(tmp, "[", 2) 抓出tmp中每個值的[2]