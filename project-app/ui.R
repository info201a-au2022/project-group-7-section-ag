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
  h2("Number of Exoplanets Discovered"),
  p("The charts display trends in exoplanet discovery over the past 34 years. 
    The first chart is a line graph that shows the change in number of
    exoplanets discovered for each year in a user-selected range of years
    (1988-2022). This shows users how much exoplanet discovery has changed
    and grown in a certain period of time."),
  sidebarLayout(plot_sidebar, plot_main),
  h2("Exoplanets and Their Orbital Periods"),
  p("The second chart is a bar chart displaying the orbital period of exoplanets
    at a user-chosen facility. This information is important in seeing which
    discovery facilities have found more exoplanets and/or which facilities
    have found more exoplanets with orbital periods similar to Earth, a possible
    factor in determining an exoplanet's habitability."),
  sidebarLayout(chart_sidebar, chart_main)
)

# Claire
fire_input <- sidebarPanel(
  selectInput(
    inputId = "fireyear",
    label = "Select year",
    choices = c("2005","2006","2007","2008", "2009", "2010", "2011", "2012",
                "2013", "2014","2015")
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
  p("This map displays large wildfires in the US for a selected year.
    It shows the trend in the number of wildfires over time, as well as
    where wildfires tend to occur across the US."),
  sidebarLayout(fire_input,
                fire_map),
  h2("Average Temperature Change Across All Countries Over Time"),
  p("This chart displays the yearly change in average temperature across the
    globe from 1961 to 2019, which shows the relatively large increases in
    recent years."),
  temp_plot
)


introduction <- tabPanel("Introduction", sidebarLayout(
  sidebarPanel(
    h3("The Questions"),
    p("The questions our project seeks to answer are as follows:"),
    p("1. Of the exoplanets we know of, what is the proportion of exoplanets that are habitable, 
    and what are some commonalities between those planets?"),
    p("2. How has climate change affected Earth over time?"),
    p("3. What are the ethical concerns and considerations behind space exploration?"),
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
    h2("About Us:"),
    p("KelliAnn Ramirez, Salley Fang, Claire Zhang"),
    p("INFO 201"),
    p("Autumn 2022")
  ),
  mainPanel(
    img(src = "https://assets.newatlas.com/dims4/default/3168c10/2147483647/strip/true/crop/1080x720+0+180/resize/1200x800!/quality/90/?url=http%3A%2F%2Fnewatlas-brightspot.s3.amazonaws.com%2Farchive%2Fearth-from-space-6.jpg",
        width = "95%,", height = "95%"),
    p("")
    )
  )
)

report <- tabPanel("Report",
                   h3("Project Brief"),
                   p(strong("Code Name:"), "Mission:Planet"),
                   p(strong("Project Title:"),
                     "The STAR-ting Point for STAR and EXOPLANET Exploration!"),
                   p(strong("Authors:")),
                   p("KelliAnn Ramirez (kellianr@uw.edu),
                     Salley Fang (skfang@uw.edu),
                     Claire Zhang (czhang88@uw.edu)"),
                   p(strong("Affiliation:"), "INFO-201: Technical Foundations of
                     Informatics - The Information School - University of Washington"),
                   p(strong("Date:"), "Autumn 2022"),
                   p(strong("Abstract:"),
                     "We are concerned with the future of our planet and how it can be
                     influenced by space exploration. Climate change has undoubtedly
                     shaped the future of life on Earth and we believe with greater
                     knowledge about planets beyond our solar system and about our planet's
                     current conditions, we will be able to prepare for life beyond Earth.
                     To address this concern, gathered data about exoplanets, Earth temperatures,
                     andwildfires into a concise website that is able to filter specific
                     information for users curious about space and climate change!"),
                   p(strong("Keywords:")),
                   p("Shaping the future, Space exploration, Stars and exoplanets"),
                   h3("Introduction"),
                   p("Mission: Planet is a project in which we look at star, exoplanet and
                     Earth data to analyze how our species might survive beyond Earth's lifespan.
                     On our website, we hope to have a filtering feature in which users can select
                     certain features (e.g. temperature, distance, size) to compare exoplanets and
                     stars with each other. We'll look at features of habitable planets and how
                     patterns between the planets themselves and their parent star can help us
                     more easily identify other planets capable of sustaining human life. We will
                     also consider the ethics behind space exploration: how it may affect views
                     about sustainability on Earth, what we need to take into account when we
                     arrive at another planet or encounter another civilized society of some
                     species. Considering the possible consequences of space exploration will
                     allow us to better prepare for our future and how life on Earth will change
                     with greater knowledge about outer space."),
                   h3("Problem Domain"),
                   p("Our topic is about outer space, specifically how we can discover and study exoplanets
                     and their surroundings to determine if they are habitable. Our topic concerns human
                     well-being, as the state of Earth may affect the ability for humans to inhabit it in the
                     future (Vince, 2022)."),
                   p("We hope to frame our project around data goals. We want to use data
                     gathered about exoplanets and the stars they are near to find patterns in how features in
                     one may reflect features of the other (e.g., the orbital period corresponding to a certain
                     mass of an exoplanet nearby). We also want to include data about Earth to give users of the
                     website an idea as to what features an exoplanet needs in order to sustain human life in the
                     future. Lastly, we hope to touch on the ethics behind our project. There are concerns with
                     how the search for a new planet could lead to changes in how we treat Earth and with what we
                     should do if we encounter extraterrestrial life (Munro, 2022)."),
                   p("Human values our topic touches on self-reliance, determination, and problem solving.
                     Our issue we hope to help solve is one that concerns the future of the human race.
                     The future is in our own hands and with these values in mind, we may be able to better
                     prepare and anticipate issues for generations to come."),
                   p("Direct stakeholders for our website include astronomy enthusiasts who want to 
                     learn more about exoplanets and stars, policymakers supporting the increase 
                     in space exploration and investment, and aerospace engineers and researchers, 
                     who may use our data as a starting point in creating new technologies and 
                     designs that find exoplanets and study their habitability (Burbach, 2019). 
                     Indirect stakeholders include citizens who may be affected by decisions made 
                     by the gov’t and policymakers who use our website."),
                   p("Harms that may come from our project largely concern the ethics behind what we hope
                     to achieve. Encouraging the search for other habitable planets may cause people to
                     treat Earth as disposable. Colonizing other planets with the possibility of bringing
                     bacteria, disease, and other harmful elements should be discussed (Dirks, 2021).
                     Benefits from our project could include the increased interest and investment in
                     space exploration. Preparing early for the potential relocation of humans is another
                     benefit, as our data could be implemented to discover new exoplanets and determine
                     their living conditions."),
                   h3("Research Questions"),
                   p(strong("1. Of the exoplanets we know of, what is the proportion of those exoplanets
                            being habitable? What are some commonalities between the habitable exoplanets?")),
                   p("Because of the strong likelihood of Earth becoming uninhabitable in the future, we need
                     to find patterns in exoplanets that could make it liveable for humans. It is important
                     to start this exploration process early due to the sheer number of exoplanets that have
                     already been discovered and have yet to be discovered."),
                   p(strong("2. How has climate change affected Earth over time (e.g., temperature, natural
                            disasters, air quality)?")),
                   p("This is important because climate change will eventually make Earth uninhabitable.
                     Where will we live when that happens? Learning about outside planetary systems helps us
                     prepare for that inevitable future."),
                   p(strong("3. What are the ethical concerns and considerations behind space exploration?")),
                   p("One potentially harmful mindset behind the desire for space exploration is seeing the
                     Earth as disposable and impermanent. This view could lead to even worse treatment of
                     the Earth as people begin to see it as a temporary place to live. We also need to be
                     aware of the potential risks that come with bringing bacteria and organisms from Earth
                     to other places. If we encounter life outside Earth, how do we integrate ourselves into
                     different societies?"),
                   h3("The Datasets"),
                   p("Climate change and unusual weather conditions is what motivates us to think about what’s
                     in the future for the human species. We can use data about weather conditions to support
                     this motivation. We can do research on what makes a planet habitable and given that information,
                     we can look at data for different planets and determine which ones would likely be most habitable
                     for humans."),
                   p(em("Earth Temperatures")),
                   p("This dataset was obtained from kaggle and we fully intend on crediting the source. The dataset
                     (earth-land-temps.csv) is in our GitHub repository and has 9656 observations and 66 variables.
                     The data was collected by NASA GISTEMP and put on kaggle by Sevgi Sy. They give credit to NASA
                     GISTEMP on the website containing the dataset. They likely published their clearner version of
                     the data because NASA's is messy. NASA is governmentally funded, meaning they get their funding
                     from the federal government. The data is trustworthy because it is collected and published through NASA,
                     but we were unable to find further information on the author of the dataset we used, Sevgi Sy."),
                   p(em("Exoplanets")),
                   p("This dataset was obtained from kaggle and we fully intend on crediting the source. The dataset
                     (exoplanets.csv) is in our GitHub repository and has 32552 observations and 93 variables. NASA
                     collected the data and it was put on kaggle by the user Sathyanarayan Rao. They give credit to NASA
                     on Kaggle along with their dataset. They likely put the data on kaggle because the format of
                     NASA’s downloadable data doesn’t come out nice so they solve that issue for many people by cleaning
                     it themselves and putting it on kaggle. NASA is governmentally funded so they get their funding from
                     the federal government. For Sathyanarayan Rao, they offered their own time to clean and put this dataset
                     on kaggle. The data is probably somewhat trustworthy because it’s NASA’s data, but we were unable to find
                     further information on the author of the dataset we used."),
                   p(em("Forest Fires in the US")),
                   p("This dataset was obtained from kaggle and we fully intend on crediting the source. The dataset is named
                     fires.csv in our GitHub repository and hass 597998 observations and 20 variables. The data is an adaptation
                     of another dataset already on kaggle and the author, Muthu Chidambaram gives credit to that dataset. They state
                     that the data was collected from various reporting systems at the federal, state and local level governing systems.
                     The governing systems likely used their own money to get and compile the original data. For Muthu Chidambaram,
                     they offered their own time to clean and put the dataset on kaggle. They will likely make money from the dataset
                     that’s on kaggle, but if people were to go to the original dataset on kaggle or go directly to the reporting
                     systems and download it there, then those organizations would make money. The data is likely trustworthy as it is
                     from government organizations but we were unable to find further informaiton on the author, Chidambaram."),
                   h3("Expected Implications"),
                   p("Assuming our research questions are answered, a possible implication for technologists could be to advance space
                   exploration technology to utilize the features of stars to more efficiently discover new habitable exoplanets.
                   Other features technologists may want to touch on could include analyzing certain parts of exoplanets, like surface
                   temperature and water temperature and availability and temperature to understand how the exoplanet compares to Earth."),
                   p("Designers may use research question answers in their implication of designing space exploration technology.
                     Designers must keep certain ethics, like the mistreatment of Earth that results from finding other habitable planets
                     and how to approach bringing human life to other planets, in mind as they create new technologies."),
                   p("Lastly, expected implications of our research conclusions and answers for policymakers include policies behind the
                   ethics of space exploration. There are a number of concerns with how knowledge we've gathered may shape perspectives
                   on the treatment of Earth and of life outside Earth."),
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
                   h3("Findings"),
                   p(strong("1. Of the exoplanets we know of, what is the proportion of those exoplanets
                            being habitable? What are some commonalities between the habitable exoplanets?")),
                   p("Out of the planets we know of, a very small proportion of them are habitable. When
                     looking through our exoplanet dataset, we noted a significantly smaller proportion than
                     we had imagined (about 0.81%). We found this percentage through going through different
                     features of exoplanets and seeing which ones were similar to Earth. Because a majority
                     of exoplanets were larger than earth (95.39%), this feature already filtered out a great
                     number of possible habitable planets. We also looked at factors like max and orbital
                     period to determine the chances an exoplanet could be habitable. Commonalities between
                     habitable exoplanets were a similar size, mass, orbital period, and temperature to Earth.
                     These commonalities were rare to come across in the data from the exoplanets.csv file."),
                   p(strong("2. How has climate change affected Earth over time (e.g., temperature, natural
                            disasters, air quality)?")),
                   p("Climate changed has dramatically affected Earth over time. In both features covered in our
                     earth-land-temps.csv and our fires.csv file (temperature changes over time and wildfire
                     data, respectively), we have found dramatic changes. For earth land temperatures, nearly
                     every country showed an increase in temperatures. The temperature increases were apparent
                     year-long, with the highest temperature change occuring in March (0.6 degrees C) and the
                     lowest occurring in December (0.43 degrees C). For wildfires, the number has increased
                     dramatically from 1992 to 2015. The difference in number of wildfires was more than 30,000
                     and showed the fastest growth in wildfires in recent years. Both tempreatures and fires
                     throughout the world have been rising (most significantly in recent years), reflecting
                     the effects climate change is having on our planet currently."),
                   p(strong("3. What are the ethical concerns and considerations behind space exploration?")),
                   p("In going through our two datasets, we have noted ethical concerns behind space exploration
                     and have considered the risks for if we encounter life outside Earth. Firstly, an ethical
                     concern could be the continued (and likely strengthened) mistreatment of our planet.
                     Gathering data about the probabilities of finding a habitable exoplanet for possible human
                     colonization will likely lead to a sense of dissonance between ourselves and our planet.
                     It may make taking care of it seem less of a priority. Secondly, the analyzation and inclusion
                     of data about the rapid climate change occurring may discourage people from taking part in
                     slowing down its effects on Earth. Much of the data we gathered showed how quickly fires
                     and temperatures are increasing, especially in recent years. There is little optimism in the
                     data we shared. Lastly, the concerns behind what we should do if we were to encounter life
                     outside of Earth is important to consider. We are risking exposing and harming another species
                     if we were to bring our diseases/bacteria/goods from Earth to a foreign environment."),
                   h3("Discussion"),
                   p("Our findings are crucial in giving people a well-rounded understanding of our planet and its
                     future. In deciding a project topic, we wanted to choose a topic that could help people better
                     understand a current and relevant problem while also providing a possible solution to look
                     into. Much of the news and data we see leaves us wondering what we can do to improve upon a
                     situation or solve it. Though we may not offer the solution to climate change, we wanted to
                     share another path oru planet may likely take in the not-so-distant future. Firstly, we wanted
                     to provide thorough and detailed information about climate change. There is no doubt there
                     are significant changes in our planet, especially in recent years. It is crucial for people to
                     understand and know about these changes to develop a greater sense of urgency to help find
                     solutions and help slow down its rapid effects. On top of providing this information to users,
                     our data also shares a possible solution rarely discussed in media: space exploration. Finding
                     a new planet for humans to live on sounded outlandish to most of our group at first but the
                     more we thought about it, the more likely we saw it occurring. Because of the nature of humans
                     and the rapid changes in our planet we have noticed, we know there is a great chance the state
                     of our planet may never be completely healed. Rather than waiting for our imminent doom, we
                     decided to look into the possible solution of finding another planet to populate. In looking
                     through exoplanet dataets and sharing the likelihoods of discovering a habitable exoplanet given
                     the current set of exoplanets facilities around the world have found, we are sharing with
                     users a look into the future of Earth. This information is crucial in helping humans better
                     prepare for our future"),
                   p("Possible implications for our data include its use in spreading awareness about space exploration
                     and climate change. Our webpage and data may be shared through organizations trying to garner
                     attention on the rapidly changing effects of climate change. Space exploration enthusiasts may
                     also be interested in using our interactive visualizations. Researchers may also use our data to
                     compare exoplanet and climate change data. There are a variety of uses for our data, and a wide
                     range of people are able to use it in different ways to learn more about climate change and the
                     possible future of humanity."),
                   h3("Conclusion"),
                   p("The summary point we want to leave for users is that knowledge and awareness is the best way
                     to prepare for the future. In many situations, knowing the context behind something before it
                     happens is the best way to be able to control its effects on you. This point can be applied
                     to many different scales. For example, awareness about the content of a test is a good way
                     to prepare and study for one in order to do well. On a bigger scale, this point can be
                     applied to how our group chose and grouped together our data. Climate change and space
                     exploration may seem like two completely different topics with no overlap. However, climate
                     change could result in the need for space exploration in the future. And knowing the current
                     effects climate change is having on our planets is one way to better prepare for our future.
                     With this knowledge in mind, we are able to explore possible solutions. We can build off of
                     our knowledge of climate change and our awareness of it to motivate our research in discovering
                     possibly habitable exoplanets. We hope users of our website are able to learn about both topics
                     and start to see their connections. Climate change is a current issue every person on Earth
                     is facing. It is something we will continue to deal with the rest of our lives and for the
                     rest of humanity. When this issue becomes one we may not turn back from, having a possible
                     solution in mind can be the meaning between the continuation and end of humanity. By spreading
                     awareness about space exploration, we are showing people a solution they may not have considered
                     before. We hope people will take great care and caution in using our website. We hope it gives
                     them an honest look into our current and possible future situations and clarifies the state we
                     are in and our possible solutions. We do not want to discourage people from trying to continue
                     to protect Earth for as long as possible, but want to make sure people are aware of all the
                     different paths we may go down in the future. Preparation and awareness does not necessarily
                     correspond with laziness or a loss of hope. It could be (and we hope it is) a motivation to
                     doing more work in preserving our planet. Space exploration may seem unnecessary and odd now,
                     but we believe it is closer and will become more relevant soon. The future is coming faster
                     than we think. We must be prepared for any and all possible events humanity may face."),
                   h3("Acknowledgements"),
                   p("Thank you to kaggle.com for providing a our datasets and making them free and simple to
                     view and open on RStudio! We would also like to thank Rona, our TA, for answering our
                     questions during section, office hours, and on Teams!"),
                   h3("References"),
                   p("Burbach, David T. “Partisan Rationales for Space: Motivations for Public Support of
                     Space Exploration Funding, 1973–2016.” Space Policy, vol. 50, 2019, p. 101331.,
                     https://doi.org/10.1016/j.spacepol.2019.08.001."),
                   p("Dirks, Nicholas. “The Ethics of Sending Humans to Mars.” Scientific American, 10 Aug. 2021,
                     https://www.scientificamerican.com/article/the-ethics-of-sending-humans-to-mars/."),
                   p("Munro, Daniel. “If Humanity Is to Succeed in Space, Our Ethics Must Evolve.”
                     Centre for International Governance Innovation, 4 Apr. 2022,
                     https://www.cigionline.org/articles/if-humanity-is-to-succeed-in-space-our-ethics-must-evolve/."),
                   p("Vince, Gaia. “Where We'll End Up Living as the Planet Burns.” Time, 31 Aug. 2022,
                     https://time.com/6209432/climate-change-where-we-will-live/."),
                   h3("Appendix A: Questions"),
                   p(em("No Questions!"))
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