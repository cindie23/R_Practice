library(shiny)

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  ##title
  headerPanel("Reactivity"),
  
  ##left control panel
  sidebarPanel(
    ##inputbox              title       value
    textInput("caption", "Caption:", "Data Summary"),
    ##selectbox
    selectInput("dataset", "Choose a dataset:", 
                choices = c("rock", "pressure", "cars")),
    ##choose numeric box
    numericInput("obs", "Number of observations to view:", 10)
  ),
  
  mainPanel(
    ##right title
    ##read text from inputbox
    h3(textOutput("caption")), 
    
    verbatimTextOutput("summary"), 
    
    tableOutput("view")
  )
))