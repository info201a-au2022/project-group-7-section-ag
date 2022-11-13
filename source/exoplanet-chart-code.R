library(readr)

# INFO201 Project Source Code for exoplanets.csv
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
# Planet Name, Host Name, Number of Stars, Number of Planets
# Discovery Method, Discovery Year, Orbital Period (days)
# Orbit Semi-Major Axis (au), Planet Radius (Earth Radius), Planet Radius (Jupiter Radius), 
# Planet Mass or Mass*sin(i) (Earth Mass), Planet Mass or Mass*sin(i) (Jupiter Mass), Eccentricity, 
#     Equilibrium Temperature (K),
# Spectral Type, Stellar Effective Temperature (K), Stellar Radius (Solar Radius), 
#     Stellar Mass (Solar mass)
# Stellar Surface Gravity (log10(cm/s**2))

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

# number of planets with a certain temp
planet_temp_count <- exoplanets %>% filter(!is.na(planet_equi_temp_k)) %>% 
  group_by(planet_equi_temp_k) %>% 
  summarize(count=n())

# code for charts
# chart works
# bar chart of planet_temp_count dataframe 
# all planets, habitable or not
bar_planet_temp_count <- planet_temp_count %>% 
  ggplot(aes(x=planet_equi_temp_k, y=count)) + geom_col()

# chart works
# line version graph above
line_planet_temp_count <- planet_temp_count %>% 
  filter(!is.na(planet_equi_temp_k)) %>% 
  ggplot(aes(x=planet_equi_temp_k, y=)) + geom_freqpoly(binwidth=50)

# chart works
# scatterplot of planet_temp_count dataframe
scatter_planet_temp_count <- planet_temp_count %>% 
  ggplot(aes(x=planet_equi_temp_k, y=count)) + geom_point() + geom_smooth(se=F)
  
# dataframe with all habitable planets by temperature
habitable <- planet_summary %>% 
  filter(planet_equi_temp_k >= 273 & planet_equi_temp_k <= 300)

# chart works
# bar chart of habitable dataframe
# 273K <= temp <= 300 K, habitable for humans
habitable_exoplanets <- planet_temp_count %>%
  ggplot(aes(x=planet_equi_temp_k, y=count)) + geom_bar(stat="identity") +
  xlim(273, 300)

# chart works
# a chart where each dot represents a planets radius in Earth radii and mass in Earth masses.
# a couple far out data points are omitted, remove xlim and ylim to see full thing
planet_rad_mass_e <- planet_summary %>% 
  select(planet_rad_e, planet_mass_e) %>% 
  filter(!is.na(planet_rad_e) & !is.na(planet_mass_e)) %>% 
  ggplot(aes(x=planet_mass_e, y=planet_rad_e)) + 
  geom_point() + 
  geom_point(aes(x=1, y=1), color="blue") + # Earth
  ylim(0, 50) +
  xlim(0, 10000)


# planet volumes
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

percent_bigger <- (num_planets_smaller_earth[1, 2] / sum(num_planets_smaller_earth$count)) * 100
percent_smaller <- (num_planets_smaller_earth[2, 2] / sum(num_planets_smaller_earth$count)) * 100

#earth rad = 3958.8 mi
# earth volume = 2.6e11 mi^3
