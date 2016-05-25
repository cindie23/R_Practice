#https://blog.gtwang.org/r/r-flow-control-and-loops/3/

ifelse(c(TRUE, FALSE, TRUE), "Good", "Bad")

x <- c(3:-2)
sqrt(ifelse(x >= 0, x, NA))


x <- "mean"
y <- 1:10
if ( x == "mean" ) {
  mean(y)
} else if ( x == "sd" ) {
  sd(y)
} else if ( x == "median" ) {
  median(y)
} else if ( x == "sum" ) {
  sum(y)
}

switch(x,
       mean = mean(y),
       sd = sd(y),
       median = median(y),
       sum = sum(y))

z <- "nothing"
switch(z,
       mean = mean(y),
       sd = sd(y),
       median = median(y),
       sum = sum(y),
       99)

z <- "custom"
switch(z,
       mean = mean(y),
       sd = sd(y),
       median = median(y),
       sum = sum(y),
       custom = {
         y2 <- y * 1.2 + pi / 2
         prod(sin(y2))
       })

switch(
  3,
  "first",
  "second",
  "third",
  "fourth"
)

switch(
  as.character(328),
  "328" = "the anser 328",
  "default anser"
)


x <- 0
repeat {
  message("x = ", x)
  x <- x + 1
  if (x == 5) break
}

x <- 0
repeat {
  x <- x + 1
  if (x %% 2 == 0) next
  message("x = ", x)
  if (x > 7) break
}

x <- 0
while (x != 5) {
  message("x = ", x)
  x <- x + 1
}

x <- 0
while ( x < 100 ) {
  x <- x + 1
  if (x %% 2 == 0) next
  message("x = ", x)
  if (x > 7) break
}

colors <- c("red", "blue", "yellow")
for (c in colors) {
  message("The color is ", c)
}
