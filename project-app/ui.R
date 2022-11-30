library(shiny)
library(plotly)
library(ggplot2)

source("../source/exoplanet-chart-code.R")
source("../source/Oceania_Temp_Change_Chart2.R")

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
    "temp_x_input",
    "Select an x variable:",
    choices = colnames(earth_land_temp_df)[c(-5,-6,-7)],
    selected = "Area"
  ),
  selectInput(
    "temp_y_input",
    "Select a y variable:",
    choices = colnames(earth_land_temp_df)[c(-5,-6,-7)],
    selected = "Y1961"
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
                                     )
                                     ),
                            tabPanel("Interactive 3")
                            )
)


# chart_compare <- tabPanel()

# Define UI for application 
shinyUI(fluidPage(
  ui
))
