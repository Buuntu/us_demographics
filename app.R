library(shiny)
library(maps)
library(mapproj)

source("helpers.R")

counties <- readRDS("data/counties.rds")

ui <- fluidPage(
  titlePanel("US Demographics"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with information from the 2010 US Census."),
      
      selectInput("var",
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range",
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0,100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)

server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var,
                    "Percent White" = counties$white,
                    "Percent Black" = counties$black,
                    "Percent Hispanic" = counties$hispanic,
                    "Percent Asian" = counties$asian
    )
    percent_map(var = data, "darkgreen", "% White", max=input$range[2], min=input$range[1])
  })
}

shinyApp(ui, server)
