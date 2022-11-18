library(ggplot2)

shinyUI(fluidPage(
  
  # Application title
  uiOutput("title") ,
  
  # Sidebar with options for the data set
  sidebarLayout(
    sidebarPanel(
      #Title within the sidebar panel
      h3("Select the mammal's biological order:"),
      
      #Select box for type of diet
      selectizeInput("vore", "Vore", selected = "omni", choices = levels(as.factor(msleep$vore))),
      
      #Break
      br(),
      
      #Slider input to select size of points on a graph
      sliderInput("size", "Size of Points on Graph", 
                  min = 1, max = 10, value = 5, step = 1),
      
      #Check box input to color code by conservation status
      checkboxInput("conservation", h4("Color Code Conservation Status", style = "color:red;")),
      
      #Only show this panel if "Color Code Conservation Status" box is clicked
      conditionalPanel(condition = "input.conservation",
                       checkboxInput("rem", "Also change the symbol based on REM sleep?")),
    ),
    
    # Show outputs
    mainPanel(
      plotOutput("sleepPlot"),
      textOutput("info"),
      tableOutput("table")
    )
  )
))
