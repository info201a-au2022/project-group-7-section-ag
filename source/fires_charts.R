library(dplyr)
library(ggplot2)

fires <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/fires.csv")

# Fires by month dataframe
month_df <- fires %>%
  group_by(month) %>%
  summarize(count = n())

# Bar chart of fires per month
month_plot <- ggplot(data = month_df) +
  geom_col(mapping = aes(x = month, y = count, fill = month)) +
  scale_fill_grey()

# Fires by year dataframe
year_df <- fires %>%
  group_by(year) %>%
  summarize(count = n())

#Bar chart of fires per year
year_plot <- ggplot(data = year_df) +
  geom_col(mapping = aes(x = year, y = count))

# Fires by state dataframe
state_df <- fires %>%
  group_by(state) %>%
  summarize(count = n())

# CLoropleth map of total fires across US
state_shape <- map_data("state")

ggplot(state_shape) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group),
    color = "black",
    size = .1        
  ) +
  coord_map()  

state_shape <- map_data("state") %>%
  rename(state = region) %>%
  left_join(state_df, by = "state")

ggplot(state_shape) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = count),
    color = "black",
    size = .1
  ) +
  coord_map() +
  scale_fill_continuous(low = "#FFF4B0", high = "#CE0C00") +
  labs(fill = "Fire Count")


# Fires by state in 1998 dataframe
state_1998_df <- fires %>%
  filter(year == "1998") %>%
  group_by(state) %>%
  summarize(count = n())

# Map of fires across US in 1998

state_1998 <- map_data("state")

ggplot(state_1998) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group),
    color = "black",
    size = .1        
  ) +
  coord_map()  

state_1998 <- map_data("state") %>%
  rename(state = region) %>%
  left_join(state_1998_df, by = "state")

ggplot(state_1998) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = count),
    color = "black",
    size = .1
  ) +
  coord_map() +
  scale_fill_continuous(low = "#FFF4B0", high = "#CE0C00", limits = c(0, 6000)) +
  labs(fill = "Fire Count")


# Fires by state in 1998 dataframe
state_2015_df <- fires %>%
  filter(year == "2015") %>%
  group_by(state) %>%
  summarize(count = n())

# Map of fires across US in 2015
state_2015 <- map_data("state")

ggplot(state_2015) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group),
    color = "black",
    size = .1        
  ) +
  coord_map()  

state_2015 <- map_data("state") %>%
  rename(state = region) %>%
  left_join(state_2015_df, by = "state")

ggplot(state_2015) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = count),
    color = "black",
    size = .1
  ) +
  coord_map() +
  scale_fill_continuous(low = "#FFF4B0", high = "#CE0C00", limits = c(0, 6000)) +
  labs(fill = "Fire Count")

