library(dplyr)
library(ggplot2)
library(maps)
library(mapproj)

fires <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/fires.csv")

# Mutating dataframe
fires <- fires %>%
  rename(year = FIRE_YEAR, date = DISCOVERY_DATE, state = STATE) %>%
  mutate(month = format(as.Date(date, format = "%Y-%m-%d"),"%m")) %>%
  mutate(state = state.name[match(state, state.abb)]) %>%
  mutate(state = tolower(state))

# Fires by year dataframe
year_df <- fires %>%
  group_by(year) %>%
  summarize(count = n())

#Bar chart of fires per year
year_plot <- ggplot(data = year_df) +
  geom_col(mapping = aes(x = year, y = count, fill = count)) +
  labs(title = "US Fires 1992-2015") +
  scale_fill_gradient(low = "#FFE188", high = "#D71A00") +
  labs(fill = "# of Fires")
  

# Fires by state dataframe
state_df <- fires %>%
  group_by(state) %>%
  summarize(count = n())

# Choropleth map of total fires across US
state_shape <- map_data("state") %>%
  rename(state = region) %>%
  left_join(state_df, by = "state")

total_map <- ggplot(state_shape) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = count),
    color = "black",
    linewidth = .1
  ) +
  coord_map() +
  scale_fill_continuous(low = "#FFE188", high = "#CE0C00") +
  labs(fill = "# of Fires") +
  theme(legend.key.size = unit(0.4, 'cm')) +
  labs(title = "Total US Fires from 1992-2015") +
  theme(plot.title = element_text(size = 12))
plot(total_map)

# Fires by state in 1998 dataframe
state_1998_df <- fires %>%
  filter(year == "1998") %>%
  group_by(state) %>%
  summarize(count = n())

# Map of fires across US in 1998

state_1998 <- map_data("state") %>%
  rename(state = region) %>%
  left_join(state_1998_df, by = "state")

map_1998 <- ggplot(state_1998) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = count),
    color = "black",
    size = .1
  ) +
  coord_map() +
  scale_fill_continuous(low = "#FFF4B0", high = "#CE0C00", limits = c(0, 6000)) +
  labs(fill = "# of Fires") +
  theme(legend.key.size = unit(0.4, 'cm')) +
  labs(title = "US Fires in 1998") +
  theme(plot.title = element_text(size = 12))



# Fires by state in 1998 dataframe
state_2015_df <- fires %>%
  filter(year == "2015") %>%
  group_by(state) %>%
  summarize(count = n())

# Map of fires across US in 2015
state_2015 <- map_data("state") %>%
  rename(state = region) %>%
  left_join(state_2015_df, by = "state")

map_2015 <- ggplot(state_2015) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = count),
    color = "black",
    size = .1
  ) +
  coord_map() +
  scale_fill_continuous(low = "#FFF4B0", high = "#CE0C00", limits = c(0, 6000)) +
  labs(fill = "# of Fires") +
  theme(legend.key.size = unit(0.4, 'cm')) +
  labs(title = "US Fires in 2015") +
  theme(plot.title = element_text(size = 12))
