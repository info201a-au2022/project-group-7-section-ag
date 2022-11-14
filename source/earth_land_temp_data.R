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


# 9 - histogram of change_per_country 
oceania_bar_graph <- ggplot(oceania_temp_change, aes(x=Area, y=avg_change)) +
  geom_bar(stat="identity", color="black", fill="darkolivegreen4") +
  ggtitle("Oceania Temperature Change")
oceania_bar_graph

# 2 - average temperature change for each country for all months
yearly_avg_change <- temp_change_country %>% 
  group_by(`Area Code`, Area) %>% 
  select(avg_change) %>% 
  summarise(avg_change_total = mean(avg_change))

yearly_avg_plot <- plot(yearly_avg_change$avg_change_total)

# 3 - average temperature change for all countries per month
monthly_avg_change <- temp_change_country %>% 
  group_by(`Months Code`, Months) %>% 
  select(avg_change) %>% 
  summarise(avg_change_total = mean(avg_change))

# month of the highest temp change
highest_val <- max(monthly_avg_change$avg_change_total)

highest_month <- monthly_avg_change %>% 
  filter_all(any_vars(. %in% c(highest_val))) %>% 
  pull(Months)

# month of the lowest temp change
lowest_val <- min(monthly_avg_change$avg_change_total)

lowest_month <- monthly_avg_change %>% 
  filter_all(any_vars(. %in% c(lowest_val))) %>% 
  pull(Months)

monthly_avg_plot <- plot(monthly_avg_change$avg_change_total)

# 4 - not working...try to find changes for each country selected
temp_change_monthly <- temp_change_country %>% 
  filter(Area == "Afghanistan", na.rm = TRUE) %>% 
  group_by(`Months Code`, Months) %>% 
  select(avg_change) %>% 
  mutate(change_in_temp = avg_change - lag(avg_change, n = 1))
?lag()

# 5 - group by region and plot onto map with ggplot?
americas_temp_change <- earth_land_temp_df
  
asia_temp_change <- earth_land_temp_df 

# 6 - average change in temperature per year selected
temp_change_yearly <- mean(temp_change_country$Y1962, na.rm = TRUE)

# 7 - average change in temp of selected country in selected year
change_yearly_country <- temp_change_country %>% 
  filter(Area == "Afghanistan", na.rm = TRUE) %>% 
  summarise(avg = mean(Y1961, na.rm = TRUE))


  