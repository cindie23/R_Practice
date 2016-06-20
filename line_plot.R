
month_fake = data.frame('Time'=character(),'Percentage'=numeric(),stringsAsFactors=F)

month_fake[1:12,1] = c('2015/07','2015/08','2015/09','2015/10','2015/11','2015/12','2016/01','2016/02','2016/03','2016/04','2016/05','2016/06')
month_fake[1:12,2] = c(10.11,8.54,7.68,4.56,8.55,8.99,8.94,9.45,10.11,11.22,10.45,10.92)

month_fake$Time <- factor(month_fake$Time)  #??????量Time???置成???因子???量
ggplot(month_fake, aes(x = Time, y = Percentage, group = 1)) + geom_line()  #Time???因子???量???，x??????有x=6，同???需要加group=1，
ggplot(month_fake, aes(x=Time, y=Percentage,group=1)) + geom_line(size=1, colour="blue")
