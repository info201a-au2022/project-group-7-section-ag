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
exoplanets <- read_csv('../data/exoplanets.csv')

# select columns that we might care about
exoplanets <- exoplanets %>% select(pl_name, hostname, sy_snum, sy_pnum, 
                                    discoverymethod, disc_year, pl_orbper, 
                                    pl_orbsmax, pl_rade, pl_radj, pl_bmasse, 
                                    pl_bmassj, pl_orbeccen, pl_eqt, st_spectype,
                                    st_teff, st_rad, st_mass, st_logg,
)

# rename columns to more understandable names
colnames(exoplanets) <- c("planet_name", "host_name", "num_stars", "num_planets",
                          "discovery_method", "discovery_year", "orbital_period_days",
                          "orbital_semi_maj_axis_au", "planet_rad_e", "planet_rad_j",
                          "planet_mass_e", "planet_mass_j", "eccentricity", "planet_equi_temp_k",
                          "spectral_type", "stellar_eff_temp_k", "stellar_rad_sol", "stellar_mass_sol",
                          "stellar_surf_grav"
)
# 1 - 
# make dataset smaller so that there is one row per planet, should have 5044 rows
planet_summary <- exoplanets %>% 
  group_by(planet_name) %>% 
  summarize(num_stars = mean(num_stars, na.rm=T), 
            num_planets = mean(num_planets, na.rm=T),
            discovery_method = unique(num_planets),
            discovery_year = unique(discovery_year),
            orbital_period_days = mean(orbital_period_days, na.rm=T),
            orbital_semi_maj_axis_au = mean(orbital_semi_maj_axis_au, na.rm=T),
            planet_rad_e = mean(planet_rad_e, na.rm=T),
            planet_rad_j = mean(planet_rad_j, na.rm=T),
            planet_mass_e = mean(planet_mass_e, na.rm=T),
            planet_mass_j = mean(planet_mass_j, na.rm=T),
            eccentricity = mean(eccentricity, na.rm=T),
            planet_equi_temp_k = mean(planet_equi_temp_k, na.rm=T),
            spectral_type = mean(spectral_type, na.rm=T),
            stellar_eff_temp_k = mean(stellar_eff_temp_k, na.rm=T),
            stellar_rad_sol = mean(stellar_rad_sol, na.rm=T),
            stellar_mass_sol = mean(stellar_mass_sol, na.rm=T),
            stellar_surf_grav = mean(stellar_surf_grav, na.rm=T)
  )

# replace NaN with NA
planet_summary$orbital_period_days[is.nan(planet_summary$orbital_period_days)] <- NA
planet_summary$orbital_semi_maj_axis_au[is.nan(planet_summary$orbital_semi_maj_axis_au)] <- NA
planet_summary$planet_rad_e[is.nan(planet_summary$planet_rad_e)] <- NA
planet_summary$planet_rad_j[is.nan(planet_summary$planet_rad_j)] <- NA
planet_summary$planet_mass_e[is.nan(planet_summary$planet_mass_e)] <- NA
planet_summary$planet_mass_j[is.nan(planet_summary$planet_mass_j)] <- NA
planet_summary$eccentricity[is.nan(planet_summary$eccentricity)] <- NA
planet_summary$planet_equi_temp_k[is.nan(planet_summary$planet_equi_temp_k)] <- NA
planet_summary$stellar_eff_temp_k[is.nan(planet_summary$stellar_eff_temp_k)] <- NA
planet_summary$stellar_rad_sol[is.nan(planet_summary$stellar_rad_sol)] <- NA
planet_summary$stellar_mass_sol[is.nan(planet_summary$stellar_mass_sol)] <- NA
planet_summary$stellar_surf_grav[is.nan(planet_summary$stellar_surf_grav)] <- NA

planet_volumes <- planet_summary %>% 
  select(planet_name, planet_rad_e) %>% 
  mutate(radius_mi = planet_rad_e * 3958.8) %>% 
  summarize(planet_name, volume = ((4/3) * pi * (radius_mi) ^ 3))

# unit = miles cubed
planet_volumes <- drop_na(planet_volumes)

planet_volumes <- planet_volumes %>% 
  mutate(smaller_than_earth = volume < 2.6e11)

num_planets_smaller_earth <- as.data.frame(table(planet_volumes$smaller_than_earth))
colnames(num_planets_smaller_earth) = c("value", "count")

# VALUE 3, 4: percent of planets bigger and smaller than Earth
# percent_bigger, percent_smaller
percent_bigger <- round((num_planets_smaller_earth[1, 2] / sum(num_planets_smaller_earth$count)) * 100, digits=2)
percent_smaller <- round((num_planets_smaller_earth[2, 2] / sum(num_planets_smaller_earth$count)) * 100, digits=2)

# VALUE 5: percent chance we'll arrive at a habitable exoplanet out of the 5044 in the dataset
# percent_habitable
num_habitable <- planet_summary %>% 
  filter(planet_equi_temp_k >= 273 & planet_equi_temp_k <= 300) %>% 
  nrow()

percent_habitable <- round((num_habitable / nrow(planet_summary)) * 100, digits=2)


# fires.csv Summary Values
file = "https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/fires.csv"

fires <- read_csv(url(file))

fires <- fires %>%
  rename(year = FIRE_YEAR, date = DISCOVERY_DATE, state = STATE) %>%
  mutate(month = format(as.Date(date, format = "%Y-%m-%d"),"%m")) %>%
  mutate(state = tolower(state))

# Fires by year dataframe
year_df <- fires %>%
  group_by(year) %>%
  summarize(count = n())

#1 Latest year recorded
max_year <- year_df %>%
   filter(year == max(year)) %>%
   pull(year)
# 2015

#2 Earliest year recorded
min_year <- year_df %>%
   filter(year == min(year)) %>%
   pull(year)
# 1998

#3 Number of fires in latest year
count_max_year <- year_df %>%
   filter(year == max_year) %>%
   pull(count)
# 46409

#4 Number of fires in earliest year
count_min_year <- year_df %>%
   filter(year == min_year) %>%
   pull(count)
# 15598

#5 VALUE 6: Difference in number of fires from 1992 to 2015
 fire_diff <- count_max_year - count_min_year
# 30811

#6 VALUE 7: Percent difference in fires from 1992 to 2015
percent_diff <- 100*((count_max_year - count_min_year)/((count_max_year + count_min_year)/2))
# 99.3791

summary_values_df <- data.frame(highest_month_val,
                                lowest_month_val,
                                percent_bigger,
                                percent_smaller,
                                percent_habitable,
                                fire_diff,
                                percent_diff
                                )

# strings
highest_month_val
lowest_month_val

# numerics
percent_bigger
percent_smaller
percent_habitable


