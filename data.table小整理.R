library(data.table)

#melt

messy <- data.frame(
  name = c("Wilbur", "Petunia", "Gregory"),
  a = c(67, 80, 64),
  b = c(56, 90, 50)
)

melt(messy) ##跟gather類似?
messy %>>% melt()

m2 <- messy %>% mutate(test=runif(3,1,3) %>% round(0))
melt(m2, id.vars = "name", measure.vars = c("a", "b"))
m2 %>>% data.table %>>% melt(c("name", "test"))##保留name跟test 其他轉

