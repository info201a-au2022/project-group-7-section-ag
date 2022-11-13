library(readr)

file = "https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/exoplanets.csv"

exoplanets <- read_csv('../data/exoplanets.csv')
exoplanets <- read_csv(file)

# INFO201 Project Source Code for exoplanets.csv
# exoplanets <- read_csv("exoplanets.csv")

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
temps <- exoplanets %>% filter(!is.na(planet_equi_temp_k)) %>% 
  group_by(planet_equi_temp_k) %>% 
  summarize(count=n())

# code for charts
# chart don't works
# bar chart of temps dataframe 
# all planets, habitable or not
temps %>% 
  ggplot(aes(x=planet_equi_temp_k, y=count)) + geom_col() + xlim(240, 250)

# line version graph above
planet_summary %>% 
  select(planet_name, orbital_period_days) %>% 
  filter(!is.na(orbital_period_days)) %>% 
  ggplot(aes(x=orbital_period_days, y=)) + geom_freqpoly(binwidth=1000)

# 273K <= temp <= 300 K, habitable for humans
habitable_exoplanets <- temps %>%
  ggplot(aes(x=planet_equi_temp_k, y=count)) + geom_bar(stat="identity") +
  xlim(273, 300)

temps %>% filter(planet_equi_temp_k >= 273 & planet_equi_temp_k <= 300) %>% nrow()
# chart works
# scatterplot of temps dataframe
temps %>% 
  ggplot(aes(x=planet_equi_temp_k, y=count)) + geom_point() + geom_smooth()
  
# dataframe with all habitable planets by temperature
habitable <- planet_summary %>% 
  filter(planet_equi_temp_k >= 273 & planet_equi_temp_k <= 300)

# chart works
# a chart where each dot represents a planets radius in Earth radii and mass in Earth masses.
# a couple far out data points are omitted, remove xlim and ylim to see full thing
planet_summary %>% 
  select(planet_rad_e, planet_mass_e) %>% 
  filter(!is.na(planet_rad_e) & !is.na(planet_mass_e)) %>% 
  ggplot(aes(x=planet_mass_e, y=planet_rad_e)) + 
  geom_point() + 
  geom_point(aes(x=1, y=1), color="blue") + # Earth
  ylim(0, 50) +
  xlim(0, 10000)
  

table(planet_summary$planet_rad_e)
colnames(exoplanets)
length(unique(exoplanets$planet_name)) # 5044

# -----
planet_summary %>% 
  select(planet_name, planet_equi_temp_k) %>% 
  filter(!is.na(planet_equi_temp_k)) %>% 
  ggplot(aes(x=planet_equi_temp_k, y=)) + geom_freqpoly(binwidth=50)

planet_summary %>% 
  #select(planet_name, planet_equi_temp_k) %>% 
  filter(!is.na(planet_rad_e) && !is.na(planet_rad_j)) %>% 
  ggplot(aes(x=planet_rad_j, y=planet_rad_e)) + geom_point()



