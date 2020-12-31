library(tidyverse)

# A variable is a quantity, quality, or property that you can measure.

# A value is the state of a variable when you measure it. The value of a variable 
# may change from measurement to measurement.

# An observation is a set of measurements made under similar conditions 
# (you usually make all of the measurements in an observation at the same time 
# and on the same object). An observation will contain several values, each 
# associated with a different variable. I'll sometimes refer to an observation as a data point.

# Tabular data is a set of values, each associated with a variable and an 
# observation. Tabular data is tidy if each value is placed in its own "cell", 
# each variable in its own column, and each observation in its own row.

# Variation is the tendency of the values of a variable to change from 
# measurement to measurement.

# A variable is categorical if it can only take one of a small set of values. 
# In R, categorical variables are usually saved as factors or character vectors. 
# To examine the distribution of a categorical variable, use a bar chart
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
diamonds %>% 
  count(cut)

# A variable is continuous if it can take any of an infinite set of ordered values.
# Numbers and date-times are two examples of continuous variables. 
# To examine the distribution of a continuous variable, use a histogram.
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
diamonds %>% 
  count(cut_width(carat, 0.5))
# Explore bin width and also try geom_freqpoly()
smaller <- diamonds %>% 
  filter(carat < 3)
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)


# Which values are the most common? Why?
# Which values are rare? Why? Does that match your expectations?
# Can you see any unusual patterns? What might explain them?
# Clusters of similar values suggest that subgroups exist in your data. To understand the subgroups, ask:
# How are the observations within each cluster similar to each other?
# How are the observations in separate clusters different from each other?
# How can you explain or describe the clusters?
# Why might the appearance of clusters be misleading?

# Check for outliers
unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)

# Explore the distribution of each of the x, y, and z variables in diamonds. 
# What do you learn? Think about a diamond and how you might decide which dimension is the length, width, and depth.

# Explore the distribution of price. Do you discover anything unusual or surprising? 
# (Hint: Carefully think about the binwidth and make sure you try a wide range of values.)

# How many diamonds are 0.99 carat? How many are 1 carat? What do you think is the cause of the difference?
  
# Compare and contrast coord_cartesian() vs xlim() or ylim() when zooming in on a histogram. 
# What happens if you leave binwidth unset? What happens if you try and zoom so only half a bar shows?