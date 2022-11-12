library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

# earth_land_temp.csv Summary Values
file = "https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/earth-land-temps.csv"

earth_land_temp_df <- read_csv(url(file))
# 1 - average temperature changes per country per month for all years given
temp_change_country <- earth_land_temp_df %>% 
  filter(Element == "Temperature change", na.rm = TRUE) %>% 
  group_by(`Area Code`, Area, `Months Code`, Months) %>% 
  select(starts_with('Y')) %>% 
  mutate(avg_change = rowMeans(across(starts_with('Y')), na.rm = TRUE))

# 2a - average temperature change for all countries by month
monthly_avg_change <- temp_change_country %>% 
  group_by(`Months Code`, Months) %>% 
  select(avg_change) %>% 
  summarise(avg_change_total = mean(avg_change))

# 2b - month of the highest temp change (VALUE 1: highest_month_val)
highest_val <- max(monthly_avg_change$avg_change_total)

highest_month <- monthly_avg_change %>% 
  filter_all(any_vars(. %in% c(highest_val))) %>% 
  pull(Months)

highest_month_val <- paste0(highest_month, ": ", highest_val)

# 2c - month of the lowest temp change (VALUE 2: lowest_month_val)
lowest_val <- min(monthly_avg_change$avg_change_total)

lowest_month <- monthly_avg_change %>% 
  filter_all(any_vars(. %in% c(lowest_val))) %>% 
  pull(Months)

lowest_month_val <- paste0(lowest_month, ": ", lowest_val)

# 3a - displays avg change for all months in countries of Oceania
oceania_temp_change <- temp_change_country %>% 
  group_by(Area) %>% 
  select(avg_change) %>% 
  summarise(avg_change = mean(avg_change, na.rm = TRUE)) %>% 
  filter(Area %in% c("Australia", "Papua New Guinea", "New Zealand",
                     "Fiji", "Solomon Islands", "Micronesia", "Vanuatu",
                     "Samoa", "Kiribati", "Tonga", "Marshall Islands",
                     "Palau", "Tuvalu", "Nauru"))

# 3b - avg change in temp across all countries in Oceania (VALUE 3: avg_oceania_temp_change)
avg_oceania_temp_change <- oceania_temp_change %>% 
  summarise(avg = mean(avg_change), na.rm = TRUE) %>% 
  pull(avg)



# exoplanets.csv Summary Values
file = "https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/exoplanets.csv"

exoplanets <- read_csv(url(file))
# 1 - 




# fires.csv Summary Values
file = "https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/fires.csv"

fires <- read_csv(url(file))