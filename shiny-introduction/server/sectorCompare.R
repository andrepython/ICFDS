serverFuncs$sectorCompare <- function(sp500Data, listingData){
  
  # Sector date range widget
  output$sectorDateRangeWidget <- renderUI({
    shiny::req(sp500Data)
    
    dates     <- sp500Data$Date
    minDate   <- min(dates)
    maxDate   <- max(dates)
    yearStart <- floor_date(maxDate, "year")
    
    dateRangeInput("sectorDateRange", 
                   label = "Date Range", 
                   start = yearStart, 
                   end   = maxDate, 
                   min   = minDate,
                   max   = maxDate,
                   width = "100%")
  })
  
  output$sectorWidget <- renderUI({
    shiny::req(listingData)
    pickerInputWrapper(inputName    = "sector",
                       label        = "Sector",
                       inputChoices = listingData$`Sector`)
  })
  
  sectorData <- reactive({
    shiny::req(listingData,
               sp500Data,
               input$sector,
               input$sectorDateRange)
    
    listing <- listingData
    data    <- copy(sp500Data)
    
    # Filter by date range
    dateRange <- input$sectorDateRange
    data     <- data[(Date >= min(dateRange)) &
                       (Date <= max(dateRange))]
    
    # Filter by sector
    data <- data[Ticker %in% listing[`Sector` %in% input$sector]$Symbol]
    
    firstDate    <- min(data[Date >= min(dateRange)]$Date)
    validTickers <- data[, .(minDate = min(Date)), by = Ticker][minDate == firstDate]$Ticker
    data         <- data[Ticker %in% validTickers]
    
    # Calculate return
    data[, Return := (Price - Open[1]) / Open[1], by = .(Ticker)]
    
    data <- data[, .SD[.N], by = .(Ticker)]
    
    data <- merge(data,
                  listing,
                  by.x = "Ticker",
                  by.y = "Symbol")
    
    data[, label := paste0("Security: ",
                           Security,
                           "\nSector: ",
                           `Sector`,
                           "\nReturn: ",
                           format(round(100 * Return, 2), nsmall = 2),
                           paste0("%"))]
    
    data
  })
  
  output$sectorPlot <- renderPlotly({
    shiny::req(sectorData())
    plot_ly(sectorData(),
            y         = ~Return, 
            color     = ~Sector, 
            hoverinfo = "text",
            hovertext = ~label,
            # name      = ~Sector,
            boxpoints = "all",
            jitter    = .3,
            source    = "sectorBoxplot",
            type      = "box") %>%
      layout(yaxis = list(tickformat = ".0%"),
             xaxis = list(tickangle = 320))
  })
  
  output$sectorTable <- renderReactable({
    shiny::req(event_data("plotly_click", source = "sectorBoxplot"))
    
    data <- copy(sectorData())[, .(Ticker, Security, Return, Sector, Industry, Headquarters, Founded, `Date Added`)]
    
    # Filter by sector
    sectorClicked <- event_data("plotly_click", source = "sectorBoxplot")$x[1]
    data          <- data[`Sector` == sectorClicked]
    
    reactable(data,
              # defaultColDef   = colDef(vAlign      = "center",
              #                          header      = function(value){ gsub(".", " ", value, fixed = TRUE) },
              #                          cell        = function(value){ format(value, nsmall = 0) },
              #                          align       = "center",
              #                          html        = TRUE,
              #                          minWidth    = 20,
              #                          headerStyle = list(background = "#f7f7f8")),
              columns         = list(Return = colDef(format = colFormat(percent = TRUE,
                                                                        digits  = 2))),
              striped         = TRUE,
              bordered        = TRUE,
              highlight       = TRUE)
  }) 
}
