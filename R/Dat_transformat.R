library(nycflights13)
library(tidyverse)
filter(flights, between(month, 7, 9))
filter(flights, month == 11 | month == 12)
nov_dec <- filter(flights, month %in% c(11, 12))
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)
filter(df, is.na(x) | x > 1)
# Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 60, dep_delay - arr_delay > 30)
# Departed between midnight and 6am (inclusive)
filter(flights, dep_time <= 600 | dep_time == 2400)
filter(flights, dep_time %% 2400 <= 600)
# How many flights have a missing dep_time? What other variables are missing? What might these rows represent?
filter(flights, is.na(dep_time))


# Missing values are always sorted at the end
arrange(flights, year, month, day)
arrange(flights, desc(dep_delay))
# How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
arrange(flights, dep_time) %>%
  tail()
arrange(flights, desc(is.na(dep_time)), dep_time)
# Sort flights to find the fastest flights.
head(arrange(flights, air_time))
head(arrange(flights, desc(distance / air_time)))
# Which flights traveled the longest? Which traveled the shortest?
arrange(flights, desc(distance))
arrange(flights, distance)


# Select all columns between year and day (inclusive)
select(flights, year:day)
# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))
select(flights, time_hour, air_time, everything())

rename(flights, tail_num = tailnum)

# Specify the names of the variables with character vector and any_of() or all_of()
select(flights, any_of(c("dep_time", "dep_delay", "arr_time", "arr_delay")))
variables <- c("dep_time", "dep_delay", "arr_time", "arr_delay")
select(flights, all_of(variables))
select(flights, starts_with("dep_"), starts_with("arr_"))
select(flights, matches("^(dep|arr)_(time|delay)$"))
variables <- c("dep_time", "dep_delay", "arr_time", "arr_delay")
select(flights, !!variables)
variables <- c("dep_time", "dep_delay", "arr_time", "arr_delay")
select(flights, !!!variables) # bang-bang-bang operator
select(flights, ends_with("arr_time"), ends_with("dep_time"))
select(flights, contains("_time"), contains("arr_"))
# The select() call ignores the duplication

# These functions differ in their strictness. The function all_of() will raise 
# an error if one of the variable names is not present, while any_of() will ignore it.

# The default behavior for contains() is to ignore case.
select(flights, contains("TIME", ignore.case = FALSE))


# If you only want to keep the new variables, use transmute()
transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)
# Modular arithmetic: %/% (integer division) and %% (remainder), where x == y * (x %/% y) + (x %% y). 


# Offsets: lead() and lag() allow you to refer to leading or lagging values. 
# This allows you to compute running differences (e.g. x - lag(x)) or find when 
# values change (x != lag(x)). They are most useful in conjunction with group_by()


# Cumulative and rolling aggregates: R provides functions for running sums, 
# products, mins and maxes: cumsum(), cumprod(), cummin(), cummax(); and dplyr 
# provides cummean() for cumulative means. If you need rolling aggregates 
# (i.e. a sum computed over a rolling window), try the RcppRoll package.
cumsum(x)

flights_times <- mutate(flights,
                        dep_time_mins = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
                        sched_dep_time_mins = (sched_dep_time %/% 100 * 60 +
                                                 sched_dep_time %% 100) %% 1440
)

time2mins <- function(x) {
  (x %/% 100 * 60 + x %% 100) %% 1440
}
flights_times <- mutate(flights,
                        dep_time_mins = time2mins(dep_time),
                        sched_dep_time_mins = time2mins(sched_dep_time)
)


# The function row_number() assigns each element a unique value. 
# The result is equivalent to the index (or row) number of each element after 
# sorting the vector, hence its name.
# The min_rank() and dense_rank() assign tied values the same rank, but differ 
# in how they assign values to the next rank. For each set of tied values the min_rank() 
# function assigns a rank equal to the number of values less than that tied value plus one.
# In contrast, the dense_rank() function assigns a rank equal to the number of 
# distinct values less than that tied value plus one. To see the difference 
# between dense_rank() and min_rank() compare the value of rankme$x_min_rank and 
# rankme$x_dense_rank for x = 10.


# When adding two vectors, R recycles the shorter vector's values to create a 
# vector of the same length as the longer vector. The code also raises a warning 
# that the shorter vector is not a multiple of the longer vector. A warning 
# is raised since when this occurs, it is often unintended and may be a bug.


?Trig

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
# Behind the scenes, x %>% f(y) turns into f(x, y), and x %>% f(y) %>% g(z) turns into g(f(x, y), z) 

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
)

not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))

not_cancelled %>% 
  count(tailnum, wt = distance)
daily %>% 
  ungroup() %>%             # no longer grouped by date
  summarise(flights = n())


# Come up with another approach that will give you the same output as 
# not_cancelled %>% count(dest)  
# (without using count()).
not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>%
  group_by(dest) %>%
  summarise(n = length(dest))
not_cancelled %>%
  group_by(dest) %>%
  summarise(n = n())
not_cancelled %>%
  group_by(tailnum) %>%
  tally()

# not_cancelled %>% count(tailnum, wt = distance)
not_cancelled %>%
  group_by(tailnum) %>%
  summarise(n = sum(distance))
not_cancelled %>%
  group_by(tailnum) %>%
  tally(distance)

# Which carrier has the worst delays? Challenge: can you disentangle the effects 
# of bad airports vs. bad carriers? Why/why not? (Hint: think about flights %>% 
# group_by(carrier, dest) %>% summarise(n()))
flights %>%
  filter(!is.na(arr_delay)) %>%
  # Total delay by carrier within each origin, dest
  group_by(origin, dest, carrier) %>%
  summarise(
    arr_delay = sum(arr_delay),
    flights = n()
  ) %>%
  # Total delay within each origin dest
  group_by(origin, dest) %>%
  mutate(
    arr_delay_total = sum(arr_delay),
    flights_total = sum(flights)
  ) %>%
  # average delay of each carrier - average delay of other carriers
  ungroup() %>%
  mutate(
    arr_delay_others = (arr_delay_total - arr_delay) /
      (flights_total - flights),
    arr_delay_mean = arr_delay / flights,
    arr_delay_diff = arr_delay_mean - arr_delay_others
  ) %>%
  # remove NaN values (when there is only one carrier)
  filter(is.finite(arr_delay_diff)) %>%
  # average over all airports it flies to
  group_by(carrier) %>%
  summarise(arr_delay_diff = mean(arr_delay_diff)) %>%
  arrange(desc(arr_delay_diff))

# The sort argument to count() sorts the results in order of n. You could 
# use this anytime you would run count() followed by arrange().


# Which plane (tailnum) has the worst on-time record?
flights %>%
  filter(!is.na(tailnum)) %>%
  mutate(on_time = !is.na(arr_time) & (arr_delay <= 0)) %>%
  group_by(tailnum) %>%
  summarise(on_time = mean(on_time), n = n()) %>%
  filter(min_rank(on_time) == 1)
quantile(count(flights, tailnum)$n)
flights %>%
  filter(!is.na(tailnum), is.na(arr_time) | !is.na(arr_delay)) %>%
  mutate(on_time = !is.na(arr_time) & (arr_delay <= 0)) %>%
  group_by(tailnum) %>%
  summarise(on_time = mean(on_time), n = n()) %>%
  filter(n >= 20) %>%
  filter(min_rank(on_time) == 1)
flights %>%
  filter(!is.na(arr_delay)) %>%
  group_by(tailnum) %>%
  summarise(arr_delay = mean(arr_delay), n = n()) %>%
  filter(n >= 20) %>%
  filter(min_rank(desc(arr_delay)) == 1)


# What time of day should you fly if you want to avoid delays as much as possible?
flights %>%
  group_by(hour) %>%
  summarise(arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(arr_delay)

# For each destination, compute the total minutes of delay. For each flight, 
# compute the proportion of the total delay for its destination.
flights %>%
  filter(arr_delay > 0) %>%
  group_by(dest) %>%
  mutate(
    arr_delay_total = sum(arr_delay),
    arr_delay_prop = arr_delay / arr_delay_total
  ) %>%
  select(dest, month, day, dep_time, carrier, flight,
         arr_delay, arr_delay_prop) %>%
  arrange(dest, desc(arr_delay_prop))


# Find all destinations that are flown by at least two carriers. Use that information to rank the carriers.
flights %>%
  # find all airports with > 1 carrier
  group_by(dest) %>%
  mutate(n_carriers = n_distinct(carrier)) %>%
  filter(n_carriers > 1) %>%
  # rank carriers by numer of destinations
  group_by(carrier) %>%
  summarize(n_dest = n_distinct(dest)) %>%
  arrange(desc(n_dest))
filter(airlines, carrier == "EV")
filter(airlines, carrier %in% c("AS", "F9", "HA"))

# For each plane, count the number of flights before the first delay of greater than 1 hour.
flights %>%
  # sort in increasing order
  select(tailnum, year, month,day, dep_delay) %>%
  filter(!is.na(dep_delay)) %>%
  arrange(tailnum, year, month, day) %>%
  group_by(tailnum) %>%
  # cumulative number of flights delayed over one hour
  mutate(cumulative_hr_delays = cumsum(dep_delay > 60)) %>%
  # count the number of flights == 0
  summarise(total_flights = sum(cumulative_hr_delays < 1)) %>%
  arrange(total_flights)




