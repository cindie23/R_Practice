##去除顯示時的引號
noquote(c('123','abc'))

x <- exp(1:3)
x
formatC(x, digits = 5)
formatC(0, 5)
format(0, 5)
formatC(x, digits = 5, format = "e")
formatC(x, digits = 5, width = 8)

format(x, digits = 5)
format(x, digits = 5, trim = TRUE)
format(x, digits = 3, scientific = TRUE)

format(0, nsmall = 2)

prettyNum(2^30, big.mark = ",")
prettyNum(1/2^20, small.mark = " ", scientific = FALSE)


items <- c("the apple", "the banana")
weights <- c(3.2, 2.5)
sprintf("The weight of %s is %f kg.", items, weights)

sprintf("The weight of %s is %.1f kg.", items, weights)

cat("foo\tbar")
cat("foo\nbar")
cat("foo\\bar")
cat("foo\"bar")
cat('foo\'bar')
cat('foo"bar')
cat("foo'bar")
cat("\a")  ##alarm()

x.strings <- c(
  "abcdefghij",
  "ABCDEFGHIJ",
  "1234567890"
)
##依序開頭不一樣
substr(x.strings, 1:4, 8)
substring(x.strings, 1:4, 8)


strsplit("foo+bar+Foo+BAR", "+")
strsplit("foo+bar+Foo+BAR", "+", fixed = TRUE) ##strsplit 函數預設會使用正規表示法（regular expression）來匹配分隔字串，如果要將指定的分隔字串視為一般的文字，可以加上 fixed = TRUE 參數。

strsplit("foo,bar.Foo BAR", "[,. ]")

