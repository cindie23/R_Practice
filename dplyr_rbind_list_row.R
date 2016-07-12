library(dplyr)
one <- mtcars[1:10, ]
two <- mtcars[11:32, ]

rbind(one,two)
dim(rbind(one,two)) ##有row names
rbind_list(one, two)
dim(rbind_list(one, two))
bind_rows(one, two)
rbind_all(list(one, two))
bind_rows(list(one, two))
