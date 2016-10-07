## R for Data Science
# Chapter 3 : Data visualization
library(ggplot2)

str(mpg)
ggplot(data = mpg) + geom_point(mapping = aes(x = hwy, y = cyl))
## points with color.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = class))
## points with corresponding size.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = class))
## points with different transparency.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
## points with different shape.
## ggplot2 only use 6 types of shape at a time, so when the class more than 6 groups, it will end up with incompleted output.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, shape = class))
## points with blue.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
## This is a wrong example.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

## plot plots with different class(facets).
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
## facet plot on the combination of two variables
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

##
ggplot(data = mpg) + geom_point(mapping = aes(x = drv, y = cyl))
unique(mpg$drv)
## By row.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
## By col.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
## nrow can change the apearance
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 3)

## scatterplot
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))
## smooth line chart
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy))
## line types based on drv
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
## Both scatter and smooth line chart
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv)) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))

##
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
## Disable legend by using "show.legend"
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, colour = drv),
    show.legend = FALSE
  )
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, colour = drv),
    show.legend = TRUE
  )

##
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
## Setting variable first.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth
## Add new mapping
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()
## smooth line using filtered data 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = dplyr::filter(mpg, class == "subcompact"), se = FALSE)
## if se==TRUE, it will plot the shade of the data
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

##bar chart
str(diamonds)
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))
## without declaring "group=1" will be the wrong percentage
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = ..prop.. , group = 1))

## Bar border or itself with color
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, colour = cut))
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = cut))
## Stacked bar chart
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = clarity))

## Different position
## alpha : transparency
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")
## fill = NA : only have border
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")
## position="fill" : each group will have same height
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")
## Stacked bat chart to many bar charts beside one another.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")
## Solve overlap problem
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
ggplot(data = mpg) + 
  geom_jitter(mapping = aes(x = displ, y = hwy))

## use "coord_flip()" to swich x and y axes
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + geom_boxplot()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + geom_boxplot() +
  coord_flip()

## use "coord_polar()" to draw coxcomb chart.
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

###
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()