library(tidyverse)
library(shiny)
library(plotly)
library(ggplot2)
library(dplyr)
library(utf8)
library(rsconnect)
library(reshape2)
library(shinyWidgets)
library(maps)
library(mapproj)

# KelliAnn
#source("../source/exoplanet-chart-code.R")
exoplanets <- read_csv(url("https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/exoplanets.csv"))

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
            discovery_method = unique(discovery_method),
            discovery_year = unique(discovery_year),
            orbital_period_days = mean(orbital_period_days, na.rm=T),
            orbital_semi_maj_axis_au = mean(orbital_semi_maj_axis_au, na.rm=T),
            planet_rad_e = mean(planet_rad_e, na.rm=T),
            planet_rad_j = mean(planet_rad_j, na.rm=T),
            planet_mass_e = mean(planet_mass_e, na.rm=T),
            planet_mass_j = mean(planet_mass_j, na.rm=T),
            eccentricity = mean(eccentricity, na.rm=T),
            planet_equi_temp_k = mean(planet_equi_temp_k, na.rm=T),
            spectral_type = unique(spectral_type),
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

file = "https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/earth-land-temps.csv"
earth_temp_simplifed <- read_csv(url(file))

#KelliAnn
#earth_temp_simplifed <- read_csv("../data/earth-land-temps.csv")
earth_temp_simplifed <- earth_temp_simplifed %>% select(-`Element Code`, -Element, -Unit)
colnames(earth_temp_simplifed)[c(1:4)] <- c("area_code", "country", "month_code", "month_name")
earth_temp_simplifed$month_code <- earth_temp_simplifed$month_code %% 100
earth_temp_simplifed <- earth_temp_simplifed %>% 
                        filter(month_code <= 12 & 
                               area_code != 182 &# "R\xe9union"
                               area_code != 107) %>% # "C\xf4te d'Ivoire"
                        arrange(country)

#source("../source/fires_charts.R")
fires <- read.csv("https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/fires.csv")
fires <- drop_na(fires)
fires <- fires %>%
  rename(year = FIRE_YEAR, date = DISCOVERY_DATE, state = STATE) %>%
  mutate(month = format(as.Date(date, format = "%Y-%m-%d"),"%m")) %>%
  mutate(state = state.name[match(state, state.abb)]) %>%
  mutate(state = tolower(state))

# KelliAnn
exo_inputs <- sidebarPanel(
  selectInput(
    "exo_x_input",
    "Select an x variable:",
    choices = colnames(planet_summary)[-1],
    selected = "num_stars"
  ),
  selectInput(
    "exo_y_input",
    "Select a y variable:",
    choices = colnames(planet_summary)[-1],
    selected = "num_planets"
  ),
  checkboxInput(
    "habitable",
    "Show habitable planets only",
    value = F
  )
)

temp_inputs <- sidebarPanel(
  selectInput(
    "temp_y_input",
    "Select a y variable:",
    choices = colnames(earth_temp_simplifed)[c(5:59)],
    selected = "Y1961"
  ),
  selectInput(
    "temp_country_input",
    "Select a country:",
    choices = unique(earth_temp_simplifed$country),
    selected = "United States of America"
  )
)

fire_inputs <- sidebarPanel(
  selectInput(
    "fire_year_input",
    "Select a year to map:",
    choices = sort(unique(fires$year)),
    selected = 1992
  )
)

explore_data <- tabPanel("Data Exploration",
                         titlePanel("Data Exploration"),
                         h4("We can only cover a small amount of research questions, so this page
                             is for you to do some data exploration of your own. By configuring the
                             chart options, this page allows you to focus on questions and
                             comparisons you might be interested in. Use the options on the left to
                             configure it's corresponding graph."),
                         sidebarLayout(
                           exo_inputs,
                           mainPanel(plotlyOutput("exo_user_plot"))
                         ),
                         sidebarLayout(
                           temp_inputs,
                           mainPanel(plotlyOutput("temp_user_plot"))
                         ),
                         sidebarLayout(
                           fire_inputs,
                           mainPanel(plotlyOutput("fire_user_map"))
                         )
                )

takeaways <- tabPanel(
             "Conclusions",
             titlePanel("Conclusions"),
             h4("Surface Temperature"),
             p("We can see that every country on Earth has experienced an increase in surface
               temperature with a very small number of countries that have experienced a decrease
               in temperature. This increase will likely build over many years until someday
               Earth’s conditions may become too extreme for humans to comfortably live in. We can
               use this trend to motivate that we as a species will eventually have to leave Earth
               in search for a new home."),
             h4("Fires"),
             p("The increase in fires that is shown by the US maps as time progresses supports the
               change in climate that we have all felt as well as the temperature increases revealed
               in the surface temperature data. With the increase in overall temperatures, it’s only
               a matter of time before the fire hotspots increase and not just in the places that are
               known for them."),
             h4("Exoplanets"),
             p("One of the biggest (and slightly depressing) things we can learn from comparing
               different exoplanet charts is that there aren’t really a lot of exoplanets out there
               that would be comfortable for humans to live on in terms of temperature. In the
               dataset we explored, only 41 of the 5044 exoplanets are at a habitable temperature.
               That is only a 0.81% chance of arriving at a habitable exoplanet, however, 0.81% does
               not even take into account what the weather is like on the exoplanet. Extreme weather
               can make the planet uninhabitable even though it has a habitable surface temperature.")
)

# Salley
exoplanets_df <- read_csv(
  "https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/exoplanets.csv"
)

planet_year_df <- exoplanets_df %>%
  select(pl_name, disc_year, discoverymethod) %>%
  group_by(discoverymethod) %>%
  dcast(disc_year ~ discoverymethod)

planet_facility_df <- exoplanets_df %>% 
  select(pl_name, disc_facility, pl_orbper, pl_rade, pl_bmasse, pl_eqt)

plot_sidebar <- sidebarPanel(
  sliderInput(inputId = "minyear", label = "Min Year",
              min = 1988, max = 2021, value = 1988),
  sliderInput(inputId = "maxyear", label = "Max Year",
              min = 1989, max = 2022, value = 2022),
  pickerInput(inputId = "discovery", label = "Choose Methods to Compare",
              multiple = TRUE, choices = colnames(planet_year_df)[2:12],
              selected = colnames(planet_year_df)[2:4],
              options = list(`selected-text-format`= "static",
                             title = "Select at least one discovery method"))
)

plot_main <- mainPanel(
  plotlyOutput("linegraph")
)

chart_sidebar <- sidebarPanel(
  selectInput(
    inputId = "facility", label = "Pick a Facility",
    choices = unique(planet_facility_df$disc_facility)
  )
)

chart_main <- mainPanel(
  plotlyOutput("barchart")
)

widgets_page <- tabPanel(
  "Exoplanet Data Visualizations",
  sidebarLayout(plot_sidebar, plot_main),
  sidebarLayout(chart_sidebar, chart_main)
)

# UI
ui <- navbarPage("INFO201 Project App",
                 tabPanel("Introduction"),
                 takeaways,
                 tabPanel("Report"),
                 navbarMenu("Interactives",
                            tabPanel("Interactive 3"),
                            widgets_page,
                            explore_data,
                            )
      )

# App 
shinyUI(fluidPage(
  ui
))
