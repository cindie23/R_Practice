shinyUI(pageWithSidebar(
  
  headerPanel("renderUI and uiOutput"),
  
  sidebarPanel(
    selectInput("dataset", "Data set", as.list(c("mtcars", "morley", "rock"))),
    uiOutput("choose_columns")
  ),
  
  mainPanel(
    tableOutput("data_table")
  )  
))