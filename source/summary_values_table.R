source("../source/Oceania_Temp_Change_Chart2.R")
source("../source/exoplanet-chart-code.R")
source("../source/fires_charts.R")

# Table 1: average temp change (rounded to two decimal points)
# of each country in dataframe (sorted in alphabetical order)
# across all months and years recorded
earth_temp_summary_table <- temp_change_country %>% 
  group_by(Area) %>% 
  select(avg_change) %>% 
  summarise(avg_change_total = round(mean(avg_change), digits = 2)) %>% 
  filter(avg_change_total >= 1)
  
# Table 2: average orbital period days (rounded to two decimal points)
# of each type of discovery method of each exoplnaet ranging from 200 to
# 700 orbital period days
exoplanets_summary_table <- exoplanets %>% 
  group_by(discovery_method) %>% 
  select(orbital_period_days) %>% 
  filter(orbital_period_days >= 200 & orbital_period_days <= 700) %>% 
  summarise(avg_orbital_period = round(mean(orbital_period_days), digits = 2))
  
# Table 3: average fire size (in acres, rounded two decimal points) for
# each year observed in the dataframe
fires_summary_table <- fires %>% 
  group_by(year) %>% 
  select(FIRE_SIZE) %>% 
  summarise(avg_fire_size = round(mean(FIRE_SIZE), digits = 2))