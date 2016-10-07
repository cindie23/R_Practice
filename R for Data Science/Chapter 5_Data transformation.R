# Ch5 Data transformation
library(dplyr)
library(nycflights13)
library(ggplot2)

filter(flights, month == 1, day == 1)
jan1 <- filter(flights, month == 1, day == 1)
filter(flights, month == 1)

1/49 * 49 == 1
near(1 / 49 * 49, 1) 

filter(flights, month == 11 | month == 12)
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

df <- tibble(
  x = c(FALSE, TRUE, FALSE), 
  y = c(TRUE, FALSE, TRUE)
)
filter(df, cumany(x)) # all rows after first TRUE
filter(df, cumall(y)) # all rows until first FALSE

df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)

##
##
arrange(flights, year, month, day)
arrange(flights, desc(arr_delay))

df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

##
##
# Select columns by name
select(flights, year, month, day)
# Select all columns between year and day (inclusive)
select(flights, year:day)
# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))
#There are a number of helper functions you can use within select():
##  starts_with("abc"): matches names that begin with “abc”.
##  ends_with("xyz"): matches names that end with “xyz”.
##  contains("ijk"): matches names that contain “ijk”.
##  matches("(.)\\1"): selects variables that match a regular expression. This one matches any variables that contain repeated characters.
##  num_range("x", 1:3) matches x1, x2 and x3.

## change col name
rename(flights, Year = year)
##change col order. flights, time_hour, air_time and others
select(flights, time_hour, air_time, everything())
select(flights, contains("time"))

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)
##create new col
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60
)
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)
##only keep the new variables
transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)
##memo: %/% (integer division) and %% (remainder)
##
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)
##offset(偏移量)
c(2,4,6,8) %>% lag  #move to the rigth
c(2,4,6,8) %>% lead #left 
#Cumulative sum and mean : cumsum(), cummean()

##kable : good looking table
##min_rank(), dense_rank().... different rules of rank method.
y <- c(1, 2, 2, NA, 3, 4)
tibble(
  row_number(y),
  min_rank(y),
  dense_rank(y),
  percent_rank(y),
  cume_dist(y)
) %>% knitr::kable()

##
##
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))

##
##
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )
ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point()
##
##
batting <- tibble::as_tibble(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() + 
  geom_smooth(se = F)
#> `geom_smooth()` using method = 'gam'

##Measures of position: first(x), nth(x, 2), last(x). 
##These work similarly to x[1], x[2], and x[length(x)]
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first_dep = first(dep_time), 
    last_dep = last(dep_time)
  )
#to count the number of distinct (unique) values, 
#use n_distinct(x)
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))
##count
not_cancelled %>% 
  count(dest)
not_cancelled %>% 
  count(tailnum, wt = distance)
##summarise with condition
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

##Ungrouping
daily <- group_by(flights, year, month, day)
daily %>% 
  ungroup() %>%             # no longer grouped by date
  summarise(flights = n())  # all flights
