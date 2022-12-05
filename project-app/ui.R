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
library(leaflet)
library(readr)
library(shinythemes)

<<<<<<< HEAD
source("exoplanet-chart-code.R")
source("Oceania_Temp_Change_Chart2.R")
source("fires_charts.R")
# exoplanets <- read.csv(file = "exoplanets.csv")
# fires <- read.csv(file = "fires.csv")
# earth_land_temp_df <- read.csv(file = "earth-land-temps.csv")

#KelliAnn
earth_temp_simplifed <- earth_land_temp_df %>% select(-`Element Code`, -Element, -Unit)
colnames(earth_temp_simplifed)[c(1:4)] <- c("area_code", "country", "month_code", "month_name")
earth_temp_simplifed$month_code <- earth_temp_simplifed$month_code %% 100
earth_temp_simplifed <- earth_temp_simplifed %>% 
                        filter(month_code <= 12 & 
                               area_code != 182 &# "R\xe9union"
                               area_code != 107) %>% # "C\xf4te d'Ivoire"
                        arrange(country)
=======
source("dataframes_P3.R")
>>>>>>> f92459cef015333c7042ad3c65ec85b9a73cf541

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
# Claire
fire_input <- sidebarPanel(
  selectInput(
    inputId = "fireyear",
    label = "Select year",
    choices = c("2005","2006","2007","2008", "2009", "2010", "2011", "2012", "2013", "2014","2015")
  )
)

fire_map <- mainPanel(
  leafletOutput("distPlot")
)


temp_plot <- mainPanel( 
  plotlyOutput(outputId = "tempplot")
)

widgets <- tabPanel(
  "Climate Change Visualizations",
  sidebarLayout(
    fire_input, fire_map
  ), 
  temp_plot
)


# UI
ui <- navbarPage("INFO201 Project App",
                 tabPanel("Introduction"),
                 takeaways,
                 tabPanel("Report"),
                 navbarMenu("Interactives",
                            widgets,
                            widgets_page,
                            explore_data,
                 )
)

# App 
shinyUI(fluidPage(
  theme = shinytheme("darkly"),
  ui
))