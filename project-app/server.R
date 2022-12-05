library(tidyverse)
library(shiny)
library(plotly)
library(ggplot2)
library(dplyr)
library(rsconnect)
library(maps)
library(mapproj)
library(reshape2)
library(shinyWidgets)
library(leaflet)

# KelliAnn
source("exoplanet-chart-code.R")
source("Oceania_Temp_Change_Chart2")
source("fires_charts.R")

earth_temp_simplifed <- earth_land_temp_df %>% select(-`Element Code`, -Element, -Unit)
colnames(earth_temp_simplifed)[c(1:4)] <- c("area_code", "country", "month_code", "month_name")
earth_temp_simplifed$month_code <- earth_temp_simplifed$month_code %% 100
earth_temp_simplifed <- earth_temp_simplifed %>% 
                        filter(month_code <= 12 & 
                               area_code != 182 &# "R\xe9union"
                               area_code != 107) %>% # "C\xf4te d'Ivoire"
                        arrange(country)


# Define server logic
shinyServer(function(input, output) {
  # Salley
  planet_year_df <- exoplanets %>%
    select(pl_name, disc_year, discoverymethod) %>%
    group_by(discoverymethod) %>%
    dcast(disc_year ~ discoverymethod)
  # Salley
  planet_facility_df <- exoplanets %>% 
    select(pl_name, disc_facility, pl_orbper, pl_rade, pl_bmasse, pl_eqt)
  # Salley
  output$linegraph <- renderPlotly({
    filtered_planet_df <- planet_year_df %>% 
      filter(disc_year >= input$minyear, na.rm = TRUE) %>% 
      filter(disc_year <= input$maxyear, na.rm = TRUE) %>% 
      group_by(disc_year) %>% 
      add_count(name = "num_planets") %>% 
      select(disc_year, input$discovery) %>% 
      melt(id.vars = "disc_year")
    p <- ggplot(data = filtered_planet_df, aes(x = disc_year, y = value,
                                               color = variable)) +
      geom_line() +
      xlim(input$minyear, input$maxyear) +
      labs(x = "Year", y = "Number of Planets") +
      scale_color_discrete(name = "Discovery Method") +
      ggtitle("Number of Exoplanets Discovered Per Year")
  })
  # Salley
  output$barchart <- renderPlotly({
    pl_df <- planet_facility_df %>% 
      filter(disc_facility == input$facility, na.rm = TRUE) %>%
      select(pl_name, disc_facility, pl_orbper) %>%
      drop_na(pl_orbper) %>% 
      group_by(pl_name) %>% 
      summarise(new = round(mean(pl_orbper), digits = 2))
    p1 <- ggplot(data = pl_df, aes(x = pl_name, y = new, fill = pl_name)) +
      geom_col() +
      coord_flip() +
      labs(title = "Orbital Period of Exoplanets",
           subtitle = "Discovered at a Selected Facility",
           x = "Exoplanet Name", y = "Orbital Period (Days)") +
      scale_fill_discrete(name = "Exoplanet")
  })
  # Claire
  output$distPlot <- renderLeaflet({
    # Test dataframe
    map_df <- fires %>%
      select(year, date, cause, fire_size, latitude, longitude, state, month) %>%
      group_by(year)
    
    large_fires <- map_df %>% 
      filter(year == input$fireyear)%>%
      filter(fire_size > 500) %>%
      mutate(radius = fire_size/10000)
    
    map_1 <- leaflet(large_fires) %>%
      addTiles()
    
    map_1 <- map_1 %>%
      addCircleMarkers(
        lat = ~latitude,
        lng = ~longitude,
        stroke = FALSE,
        radius = ~radius,
        fillOpacity = 0.4,
        popup = paste0("Cause: ", large_fires$cause, ", ",
                       "Date: ", large_fires$date),
        color = "#FF6030"
      )
    
    map_1
    
  })
  
  output$tempplot <- renderPlotly({
    earth_land_temp_df <- earth_land_temp_df %>%
      filter(Element == "Temperature change")
    
    colnames(earth_land_temp_df) <- gsub("Y", "", colnames(earth_land_temp_df))
    
    test <- data.frame(colMeans(earth_land_temp_df[, 8:66], na.rm = TRUE)) %>%
      rename(avg_temp_change = colMeans.earth_land_temp_df...8.66...na.rm...TRUE.)
    
    test <- test %>%
      mutate(year = row.names(test), test, row.names = NULL)
    
    plot_ly(
      data = test,
      x = ~year,
      y = ~avg_temp_change,
      color = ~avg_temp_change,
      type = "scatter",
      mode = "markers",
      text = ~paste("Year: ", year, "Change in Temperature: ", round(avg_temp_change, digits = 2), "(°C)")
    ) %>%
      layout(
        title = "Yearly Average Temperature Change Across All Countries 1961-2019",
        xaxis = list(title = "Year"),
        yaxis = list(title = "Average Temperature Change (°C)")
      )
    
  })
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