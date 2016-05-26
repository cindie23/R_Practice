#https://blog.gtwang.org/r/r-strings-and-factors/4/

colors <- c("red", "yellow", "green", "red", "green")
colors.factor <- factor(colors)
colors.factor
levels(colors.factor)
nlevels(colors.factor)

#改順序
colors.factor2 <- factor(colors, levels = c("red", "yellow", "green"))
colors.factor2

#改名稱
colors.factor3 <- factor(colors,
                         levels = c("red", "yellow", "green"),
                         labels = c("R", "Y", "G"))
colors.factor3

colors.levels <- levels(colors.factor)
levels(colors.factor) <- c(colors.levels, "blue")
colors.factor[1] <- "blue"
colors.factor

##一邊設定level的順序
levels(colors.factor) <- list(
  blue = "blue", green = "green",
  red = "red", yellow = "yellow")
colors.factor[1] <- "blue"
colors.factor

#重新排序因子變數的 levels，將指定的 level 放在第一個位置
relevel(colors.factor, "red")

colors.raw <- c("Red", "yellow", "green", "red", "green")
colors.factor <- factor(colors.raw)
colors.factor

colors.factor[1] <- "red"
unique(colors.factor)

##移除level
colors.factor <- droplevels(colors.factor)
colors.factor

##
##
##

choices <- c("worst", "bad", "so-so", "good", "perfect")
samples <- sample(choices, 10, replace = TRUE)
samples.factor <- factor(samples, levels = choices)
samples.factor

samples.ordered <- ordered(samples, levels = choices)
samples.ordered



##
##
##

raw <- data.frame(
  x = c("1.23", "4..56", "7.89")
)
as.numeric(raw$x) ##level的?
as.numeric(as.character(raw$x))
as.numeric(levels(raw$x))[as.integer(raw$x)]

##
##
##
##gl函數依據指定樣式來產生因子變數，第一個參數 n 是指定因子的 level 數目，第二個參數 k 指定每個 level 出現的次數
gl(n = 2, k = 8)
gl(n = 2, k = 8, labels = c("Control", "Treat"))
gl(n = 2, k = 2, length = 8,
   labels = c("Control", "Treat"))

a <- gl(2, 4, 8)
a
b <- gl(2, 2, 8, labels = c("ctrl", "treat"))
b
interaction(a, b)

s <- gl(2, 1, 8, labels = c("M", "F"))
s

interaction(a, b, s, sep = ":")
