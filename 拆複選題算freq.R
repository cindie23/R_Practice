people = read.csv(file.choose(),stringsAsFactors=F)

save = people

people$Q5=strsplit(people$Q5,', ')

temp = people$Q5[which(people$Q3==1)]
temp = unlist(temp)
울1ず=as.data.frame(table(temp ))

temp = people$Q5[which(people$Q3==2)]
temp = unlist(temp)
울2ず=as.data.frame(table(temp ))

getwd()
write.csv(울1ず,'울1ず.csv',row.names=F)
write.csv(울2ず,'울2ず.csv',row.names=F)
