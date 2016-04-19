library(shiny)
shinyUI(pageWithSidebar(
  
  headerPanel("Generating distribution"),
  
  sidebarPanel(
    selectInput(inputId="method", 
                label="Choose distribution:", 
                choices=c("Normal"="norm", "Student t"="st")),
    helpText("Setting parameter(s) for distribution model"),
    ##condition vs selectinput
    conditionalPanel(condition="input.method=='norm'",
                     numericInput(inputId="mu", label="mean", value=0),
                     numericInput(inputId="sd", label="standard deviation", value=1, min=0)
    ),
    conditionalPanel(condition="input.method=='st'",
                     numericInput(inputId="df", label="Df", value=10, min=1)
    ),
    sliderInput(inputId="obs", 
                label="Number of observations:", 
                min = 0, max = 1000, value = 500)
  ),
  
  mainPanel(
    plotOutput("distPlot")
  )
  
))