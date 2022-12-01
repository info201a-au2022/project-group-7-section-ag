library(tidyverse)
library(shiny)
library(plotly)
library(ggplot2)
library(utf8)

source("../source/exoplanet-chart-code.R")
#source("../source/Oceania_Temp_Change_Chart2.R")

earth_temp_simplifed <- read_csv("../data/earth-land-temps.csv")
earth_temp_simplifed <- earth_temp_simplifed %>% select(-`Element Code`, -Element, -Unit)
colnames(earth_temp_simplifed)[c(1:4)] <- c("area_code", "country", "month_code", "month_name")
earth_temp_simplifed$month_code <- earth_temp_simplifed$month_code %% 100
earth_temp_simplifed <- earth_temp_simplifed %>% 
                        filter(month_code <= 12 & 
                               area_code != 182 &# "R\xe9union"
                               area_code != 107) %>% # "C\xf4te d'Ivoire"
                        arrange(country)

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
  # selectInput(
  #   "temp_x_input",
  #   "Select an x variable:",
  #   choices = colnames(earth_temp_simplifed)[c(1, 3, 4)],
  #   selected = "month_name"
  # ),
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

ui <- navbarPage("INFO201 Project App",
                 tabPanel("Introduction"),
                 tabPanel("Takeaways"),
                 tabPanel("Report"),
                 navbarMenu("Interactives",
                            tabPanel("Interactive 1"),
                            tabPanel("Data Exploration",
                                     titlePanel("Data Exploration"),
                                     h4("We can only cover a small amount of research questions, so
                                        this page is for you to do some data exploration of your own.
                                        By configuring the chart options, this page allows you to 
                                        focus on questions and comparisons you might be interested in.
                                        Use the options on the left to configure it's corresponding
                                        graph."),
                                     sidebarLayout(
                                       exo_inputs,
                                       mainPanel(plotlyOutput("exo_user_plot"))
                                     ),
                                     
                                     sidebarLayout(
                                       temp_inputs,
                                       mainPanel(plotlyOutput("temp_user_plot"))
                                     )#
                                     ),
                            tabPanel("Interactive 3")
                            )
)


# chart_compare <- tabPanel()

# Define UI for application 
shinyUI(fluidPage(
  ui
))
