library(shiny)
library(datasets)
shinyServer(function(input, output) {
  ##reactive is the key point
  datasetInput <- reactive({
    ##both method runs seccessfully
    #switch(input$dataset, rock = rock, pressure = pressure, cars = cars)
    get(input$dataset)
  })
  
  output$caption <- renderText({
    input$caption
  })
  
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
})