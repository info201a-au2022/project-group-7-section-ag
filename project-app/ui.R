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

source("dataframes_P3.R")

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
  p("My charts display the trends in exoplanet discovery. 
    My first interactive chart is a line graph that shows the change 
    in number of exoplanets discovered for each year in a selected 
    range of years. This shows users how much exoplanet discovery 
    as changed and grown in a short period of time. My second interactive 
    chart is a bar chart displaying the orbital period of exoplanets at 
    a chosen facility. This information is important in seeing which 
    facilities have discovered more exoplanets and which facilities 
    have discovered more habitable planets with orbital periods similar to Earth."),
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
  h2("US Wildfires Mapped Over Time"),
  p("This map displays large wildfires in the US for a selected
                  year. It shows the trend in the number of wildfires over time, as well as
                  where wildfires tend to occur across the US."),
  sidebarLayout(fire_input,
                fire_map),
  h2("Average Temperature Change Across All Countries Over Time"),
  p("This chart displays the yearly change in average temperature across the globe from 1961 to 2019,
    which shows the relatively large increases in recent years."),
  temp_plot
)


introduction <- tabPanel("Introduction", sidebarLayout(
  sidebarPanel(
    h3("The Questions"),
    p("The questions our project seeks to answer are as follows:"),
    p("1. Of the exoplanets we know of, what is the proportion of exoplanets that are habitable, 
    and what are some commonalities between those planets?"),
    p("2. How has climate change affected Earth over time?"),
    p("3. What are the ethical concerns behind space exploration?"),
    p("4. What happens if we encounter/discover life beyond Earth?"),
    h3("The Data"),
    p("Three datasets were used in this project. Data on Earth temperatures was collected
          by NASA GISTEMP and put on kaggle by Sevgi Sy. It lists temperature changes across the world
          from 1961 to 2019. Data on fires in the United States was collected with funding from the US
          government, cleaned, and put on kaggle by a person named Muthu Chidambaram. It lists wildfires
          in the United States between 1992 and 2015. Some notable features included are statistical cause,
          discovery date, fire size, longitude, latitude, and state. Data on exoplanets was collected
          by NASA and put on kaggle by Sathyanarayan Rao. It lists the exoplanets that have been 
          discovered so far, as well as many of their features, including orbital period, radius, 
          mass, and equilibrium temperature."),
    h2("About Us"),
    p("KelliAnn Ramirez, Salley Fang, and Claire Zhang"),
    p("INFO 201"),
    p("Fall 2022")
  ),
  mainPanel(
    img(src = "https://assets.newatlas.com/dims4/default/3168c10/2147483647/strip/true/crop/1080x720+0+180/resize/1200x800!/quality/90/?url=http%3A%2F%2Fnewatlas-brightspot.s3.amazonaws.com%2Farchive%2Fearth-from-space-6.jpg",
        width = "95%,", height = "95%"),
    p("")
    )
  )
)

report <- tabPanel("Report",
                   h3("Problem Domain"),
                   p("Our topic is about outer space, specifically how we can discover and study exoplanets and their surroundings to determine if they are habitable. Our topic concerns human well-being, as the state of Earth may affect the ability for humans to inhabit it in the future (Vince, 2022).
                     We hope to frame our project around data goals. We want to use data gathered about exoplanets and the stars they are near to find patterns in how features in one may reflect features of the other (e.g., the size of a star corresponding to a certain mass of an exoplanet nearby). We also want to include data about Earth to give users of the website an idea as to what features an exoplanet needs in order to sustain human life in the future. Lastly, we hope to touch on the ethics behind our project. There are concerns with how the search for a new planet could lead to changes in how we treat Earth and with what we should do if we encounter extraterrestrial life (Munro, 2022).
                     Human values our topic touches on self-reliance, determination, and problem solving. Our issue we hope to help solve is one that concerns the future of the human race. The future is in our own hands and with these values in mind, we may be able to better prepare and anticipate issues for generations to come.
                     Direct stakeholders for our website include astronomy enthusiasts who want to 
                     learn more about exoplanets and stars, policymakers supporting the increase 
                     in space exploration and investment, and aerospace engineers and researchers, 
                     who may use our data as a starting point in creating new technologies and 
                     designs that find exoplanets and study their habitability (Burbach, 2019). 
                     Indirect stakeholders include citizens who may be affected by decisions made 
                     by the gov’t and policymakers who use our website."),
                   h3("Limitations"),
                   p("Limitations we may face include not having the appropriate data to answer 
                     the questions we have posed. We might not have been able to find the data we 
                     want and that can limit the extent to which we are able to answer our research 
                     questions. We also may not be able to discuss every opinion people might have in 
                     regards to our questions. People have diverse views about all kinds of topics and 
                     we may only be able to think of and address a small portion of those perspectives.
                     We also can only approach the questions based on our own background and knowledge. 
                     We are not astronomy experts so what we know and say as a result is limited. We also
                     are not fortune tellers who can see the future so what we say may not end up being 
                     true or actually happen. We just propose what we think is likely to happen based 
                     on the data we have collected.")
                   )



# UI
ui <- navbarPage("INFO201 Project App",
                 introduction,
                 takeaways,
                 report,
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