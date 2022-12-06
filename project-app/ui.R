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
                   h1("The STAR-ting Point for STAR and EXOPLANET Exploration!"),
                   h3("Mission: Planet"),
                   p("Authors: KelliAnn Ramirez, Salley Fang, Claire Zhang",
                     "Affiliation: INFO-201 Technical Foundations of Informatics - The Information
                      School - University of Washington",
                     "Date: Autumn 2022"),
                   h3("Abstract"),
                   p("We are concerned with the future of our planet and how it can be influenced
                      by space exploration. Climate changed has undoubtedly shaped the future of life
                      on Earth and we believe with greater knowledge about stars and planets beyond our
                      solar system, we will be able to prepare for life beyond Earth. To address this
                      concern, we plan to gather data about stars and exoplanets into a concise website
                      that is able to filter specific information for users curious about space!"),
                   h3("Keywords"),
                   tags$ul(
                     tags$li("Shaping the future"),
                     tags$li("Space exploration"),
                     tags$li("Stars and exoplanets"),
                   ),
                   h3("Introduction"),
                   p("Mission: Planet is a project in which we look at star, exoplanet and Earth data
                      to analyze how our species might survive beyond Earth's lifespan. On our website,
                      we hope to have a filtering feature in which users can select certain features
                      (e.g. temperature, distance, size) to compare exoplanets and stars with each 
                      other."),
                   p("We'll look at features of habitable planets and how patterns between the planets
                      themselves and their parent star can help us more easily identify other planets
                     capable of sustaining human life. We will also consider the ethics behind space
                     exploration: how it may affect views about sustainability on Earth, what we need
                     to take into account when we arrive at another planet or encounter another
                     civilized society of some species. Considering the possible consequences of space
                     exploration will allow us to better prepare for our future and how life on Earth
                     will change with greater knowledge about outer space."),
                   h3("Problem Domain"),
                   p("Our topic is about outer space, specifically how we can discover and study
                      exoplanets and their surroundings to determine if they are habitable. Our topic
                      concerns human well-being, as the state of Earth may affect the ability for humans
                      to inhabit it in the future (Vince, 2022)."),
                   p("We hope to frame our project around data goals. We want to use data gathered about
                      exoplanets and the stars they are near to find patterns in how features in one may
                      reflect features of the other (e.g., the size of a star corresponding to a certain
                      mass of an exoplanet nearby). We also want to include data about Earth to give
                      users of the website an idea as to what features an exoplanet needs in order to
                      sustain human life in the future. Lastly, we hope to touch on the ethics behind
                      our project. There are concerns with how the search for a new planet could lead
                      to changes in how we treat Earth and with what we should do if we encounter
                      extraterrestrial life (Munro, 2022)."),
                   p("Human values our topic touches on self-reliance, determination, and problem
                      solving. Our issue we hope to help solve is one that concerns the future of the
                      human race. The future is in our own hands and with these values in mind, we may
                      be able to better prepare and anticipate issues for generations to come."),
                   p("Direct stakeholders for our website include astronomy enthusiasts who want to
                      learn more about exoplanets and stars, policymakers supporting the increase in
                      space exploration and investment, and aerospace engineers and researchers, who
                      may use our data as a starting point in creating new technologies and designs
                      that find exoplanets and study their habitability (Burbach, 2019). Indirect
                      stakeholders include citizens who may be affected by decisions made by the gov’t
                      and policymakers who use our website."),
                   p("Harms that may come from our project largely concern the ethics behind what we
                      hope to achieve. Encouraging the search for other habitable planets may cause
                      people to treat Earth as disposable. Colonizing other planets with the possibility
                      of bringing bacteria, disease, and other harmful elements should be discussed
                      (Dirks, 2021). Benefits from our project could include the increased interest 
                      and investment in space exploration. Preparing early for the potential relocation
                      of humans is another benefit, as our data could be implemented to discover new
                      exoplanets and determine their living conditions."),
                   h3("Research Questions"),
                   tags$ol(
                     tags$li("Of the exoplanets we know of, what is the proportion of those exoplanets
                              being habitable? What are some commonalities between the habitable
                              exoplanets?"),
                     tags$ul(tags$li("Because of the strong likelihood of Earth becoming uninhabitable
                                      in the future, we need to find patterns in exoplanets that could
                                      make it liveable for humans. It is important to start this
                                      exploration process early due to the sheer number of exoplanets
                                      that have already been discovered and have yet to be discovered.")),
                     tags$li("How has climate change affected Earth over time (e.g., temperature, natural
                              disasters, air quality)?"),
                     tags$ul(tags$li("This is important because climate change will eventually make Earth
                                      uninhabitable. Where will we live when that happens? Learning
                                      about outside planetary systems helps us prepare for that
                                      inevitable future.")),
                     tags$li("What are the ethical concerns behind space exploration?"),
                     tags$ul(tags$li("One potentially harmful mindset behind the desire for space
                                      exploration is seeing the Earth as disposable and impermanent.
                                      Will this view lead to even worse mistreatment of the Earth as
                                      people begin to see it as a temporary place to live?")),
                     tags$li("What happens if we encounter/discover life beyond Earth?"),
                     tags$ul(tags$li("This is important because we have to consider that we would be 
                                      bringing Earth bacteria and organisms to the other planet and
                                      potentially harming the life already there. We also have to
                                      consider what to do if we find a habitable planet but another
                                      species has colonized it. Do we try to mesh ourselves into the
                                      existing society or do we wipe it out to create our own?"))
                   ),
                   h3("The Datasets"),
                   p("Climate change and unusual weather conditions is what motivates us to think about
                      what’s in the future for the human species. We can use data about weather
                      conditions to support this motivation. We can do research on what makes a planet
                      habitable and given that information, we can look at data for different planets
                      and determine which ones would likely be most habitable for humans."),
                   h4("Earth Temperatures"),
                   p("This dataset was obtained from kaggle and we fully intend on crediting the source.
                      The dataset is named earth-land-temps.csv in our GitHub repository and has 9656
                      observations and 66 variables. The data was collected by NASA GISTEMP and put on
                      kaggle by Sevgi Sy. They give credit to NASA GISTEMP on the website containing the
                      dataset. They probably put it on kaggle because the format of NASA’s downloadable
                      data doesn’t come out nice so they solve that issue for many people by cleaning
                      it themselves and putting it on kaggle. NASA is governmentally funded so they get
                      their funding from the federal government. For Sevgi Sy, they offered their own
                      time to clean and put this dataset on kaggle. Sevgi Sy will likely make money from
                      the dataset that’s on kaggle, but if people were to go to the NASA GISTEMP site
                      and download it there, then NASA GISTEMP would be making the money. The data is
                      probably somewhat trustworthy because it’s NASA GISTEMP’s data, but we don’t know
                      who this Sevgi Sy person is and we don’t know if some data was held back or altered
                      in some way before publishing to kaggle."),
                   h4("Exoplanets"),
                   p("This dataset was obtained from kaggle and we fully intend on crediting the source.
                      The dataset is named exoplanets.csv in our GitHub repository and has 32552
                      observations and 93 variables. NASA collected the data and it was put on kaggle
                      by the user name Sathyanarayan Rao. They give credit to NASA on the website 
                      containing the dataset. They probably put it on kaggle because the format of 
                      NASA’s downloadable data doesn’t come out nice so they solve that issue for 
                      many people by cleaning it themselves and putting it on kaggle. NASA is 
                      governmentally funded so they get their funding from the federal government. 
                      For Sathyanarayan Rao, they offered their own time to clean and put this dataset
                      on kaggle. Sathyanarayan Rao is likely to make money from the dataset that’s on
                      kaggle, but if people were to go to the NASA site and download it there, then 
                      NASA would be making the money. The data is probably somewhat trustworthy because
                      it’s NASA’s data, but we don’t know who this Sathyanarayan Rao person is and we 
                      don’t know if some data was held back or altered in some way before publishing
                      to kaggle."),
                   h4("Forest Fires in the US"),
                   p("This dataset was obtained from kaggle and we fully intend on crediting the source.
                      The dataset is named fires.csv in our GitHub repository and hass 597998
                      observations and 20 variables. The data is an adaptation of another dataset
                      already on kaggle and the person gives credit to that dataset. It states that
                      the data was collected from various reporting systems at the federal, state and
                      local level governing systems. The person, Muthu Chidambaram, seems to have put
                      the dataset on kaggle because of some assignment for school because the
                      requirements they need to have are in the description of the dataset. The
                      governing systems probably had their own money to use to get and compile the
                      original data. For Muthu Chidambaram, they offered their own time to clean and
                      put the dataset on kaggle. They will likely make money from the dataset that’s
                      on kaggle, but if people were to go to the original dataset on kaggle or go
                      directly to the reporting systems and download it there, then those organizations
                      would be making the money. The data is probably somewhat trustworthy if it’s
                      coming from actual government organizations but I don’t know who Muthu 
                      Chidambaram is and I don’ t know if some data was held back or altered in some
                      way before publishing to kaggle."),
                   h3("Expected Limitations"),
                   p("Assuming our research questions are answered, a possible implication for
                      technologists could be to advance space exploration technology to utilize the
                      features of stars to more efficiently discover new habitable exoplanets. Other
                      features technologists may want to touch on could include analyzing certain parts
                      of exoplanets, like surface temperature and water temperature and availability
                      and temperature to understand how the exoplanet compares to Earth."),
                   p("Designers may use research question answers in their implication of designing
                      space exploration technology. Designers must keep certain ethics, like the
                      mistreatment of Earth that results from finding other habitable planets and how
                      to approach bringing human life to other planets, in mind as they create new
                      technologies."),
                   p("Lastly, expected implications of our research conclusions and answers for
                      policymakers include policies behind the ethics of space exploration. There are
                      a number of concerns with how knowledge we've gathered may shape perspectives on
                      the treatment of Earth and of life outside Earth."),
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
                     on the data we have collected."),
                   h3("Acknowledgements"),
                   p("Thank you to kaggle.com for providing a majority of our data and making it simple
                      to view and open on RStudio!"),
                   p("We would also like to thank Rona, our TA, for answering our questions during
                      section, office hours, and Teams!"),
                   h3("References"),
                   tags$ul(
                     tags$li("Burbach, David T. “Partisan Rationales for Space: Motivations for Public
                              Support of Space Exploration Funding, 1973–2016.” Space Policy, vol. 50,
                              2019, p. 101331., https://doi.org/10.1016/j.spacepol.2019.08.001."),
                     tags$li("Dirks, Nicholas. “The Ethics of Sending Humans to Mars.” Scientific 
                              American, 10 Aug. 2021, https://www.scientificamerican.com/article/the
                              -ethics-of-sending-humans-to-mars/."),
                     tags$li("Munro, Daniel. “If Humanity Is to Succeed in Space, Our Ethics Must 
                              Evolve.” Centre for International Governance Innovation, 4 Apr. 2022, 
                              https://www.cigionline.org/articles/if-humanity-is-to-succeed-in-space
                              -our-ethics-must-evolve/."),
                     tags$li("Vince, Gaia. “Where We'll End Up Living as the Planet Burns.” Time, 31
                              Aug.2022, https://time.com/6209432/climate-change-where-we-will-live/.")
                   )
                  )



# UI
ui <- navbarPage("The STAR-ting Point",
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