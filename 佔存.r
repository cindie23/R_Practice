####台藝大升學藍圖
rm(list = ls()) #去除工作空間中所有物件

library(plyr)

# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

path<-"D:\\abc\\wjhong\\projects\\教學卓越\\台藝大"
setwd(path)

##原始資料
school = read.csv('【臺藝大】升學藍圖撈取資料20160215.csv',stringsAsFactors=F)

##對應表
school_name = read.csv('台藝大系所名稱.csv',stringsAsFactors=F)

##去除前後空白
school$科系名稱_次高學歷 = trim(school$科系名稱_次高學歷)

##將學歷名稱正規化
for(i in 1:nrow(school_name)){
  school$科系名稱_次高學歷[which(school$科系名稱_次高學歷==school_name$trim後原始[i])] = school_name$對應表[i]
  #grepl(school_name$trim後原始[i],school$科系名稱_次高學歷)
}

##將為研究所之學系進行轉換
school$科系名稱_次高學歷[which(!grepl("研究所",school$科系名稱_次高學歷) & grepl("學系",school$科系名稱_次高學歷) & school$教育程度=='碩士')] = gsub('學系','學系研究所',school$科系名稱_次高學歷[which(!grepl("研究所",school$科系名稱_次高學歷) & grepl("學系",school$科系名稱_次高學歷) & school$教育程度=='碩士')])

school$科系名稱_除錯[which(grepl("學系學系",school$科系名稱_除錯))] = gsub('學系學系','學系',school$科系名稱_除錯[which(grepl("學系學系",school$科系名稱_除錯))])

##去除重複履歷資料
school_uni = school[,c('科系名稱_次高學歷','學校名稱_除錯_最高學歷',"會員編號")]
school_uni = unique(school_uni)

##正規化大學名稱
school_name_revise = read.csv('台藝大多重比對學校名稱轉換修改後.csv',stringsAsFactors=F)
for(i in 1:nrow(school_name_revise)){
  school$學校名稱_除錯_最高學歷[which(trim(school$學校名稱.手填._最高學歷)==school_name_revise$trim後原始[i])] = school_name_revise$對應表[i]
  #grepl(school_name_revise$trim後原始[i],school$科系名稱_次高學歷)
}

school_taiwan = school[which(school$就學地區_除錯_最高學歷=='國內(台灣)' & school$學校名稱_除錯_最高學歷!='' & school$科系類別名稱_最高學歷!=''),]
school_foreign = school[which(school$就學地區_除錯_最高學歷=='國外' & school$學校名稱_除錯_最高學歷!='' & school$科系類別名稱_最高學歷!=''),]

##樞紐分析:學系VS未來就學
#國內
new_school_taiwan = ddply(school_taiwan , c('科系名稱_次高學歷','學校名稱_除錯_最高學歷'), nrow)
new_school_taiwan = new_school_taiwan[order(new_school_taiwan$科系名稱_次高學歷,-new_school_taiwan$V1,new_school_taiwan$學校名稱_除錯_最高學歷),]
new_school_taiwan = new_school_taiwan[which(new_school_taiwan$學校名稱_除錯_最高學歷!=''),]
new_school_taiwan = new_school_taiwan[which(new_school_taiwan$科系名稱_次高學歷!=''),]
#國外
##樞紐分析:學系VS未來就學
new_school_foreign = ddply(school_foreign , c('科系名稱_次高學歷','學校名稱_除錯_最高學歷'), nrow)
new_school_foreign = new_school_foreign[order(new_school_foreign$科系名稱_次高學歷,-new_school_foreign$V1,new_school_foreign$學校名稱_除錯_最高學歷),]
new_school_foreign = new_school_foreign[which(new_school_foreign$學校名稱_除錯_最高學歷!=''),]
new_school_foreign = new_school_foreign[which(new_school_foreign$科系名稱_次高學歷!=''),]

##合併國內
temp = read.csv('台藝大過去學校.csv',stringsAsFactors=F)
temp1 = temp[which(temp$類別.0.科系..1.學校.==1),]
temp1 = temp1[,c('系所名稱','名稱','樣本數')]
colnames(temp1) = c("科系名稱_次高學歷", "學校名稱_除錯_最高學歷", "V1" )
new_school_taiwan = rbind(new_school_taiwan,temp1)
new_school_taiwan = new_school_taiwan[which(!grepl('研究所',new_school_taiwan$科系名稱_次高學歷)),]
new_school_taiwan = ddply(new_school_taiwan , c('科系名稱_次高學歷','學校名稱_除錯_最高學歷'), summarize, sum=sum(V1))
new_school_taiwan = new_school_taiwan[order(new_school_taiwan$科系名稱_次高學歷,-new_school_taiwan$sum,new_school_taiwan$學校名稱_除錯_最高學歷),]
new_school_taiwan = new_school_taiwan[which(new_school_taiwan[,2]!='' & new_school_taiwan[,2]!='臺北縣私立復興高級商工職業學校' & new_school_taiwan[,2]!='臺北市立景美女子高級中學'),]

##將其他轉移
##將其他不要列入top10，國外地區轉移
##純測試功能
for(i in 1:nrow(new_school_taiwan)){
  if(new_school_taiwan[i,2]=='國外地區大學'){
    temp = new_school_taiwan[i,3]
    while(temp>0){
      ##隨機挑row
      temp_sample_row = sample(which(new_school_taiwan[,1]==new_school_taiwan[i,1] & new_school_taiwan[,2]!='國外地區大學'),1)
      #temp_sample = sample(1:temp,1)
      new_school_taiwan[temp_sample_row,3] = new_school_taiwan[temp_sample_row,3] + 1
      temp = temp-1
      new_school_taiwan[i,3] = new_school_taiwan[i,3]-1
    }

  }
}
new_school_taiwan = new_school_taiwan[which(new_school_taiwan[,3]!=0),]

##排序
temp_order = new_school_taiwan[0,]
new_school_taiwan_list = unique(new_school_taiwan[,1])
for(i in 1:length(new_school_taiwan_list)){
  temp = new_school_taiwan[which(new_school_taiwan[,1]==new_school_taiwan_list[i]),]
  temp = temp[order(-temp$sum),]
  temp_order = rbind(temp_order,temp)
}
new_school_taiwan = temp_order

##將'其他'移到最後
temp = new_school_taiwan[which(new_school_taiwan[,2]=='其他'),]
new_school_taiwan = new_school_taiwan[which(new_school_taiwan[,2]!='其他'),]
new_school_taiwan = rbind(new_school_taiwan,temp)

##國外無須合併
new_school_foreign = new_school_foreign[which(!grepl('研究所',new_school_foreign$科系名稱_次高學歷)),]

##國內
school_taiwan_top_10_school = data.frame('系所名稱'=character(),'學校名稱'=character(),'次數'=numeric(),'百分比'=numeric(),stringsAsFactors=F)

new_school_taiwan_names = new_school_taiwan$科系名稱_次高學歷
new_school_taiwan_names = unique(new_school_taiwan_names)
new_school_taiwan_names = sort(new_school_taiwan_names)

##樞紐分析:學系VS未來學類
#國內
new_object_taiwan = ddply(school_taiwan , c('科系名稱_次高學歷','科系類別名稱_最高學歷'), nrow)
new_object_taiwan = new_object_taiwan[which(new_object_taiwan$科系類別名稱_最高學歷!=''),]
new_object_taiwan = new_object_taiwan[which(new_object_taiwan$科系名稱_次高學歷!=''),]

#國外
##樞紐分析:學系VS未來學類
new_object_foreign = ddply(school_foreign , c('科系名稱_次高學歷','科系類別名稱_最高學歷'), nrow)
new_object_foreign = new_object_foreign[order(new_object_foreign$科系名稱_次高學歷,-new_object_foreign$V1,new_object_foreign$科系類別名稱_最高學歷),]
new_object_foreign = new_object_foreign[which(new_object_foreign$科系類別名稱_最高學歷!=''),]
new_object_foreign = new_object_foreign[which(new_object_foreign$科系名稱_次高學歷!=''),]

##合併國內
temp = read.csv('台藝大過去學校.csv',stringsAsFactors=F)
temp1 = temp[which(temp$類別.0.科系..1.學校.==0),]
temp1 = temp1[,c('系所名稱','名稱','樣本數')]
colnames(temp1) = c("科系名稱_次高學歷", "科系類別名稱_最高學歷", "V1" )
new_object_taiwan = rbind(new_object_taiwan,temp1)
new_object_taiwan = new_object_taiwan[which(!grepl('研究所',new_object_taiwan$科系名稱_次高學歷)),]
new_object_taiwan = ddply(new_object_taiwan , c('科系名稱_次高學歷','科系類別名稱_最高學歷'), summarize, sum=sum(V1))
new_object_taiwan = new_object_taiwan[order(new_object_taiwan$科系名稱_次高學歷,-new_object_taiwan$sum,new_object_taiwan$科系類別名稱_最高學歷),]
new_object_taiwan = new_object_taiwan[which(new_object_taiwan[,2]!='' & new_object_taiwan[,2]!='臺北縣私立復興高級商工職業學校' & new_object_taiwan[,2]!='臺北市立景美女子高級中學'),]

##將'其他'移到最後
temp = new_object_taiwan[which(new_object_taiwan[,2]=='其他'),]
new_object_taiwan = new_object_taiwan[which(new_object_taiwan[,2]!='其他'),]
new_object_taiwan = rbind(new_object_taiwan,temp)

##


##學類與學校樣本平衡測試
if(TRUE){##unique(new_school_taiwan[,1]) == unique(new_object_taiwan[,1])
  temp_list = unique(new_school_taiwan[,1])
  for(i in 1:length(temp_list)){
    temp = sum(new_school_taiwan[which(new_school_taiwan[,1]==temp_list[i]),3],na.rm=T)
    temp2 = sum(new_object_taiwan[which(new_object_taiwan[,1]==temp_list[i]),3],na.rm=T)
    
    if(temp!=temp2){
      print(temp_list[i])
      if(temp>temp2){
        temp = temp-temp2
        while(temp>0){
          ##隨機挑row
          temp_sample_row = sample(which(new_object_taiwan[,1]==temp_list[i]),1)
          new_object_taiwan[temp_sample_row,3] = new_object_taiwan[temp_sample_row,3] + 1
          temp = temp-1
        }
        
      }else{
        temp = temp2-temp
        while(temp>0){
          ##隨機挑row
          temp_sample_row = sample(which(new_school_taiwan[,1]==temp_list[i]),1)
          new_school_taiwan[temp_sample_row,3] = new_school_taiwan[temp_sample_row,3] + 1
          temp = temp-1
        }
        #new_school_taiwan[which(new_school_taiwan[,1]==temp_list[i])[1],3] = new_school_taiwan[which(new_school_taiwan[,1]==temp_list[i])[1],3] + (temp2-temp)
      }
    }
  }
}

##學類與學校樣本平衡測試
if(TRUE){##unique(new_school_foreign[,1]) == unique(new_object_foreign[,1])
  temp_list = unique(new_school_foreign[,1])
  for(i in 1:length(temp_list)){
    temp = sum(new_school_foreign[which(new_school_foreign[,1]==temp_list[i]),3],na.rm=T)
    temp2 = sum(new_object_foreign[which(new_object_foreign[,1]==temp_list[i]),3],na.rm=T)
    
    if(temp!=temp2){
      print(temp_list[i])
      if(temp>temp2){
        temp = temp-temp2
        while(temp>0){
          ##隨機挑row
          temp_sample_row = sample(which(new_object_foreign[,1]==temp_list[i]),1)
          new_object_foreign[temp_sample_row,3] = new_object_foreign[temp_sample_row,3] + 1
          temp = temp-1
        }
        
      }else{
        temp = temp2-temp
        while(temp>0){
          ##隨機挑row
          temp_sample_row = sample(which(new_school_foreign[,1]==temp_list[i]),1)
          new_school_foreign[temp_sample_row,3] = new_school_foreign[temp_sample_row,3] + 1
          temp = temp-1
        }
        #new_school_foreign[which(new_school_foreign[,1]==temp_list[i])[1],3] = new_school_foreign[which(new_school_foreign[,1]==temp_list[i])[1],3] + (temp2-temp)
      }
    }
  }
}


write.csv(new_object_taiwan,'output\\國內升學類別藍圖學校次數.csv',row.names=F)
write.csv(new_object_foreign,'output\\國外升學類別藍圖學校次數.csv',row.names=F)
write.csv(new_school_taiwan,'output\\國內升學藍圖學校次數.csv',row.names=F)
write.csv(new_school_foreign,'output\\國外升學藍圖學校次數.csv',row.names=F)
##開始輸出總表
##國內學校輸出前10名
x=1
for(i in 1:length(new_school_taiwan_names)){
  for(j in 1:10){
    school_taiwan_top_10_school[x,1] = new_school_taiwan_names[i]
    school_taiwan_top_10_school[x,2] = new_school_taiwan$學校名稱_除錯_最高學歷[which(new_school_taiwan$科系名稱_次高學歷==new_school_taiwan_names[i])][j]
    school_taiwan_top_10_school[x,3] = new_school_taiwan$sum[which(new_school_taiwan$科系名稱_次高學歷==new_school_taiwan_names[i])][j]
    school_taiwan_top_10_school[x,4] = new_school_taiwan$sum[which(new_school_taiwan$科系名稱_次高學歷==new_school_taiwan_names[i])][j]/sum(new_school_taiwan$sum[which(new_school_taiwan$科系名稱_次高學歷==new_school_taiwan_names[i])],na.rm=T)
    
    x = x + 1 
  }
  school_taiwan_top_10_school[x,1] = new_school_taiwan_names[i]
  school_taiwan_top_10_school[x,2] = '其他'
  school_taiwan_top_10_school[x,3] = sum(new_school_taiwan$sum[which(new_school_taiwan$科系名稱_次高學歷==new_school_taiwan_names[i])],na.rm=T) - sum(school_taiwan_top_10_school$次數[which(school_taiwan_top_10_school$系所名稱 == new_school_taiwan_names[i])],na.rm=T)
  school_taiwan_top_10_school[x,4] = 1-sum(school_taiwan_top_10_school$百分比[which(school_taiwan_top_10_school$系所名稱 == new_school_taiwan_names[i])],na.rm=T)
  
  x = x + 1 
  
}

write.csv(school_taiwan_top_10_school,'output\\台藝大國內升學藍圖.csv',row.names=F)



###國外學校
school_foreign_top_10_school = data.frame('系所名稱'=character(),'學校名稱'=character(),'次數'=numeric(),'百分比'=numeric(),stringsAsFactors=F)

new_school_foreign_names = new_school_foreign$科系名稱_次高學歷
new_school_foreign_names = unique(new_school_foreign_names)
new_school_foreign_names = sort(new_school_foreign_names)

##輸出前10名
x=1
for(i in 1:length(new_school_foreign_names)){
  for(j in 1:10){
    school_foreign_top_10_school[x,1] = new_school_foreign_names[i]
    school_foreign_top_10_school[x,2] = new_school_foreign$學校名稱_除錯_最高學歷[which(new_school_foreign$科系名稱_次高學歷==new_school_foreign_names[i])][j]
    school_foreign_top_10_school[x,3] = new_school_foreign$V1[which(new_school_foreign$科系名稱_次高學歷==new_school_foreign_names[i])][j]
    school_foreign_top_10_school[x,4] = new_school_foreign$V1[which(new_school_foreign$科系名稱_次高學歷==new_school_foreign_names[i])][j]/sum(new_school_foreign$V1[which(new_school_foreign$科系名稱_次高學歷==new_school_foreign_names[i])],na.rm=T)
    
    x = x + 1 
  }
  school_foreign_top_10_school[x,1] = new_school_foreign_names[i]
  school_foreign_top_10_school[x,2] = '其他'
  school_foreign_top_10_school[x,3] = sum(new_school_foreign$V1[which(new_school_foreign$科系名稱_次高學歷==new_school_foreign_names[i])],na.rm=T) - sum(school_foreign_top_10_school$次數[which(school_foreign_top_10_school$系所名稱 == new_school_foreign_names[i])],na.rm=T)
  school_foreign_top_10_school[x,4] = 1-sum(school_foreign_top_10_school$百分比[which(school_foreign_top_10_school$系所名稱 == new_school_foreign_names[i])],na.rm=T)
  
  x = x + 1 
  
}

write.csv(school_foreign_top_10_school,'output\\台藝大國外升學藍圖.csv',row.names=F)

##國內學類
school_taiwan_top_10_object = data.frame('系所名稱'=character(),'學類名稱'=character(),'次數'=numeric(),'百分比'=numeric(),stringsAsFactors=F)

new_object_taiwan_names = new_object_taiwan$科系名稱_次高學歷
new_object_taiwan_names = unique(new_object_taiwan_names)
new_object_taiwan_names = sort(new_object_taiwan_names)

##輸出前10名
x=1
for(i in 1:length(new_object_taiwan_names)){
  for(j in 1:10){
    school_taiwan_top_10_object[x,1] = new_object_taiwan_names[i]
    school_taiwan_top_10_object[x,2] = new_object_taiwan$科系類別名稱_最高學歷[which(new_object_taiwan$科系名稱_次高學歷==new_object_taiwan_names[i])][j]
    school_taiwan_top_10_object[x,3] = new_object_taiwan$sum[which(new_object_taiwan$科系名稱_次高學歷==new_object_taiwan_names[i])][j]
    school_taiwan_top_10_object[x,4] = new_object_taiwan$sum[which(new_object_taiwan$科系名稱_次高學歷==new_object_taiwan_names[i])][j]/sum(new_object_taiwan$sum[which(new_object_taiwan$科系名稱_次高學歷==new_object_taiwan_names[i])],na.rm=T)
    
    x = x + 1 
  }
  school_taiwan_top_10_object[x,1] = new_object_taiwan_names[i]
  school_taiwan_top_10_object[x,2] = '其他'
  school_taiwan_top_10_object[x,3] = sum(new_object_taiwan$sum[which(new_object_taiwan$科系名稱_次高學歷==new_object_taiwan_names[i])],na.rm=T) - sum(school_taiwan_top_10_object$次數[which(school_taiwan_top_10_object$系所名稱 == new_object_taiwan_names[i])],na.rm=T)
  school_taiwan_top_10_object[x,4] = 1-sum(school_taiwan_top_10_object$百分比[which(school_taiwan_top_10_object$系所名稱 == new_object_taiwan_names[i])],na.rm=T)
  
  x = x + 1 
  
}

write.csv(school_taiwan_top_10_object,'output\\台藝大國內升學類別藍圖.csv',row.names=F)



###國外學類
school_foreign_top_10_object = data.frame('系所名稱'=character(),'學類名稱'=character(),'次數'=numeric(),'百分比'=numeric(),stringsAsFactors=F)

new_object_foreign_names = new_object_foreign$科系名稱_次高學歷
new_object_foreign_names = unique(new_object_foreign_names)
new_object_foreign_names = sort(new_object_foreign_names)

##輸出前10名
x=1
for(i in 1:length(new_object_foreign_names)){
  for(j in 1:10){
    school_foreign_top_10_object[x,1] = new_object_foreign_names[i]
    school_foreign_top_10_object[x,2] = new_object_foreign$科系類別名稱_最高學歷[which(new_object_foreign$科系名稱_次高學歷==new_object_foreign_names[i])][j]
    school_foreign_top_10_object[x,3] = new_object_foreign$V1[which(new_object_foreign$科系名稱_次高學歷==new_object_foreign_names[i])][j]
    school_foreign_top_10_object[x,4] = new_object_foreign$V1[which(new_object_foreign$科系名稱_次高學歷==new_object_foreign_names[i])][j]/sum(new_object_foreign$V1[which(new_object_foreign$科系名稱_次高學歷==new_object_foreign_names[i])],na.rm=T)
    
    x = x + 1 
  }
  school_foreign_top_10_object[x,1] = new_object_foreign_names[i]
  school_foreign_top_10_object[x,2] = '其他'
  school_foreign_top_10_object[x,3] = sum(new_object_foreign$V1[which(new_object_foreign$科系名稱_次高學歷==new_object_foreign_names[i])],na.rm=T) - sum(school_foreign_top_10_object$次數[which(school_foreign_top_10_object$系所名稱 == new_object_foreign_names[i])],na.rm=T)
  school_foreign_top_10_object[x,4] = 1-sum(school_foreign_top_10_object$百分比[which(school_foreign_top_10_object$系所名稱 == new_object_foreign_names[i])],na.rm=T)
  
  x = x + 1 
  
}

write.csv(school_foreign_top_10_object,'output\\台藝大國外升學類別藍圖.csv',row.names=F)

##產生總表 
temp = read.csv('台藝大過去學校.csv',stringsAsFactors=F)
all_in_one = temp[0,]

colnames(school_taiwan_top_10_object) = c('系所名稱','名稱','樣本數','百分比')
school_taiwan_top_10_object$教育部系所代碼 = ''
school_taiwan_top_10_object$等級 = 'B'
school_taiwan_top_10_object$類別.0.科系..1.學校. = 0
school_taiwan_top_10_object$排名 = c(1:11)
all_in_one = rbind(all_in_one,school_taiwan_top_10_object)
all_in_one$國內外 = '國內'

colnames(school_foreign_top_10_object) = c('系所名稱','名稱','樣本數','百分比')
school_foreign_top_10_object$教育部系所代碼 = ''
school_foreign_top_10_object$等級 = 'B'
school_foreign_top_10_object$類別.0.科系..1.學校. = 0
school_foreign_top_10_object$排名 = c(1:11)
school_foreign_top_10_object$國內外 = '國外'
all_in_one = rbind(all_in_one,school_foreign_top_10_object)

colnames(school_foreign_top_10_school) = c('系所名稱','名稱','樣本數','百分比')
school_foreign_top_10_school$教育部系所代碼 = ''
school_foreign_top_10_school$等級 = 'B'
school_foreign_top_10_school$類別.0.科系..1.學校. = 0
school_foreign_top_10_school$排名 = c(1:11)
school_foreign_top_10_school$國內外 = '國外'
all_in_one = rbind(all_in_one,school_foreign_top_10_school)

colnames(school_taiwan_top_10_school) = c('系所名稱','名稱','樣本數','百分比')
school_taiwan_top_10_school$教育部系所代碼 = ''
school_taiwan_top_10_school$等級 = 'B'
school_taiwan_top_10_school$類別.0.科系..1.學校. = 0
school_taiwan_top_10_school$排名 = c(1:11)
school_taiwan_top_10_school$國內外 = '國內'
all_in_one = rbind(all_in_one,school_taiwan_top_10_school)

all_in_one = all_in_one[,c('教育部系所代碼','系所名稱','等級','類別.0.科系..1.學校.','國內外','排名','名稱','樣本數','百分比')]

##補教育部代碼
temp = unique(temp[,1:2])
for(i in 1:nrow(temp)){
  all_in_one$教育部系所代碼[which(all_in_one$系所名稱==temp[i,2])] = temp[i,1]
}
all_in_one = all_in_one[which(all_in_one$教育部系所代碼!=''),]

write.csv(all_in_one,'20150224_台藝大升學藍圖.csv',row.names=F)
