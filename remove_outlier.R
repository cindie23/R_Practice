options(stringsAsFactors = FALSE)

tmp = read.csv(file.choose())

colnames(tmp)

#x[!x %in% boxplot.stats(x)$out]
tp = tmp$工作待遇[which(tmp$工作待遇>19000 & grepl('台北',tmp$工作地點))]
kao = tmp$工作待遇[which(tmp$工作待遇>19000 & grepl('高雄',tmp$工作地點))]
xing = tmp$工作待遇[which(tmp$工作待遇>19000 & grepl('新竹',tmp$工作地點))]

mean(tp[!tp %in% boxplot.stats(tp)$out])
mean(kao[!kao %in% boxplot.stats(kao)$out])
mean(xing[!xing %in% boxplot.stats(xing)$out])
