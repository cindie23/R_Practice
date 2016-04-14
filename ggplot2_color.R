library(ggplot2)
ggplot(airquality,aes(Wind,Temp)) + geom_point()
##alpha為透明度
ggplot(airquality,aes(Wind,Temp)) + geom_point(color="steelblue",alpha="0.4",size=5)
ggplot(airquality,aes(Wind,Temp)) + geom_point(aes(color=factor(Month)),alpha="0.4",size=5)

ggplot(airquality,aes(Wind,Temp)) + geom_point() + geom_smooth()
ggplot(airquality,aes(Wind,Temp)) + geom_point() + stat_smooth()
ggplot(airquality,aes(Wind,Temp)) + stat_smooth()
##指定方法 關閉自信區間
##aes美學處姓
ggplot(airquality,aes(Wind,Temp)) + stat_smooth(method="lm",se=F)
ggplot(airquality,aes(Wind,Temp)) + stat_smooth(method="lm",se=F,aes(col=factor(Month)))
ggplot(airquality,aes(Wind,Temp,col=factor(Month))) + stat_smooth(method="lm",se=F)
##顏色不同跑去點那了
ggplot(airquality,aes(Wind,Temp,col=factor(Month),group=1)) + stat_smooth(method="lm",se=F)
ggplot(airquality,aes(Wind,Temp,col=factor(Month),group=1)) + geom_point() +stat_smooth(method="lm",se=F)
ggplot(airquality,aes(Wind,Temp,col=factor(Month))) + geom_point() +stat_smooth(method="lm",se=F,aes(group=1))

ggplot(airquality,aes(Wind,Temp,col=factor(Month))) + geom_point() +stat_smooth(method="lm",se=F,aes(group=1))+stat_smooth(method="lm",se=F)

#ggplot(airquality,aes(Wind,Temp)) + geom_bar(stat = "identity")

##install.packages('RColorBrewer')
##好看調色板
library('RColorBrewer')
##5個月份所以5個顏色 然後在加上整體一個顏色
myColors <- c(brewer.pal(5,"Dark2"),"black")
display.brewer.pal(5,"Dark2")

ggplot(airquality,aes(Wind,Temp,col=factor(Month))) + 
  geom_point() +
  stat_smooth(method="lm",se=F,aes(group=1,col="All")) + 
  scale_color_manual("Month", values = myColors)

##畫不同面板
ggplot(airquality,aes(Wind,Temp,col=factor(Month))) + 
  geom_point() +
  stat_smooth(method="lm",se=F) + 
  scale_color_manual("Month", values = myColors) +
  facet_grid(.~Month) ##依照月份切
##改變主題
ggplot(airquality,aes(Wind,Temp,col=factor(Month))) + 
  geom_point() +
  stat_smooth(method="lm",se=F) + 
  scale_color_manual("Month", values = myColors) +
  facet_grid(.~Month)  + 
  theme_classic()
##?theme
ggplot(airquality,aes(Wind,Temp,col=factor(Month))) + 
  geom_point() +
  stat_smooth(method="lm",se=F) + 
  scale_color_manual("Month", values = myColors) +
  facet_grid(.~Month)  + 
  theme_classic()

##
pal <- colorRamp(c("red","blue"))
pal(0)#red
pal(1)#blue
pal(0.5) #為中間色碼?
pal(seq(0,1,len=10))

##16進位色碼
pal <- colorRampPalette(c("red","yellow"))
pal(1)
pal(2) #紅色 黃色
pal(10) #第一個為紅色 最後一個為黃色 中間為中間值
brewer.pal.info
##3個顏色
cols <- brewer.pal(3,"Greens")
pal <- colorRampPalette(cols)
##在三個端點中取值出20個
image(volcano,col=pal(20))
##查看顏色
display.brewer.pal(3,"Greens")
display.brewer.pal(12,"Set3")

##產生pdf檔 畫圖進去
pdf(file="miyfig.pdf")
with(airquality,plot(Wind,Temp,main="Wind and Temp in NYC"))
dev.off()
ggplot(airquality,aes(Wind,Temp,col=factor(Month))) + 
  geom_point() +
  stat_smooth(method="lm",se=F) + 
  scale_color_manual("Month", values = myColors) +
  facet_grid(.~Month)  + 
  theme_classic()
dev.copy(png,file="mycopy.png")
dev.off()
