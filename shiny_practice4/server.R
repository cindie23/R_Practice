shinyServer(function(input, output) {
  
  output$choose_columns <- renderUI({
    if (is.null(input$dataset)) return()
    dat <- get(input$dataset)
    colnames <- names(dat)
    checkboxGroupInput("columns", "Choose columns", choices = colnames, 
                       selected = colnames)
  })
  
  output$data_table <- renderTable({
    if (is.null(input$dataset)) return()        
    dat <- get(input$dataset)        
    if (is.null(input$columns) || !(input$columns %in% names(dat))) return()
    dat <- dat[, input$columns, drop = FALSE]
    head(dat, 20)
  })
})