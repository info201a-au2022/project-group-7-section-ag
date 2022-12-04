library(tidyverse)
library(shiny)
library(plotly)
library(ggplot2)
library(dplyr)
library(rsconnect)
library(maps)
library(mapproj)

# KelliAnn
#source("../source/exoplanet-chart-code.R")

file = "https://raw.githubusercontent.com/info201a-au2022/project-group-7-section-ag/main/data/earth-land-temps.csv"

earth_temp_simplifed <- read_csv(url(file))

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

# Define server logic
shinyServer(function(input, output) {
  # KelliAnn
  output$exo_user_plot <- renderPlotly({
    plot <- planet_summary %>% 
      select(planet_name, input$exo_x_input, input$exo_y_input, planet_equi_temp_k) %>% 
      filter(!is.na(planet_name) & 
               !is.na(input$exo_x_input) & 
               !is.na(input$exo_y_input) & 
               !is.na(planet_equi_temp_k)
      )
    
    if (input$habitable) {
      plot <- plot %>% filter(planet_equi_temp_k >= 273 & planet_equi_temp_k <= 300)
    }
    plot <- plot %>% 
      ggplot(mapping = aes_string(x = input$exo_x_input, y = input$exo_y_input)) +
      geom_point() +
      scale_x_continuous(labels = scales::comma) +
      scale_y_continuous(labels = scales::comma) +
      labs(title = paste(input$exo_y_input, "vs", input$exo_x_input))
    
    ggplotly(plot)
    
  })
  # KelliAnn
  output$temp_user_plot <- renderPlotly({
    plot <- earth_temp_simplifed %>%
            filter(country == input$temp_country_input) %>% 
            select(month_name, input$temp_y_input) %>%
            filter(!is.na(month_name) & !is.na(input$temp_y_input)) %>%
            ggplot(mapping = aes_string(x = "month_name", y = input$temp_y_input)) +
            geom_point() +
            scale_x_discrete(limits = c("January", "February", "March", "April", "May", "June",
                                        "July", "August", "September", "October", "November",
                                        "December"),
                             labels = c("January" = "Jan", "February" = "Feb", "March" = "Mar",
                                       "April" = "Apr", "May" = "May", "June"  = "Jun",
                                       "July" = "Jul", "August" = "Aug", "September" = "Sep",
                                       "October" = "Oct", "November" = "Nov", "December" = "Dec")
                             ) +
            labs(title = paste(input$temp_country_input,
                               "Temperature Change in",
                               substr(input$temp_y_input, 2, 5)),
                 x = "Month",
                 y = ""
                 )

    ggplotly(plot)
  })
  # KelliAnn
  output$fire_user_map <- renderPlotly({
    state_df <- fires %>%
                filter(year == input$fire_year_input) %>%
                group_by(state) %>%
                summarize(count = n())
    
    state_year <- map_data("state") %>%
                  rename(state = region) %>%
                  left_join(state_df, by = "state")
    
    map_year <- ggplot(state_year) +
                geom_polygon(
                  mapping = aes(x = long, y = lat, group = group, fill = count),
                  color = "black",
                  size = .1
                ) +
                coord_map() +
                scale_fill_continuous(low = "#FFF4B0", high = "#CE0C00", limits = c(0, 6000)) +
                labs(fill = "# of Fires") +
                theme(legend.key.size = unit(0.4, 'cm')) +
                labs(title = paste("US Fires in", input$fire_year_input)) +
                theme(plot.title = element_text(size = 12)) +
                xlab("") + ylab("")
    
    ggplotly(map_year)
  })
  
})
