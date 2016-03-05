##ff ffbase讀取大數據文本至硬碟做處理
##類似df
library('ffbase')
read.csv.nf <- function(x){
  read.csv(x,stringsAsFactors=F)
}
hhp <- read.table.ffdf(file='D:\\Work Space\\R\\practice\\abc123.csv', FUN = "read.csv", na.strings = "")
read.csv.ffdf(file='D:\\Work Space\\R\\practice\\abc123.csv', na.strings = "")
class(hhp)
dim(hhp)
##http://www.bnosac.be/index.php/blog/22-if-you-are-into-large-data-and-work-a-lot-package-ff