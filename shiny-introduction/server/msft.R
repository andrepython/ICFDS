serverFuncs$msft <- function(sp500Data){
  # Date range widget
  output$msftDateRangeWidget <- renderUI({
    shiny::req(sp500Data)
    
    dates     <- sp500Data[Ticker == "MSFT"]$Date
    minDate   <- min(dates)
    maxDate   <- max(dates)
    yearStart <- floor_date(maxDate, "year")
    
    dateRangeInput("msftDateRange", 
                   label = "Date Range", 
                   start = yearStart, 
                   end   = maxDate, 
                   min   = minDate,
                   max   = maxDate,
                   width = "100%")
  })
  
  output$msftPlot <- renderPlotly({
    
    shiny::req(sp500Data,
               input$msftDateRange)
    
    dateRange <- input$msftDateRange
    
    data    <- copy(sp500Data)[(Ticker == "MSFT") &
                               (Date >= min(dateRange)) &
                               (Date <= max(dateRange))]
    
    plot_ly(data,
            x     = ~Date, 
            type  = "candlestick",
            open  = ~Open, 
            close = ~Close,
            high  = ~High, 
            low   = ~Low) %>% 
      layout(title = "",
             xaxis = list(update_yaxes = list(fixedrange = FALSE)))
  })
}
