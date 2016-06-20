
people <- read.csv(file.choose(),stringsAsFactors=F)

學歷 = unique(people[,2])
年度 = unique(people[,4])
題項 = unique(people[,5])

people$有未填寫的百分比 = ''
people$無未填寫的百分比 = ''

for(i in 1:length(題項)){
  for(x in 1:length(年度)){
    for(y in 1:length(學歷)){
      people$有未填寫的百分比[which(people[,5]==題項[i] & people[,4]==年度[x] & people[,2]==學歷[y])] = people[which(people[,5]==題項[i] & people[,4]==年度[x] & people[,2]==學歷[y]),3]/sum(people[which(people[,5]==題項[i] & people[,4]==年度[x] & people[,2]==學歷[y]),3])
      people$無未填寫的百分比[which(people[,5]==題項[i] & people[,4]==年度[x] & people[,2]==學歷[y] & people[,1]!='')] = people[which(people[,5]==題項[i] & people[,4]==年度[x] & people[,2]==學歷[y] & people[,1]!=''),3]/sum(people[which(people[,5]==題項[i] & people[,4]==年度[x] & people[,2]==學歷[y] & people[,1]!=''),3])
    }
  }
}
write.csv(people,'單選題百分比.csv',row.names=F)
