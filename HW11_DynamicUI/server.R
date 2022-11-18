library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {
  #Create a new application title based on which vore is selected using the renderUI/uiOutput functions
  output$title<- renderUI({
    #Return full name (rather than abbreviation) for use in the title based on user input.
    fullName<- 
      if(input$vore == "carni"){
      "Carnivore"
    } else if (input$vore == "herbi"){
      "Herbivore"
    } else if (input$vore == "insecti"){
      "Insectivore"
    } else if (input$vore == "omni"){
      "Omnivore"
    }
    
    #Create title based on user input on vore
    applicationTitle<- paste0("Investigation of ", fullName, " Mammal Sleep Data")
    h1(applicationTitle)
  })

    getData <- reactive({
    newData <- msleep %>% filter(vore == input$vore)
  })
  
  #create plot
  output$sleepPlot <- renderPlot({
    #get filtered data
    newData <- getData()
    
    #create base plot object g
    g <- ggplot(newData, aes(x = bodywt, y = sleep_total))
    #Crate scatterplot based on user input for conservation, rem, and if no checkboxes are selected
    if(input$conservation){
      if(input$rem){
        g + geom_point(size = input$size, 
                       aes(col = conservation, alpha=sleep_rem))
      } else g + geom_point(size = input$size, aes(col = conservation))
    } else {
      g + geom_point(size = input$size)
    }
  })
  
#Update slider minimum value to 3 if rem check box is checked. If rem is not checked the slider will display values from 1-10. This is done using the observe and updateSlider functions.
  observe({
    minValue <- if_else (input$rem, 3, 1)

    updateSliderInput(session, "size", min = minValue)
  })
  
  
  #create text info
  output$info <- renderText({
    #get filtered data
    newData <- getData()
    
    paste("The average body weight for order", input$vore, "is", round(mean(newData$bodywt, na.rm = TRUE), 2), "and the average total sleep time is", round(mean(newData$sleep_total, na.rm = TRUE), 2), sep = " ")
  })
  
  #create output of observations    
  output$table <- renderTable({
    getData()
  })
  
})