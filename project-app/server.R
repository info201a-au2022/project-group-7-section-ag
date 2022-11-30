library(shiny)
library(plotly)
library(ggplot2)

source("../source/exoplanet-chart-code.R")

# Define server logic
shinyServer(function(input, output) {
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
  
  output$temp_user_plot <- renderPlotly({
    
    
    # earth_land_temp_df <- earth_land_temp_df %>%  group_by(Country, `Month Code`, `Month Name`) %>% 
    #   summarize()
    
    plot <- earth_temp_simplifed %>%
            select(input$temp_x_input, input$temp_y_input) %>% 
            filter(!is.na(input$temp_x_input) & !is.na(input$temp_y_input)) %>% 
            ggplot(mapping = aes_string(x = input$temp_x_input, y = input$temp_y_input)) +
            geom_col() +
            #scale_y_continuous(labels = scales::comma) +
            labs(title = paste(input$exo_y_input, "vs", input$exo_x_input))
    
    ggplotly(plot)
  })
  
})
