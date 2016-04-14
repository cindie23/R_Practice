library(ggplot2)
##
##散點圖
##
##color為漸進色
qplot(Wind,Temp,data=airquality,color=Month)
##factor後則為四種不同顏色
airquality$Month = factor(airquality$Month)
qplot(Wind,Temp,data=airquality,color=Month)
#改為red
qplot(Wind,Temp,data=airquality,color=I("red"))
##不同形狀
qplot(Wind,Temp,data=airquality,shape=Month)
#不同大小
qplot(Wind,Temp,data=airquality,size=Month)
#size 標頭 軸名
qplot(Wind,Temp,data=airquality,size=I(10),xlab="Wind (mph)",ylab="Temp",main="Wind V.S. Temp")
#geom 幾何 smooth為依照點給回歸線的感覺 陰影為自信區間
qplot(Wind,Temp,data=airquality,geom = c("point","smooth"))
##每個月分不同點不同回歸線
qplot(Wind,Temp,data=airquality,color=Month,geom = c("point","smooth"))
##分月份散布圖 1列5行
qplot(Wind,Temp,data=airquality,facets = .~Month)
##分月份散布圖 5列1行
qplot(Wind,Temp,data=airquality,facets = Month~.)

##
##柱狀圖
##
qplot(Wind,data=airquality)
qplot(Wind,data=airquality,facets = Month~.)
##散點圖
##x為依照觀測前後順序排列
qplot(y=Wind,data=airquality)
##累積柱狀圖
qplot(Wind,data=airquality,fill=Month)
##輪廓線 ( 密度函數?)
qplot(Wind,data=airquality,geom = "density")
##分月分顏色輪廓線
qplot(Wind,data=airquality,geom = "density",color=Month)
##改為點顯示
qplot(Wind,data=airquality,geom = "dotplot")




