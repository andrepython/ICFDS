serverFuncs$sp500 <- function(sp500Data, listingData){
  # Date range widget
  output$dateRangeWidget <- renderUI({
    shiny::req(sp500Data)
    
    dates     <- sp500Data$Date
    minDate   <- min(dates)
    maxDate   <- max(dates)
    yearStart <- floor_date(maxDate, "year")
    
    dateRangeInput("dateRange", 
                   label = "Date Range", 
                   start = yearStart, 
                   end   = maxDate, 
                   min   = minDate,
                   max   = maxDate,
                   width = "100%")
  })
  
  # Widget to select securities to be shown in stock price comparison plot
  output$security <- renderUI({
    shiny::req(listingData)
    pickerInputWrapper(inputName       = "security",
                       label           = "Security",
                       inputChoices    = listingData$Security,
                       selectedChoices = c("Alphabet Inc. (Class A)", "Amazon", "Apple Inc.", "Meta Platforms", "Microsoft"))
  })
  
  pricePlotDateFilter <- reactive({
    shiny::req(input$dateRange)
    
    data <- copy(sp500Data)
    
    # Filter by date range
    dateRange <- input$dateRange
    data      <- data[(Date >= min(dateRange)) &
                        (Date <= max(dateRange))]
    
    firstDate    <- min(data[Date >= min(dateRange)]$Date)
    validTickers <- data[, .(minDate = min(Date)), by = Ticker][minDate == firstDate]$Ticker
    data         <- data[Ticker %in% validTickers]
    
    # Adjust prices to base 100 for comparison
    data[, Index := 100 * Price / Open[1], by = .(Ticker)]
    
    data
  })
  
  pricePlotSecurityFilter <- reactive({
    shiny::req(pricePlotDateFilter(),
               input$security)
    
    data <- copy(pricePlotDateFilter())
    
    # Filter by security
    data <- data[Ticker %in% listingData[Security %in% input$security]$Symbol]
    
    # Melt data
    data <- melt(data,
                 id.vars      = c("Date", "Ticker"),
                 measure.vars = "Index",
                 value.name   = "Index")
  })
  
  output$pricePlot <- renderPlotly({
    
    shiny::req(pricePlotSecurityFilter())
    
    data <- pricePlotSecurityFilter()
    
    plot_ly(data, 
            x      = ~Date, 
            y      = ~Index,
            color  = ~Ticker,
            # colors = lineColors,
            type   = "scatter", 
            mode   = "lines") %>%
      layout(xaxis = list(title = list(text = "")),
             yaxis = list(title = list(text = "")))
  })
}
