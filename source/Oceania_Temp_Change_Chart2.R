library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

file = "https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/earth-land-temps.csv"

earth_land_temp_df <- read_csv(url(file))

# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf

# 1 - average temperature changes for each country for each month
temp_change_country <- earth_land_temp_df %>% 
  filter(Element == "Temperature change", na.rm = TRUE) %>% 
  group_by(`Area Code`, Area, `Months Code`, Months) %>% 
  select(starts_with('Y')) %>% 
  mutate(avg_change = rowMeans(across(starts_with('Y')), na.rm = TRUE))

temp_country_plot <- plot(temp_change_country$avg_change)

# 2 - groups countries by continent and displays avg change per country for all months
oceania_temp_change <- temp_change_country %>% 
  group_by(Area) %>% 
  select(avg_change) %>% 
  summarise(avg_change = mean(avg_change, na.rm = TRUE)) %>% 
  filter(Area %in% c("Australia", "Papua New Guinea", "New Zealand",
                     "Fiji", "Solomon Islands", "Micronesia", "Vanuatu",
                     "Samoa", "Kiribati", "Tonga", "Marshall Islands",
                     "Palau", "Tuvalu", "Nauru"))

# 3 - avg change in temp across all countries in Oceania
avg_oceania_temp_change <- oceania_temp_change %>% 
  summarise(avg = mean(avg_change), na.rm = TRUE) %>% 
  pull(avg)
print(avg_oceania_temp_change)

# 4 - histogram of change_per_country 
oceania_bar_graph <- ggplot(oceania_temp_change, aes(x=Area, y=avg_change)) +
  geom_bar(stat="identity", color="black", fill="darkolivegreen4") +
  ggtitle("Oceania Temperature Change")
oceania_bar_graph