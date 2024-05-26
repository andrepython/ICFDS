server <- function(input, output, session){
  
  # Read the csv that lists all of the securities in the S&P500
  sp500listing <- reactive({
    listing <- fread("sp500.csv")
    listing[, Security := gsub("\xa0", " ", Security)]
    setnames(listing, 
             c("Date added", "Headquarters Location", "GICS Sector", "GICS Sub-Industry"), 
             c("Date Added", "Headquarters", "Sector", "Industry"))
    listing[, `Date Added` := as.Date(`Date Added`, "%m/%d/%Y")]
    listing
  })
  
  # Load the .RData file with stock prices for the S&P500
  sp500 <- reactive({
    load("sp500.RData")
    sp500
  })
  
  # Date range widget
  output$dateRangeWidget <- renderUI({
    shiny::req(sp500())
    
    dates     <- sp500()$Date
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
  
  pickerInputWrapper <- function(inputName, label, inputChoices, selectedChoices = inputChoices){
    inputChoices <- sort(unique(inputChoices))
    pickerInput(inputName, 
                label, 
                selected = selectedChoices, 
                choices  = inputChoices, 
                options  = list(`actions-box`         = TRUE, 
                                `live-search`         = TRUE, 
                                `selected-text-format` = paste0("count > ", length(inputChoices) - 1), 
                                `count-selected-text`  = "All"), 
                multiple = TRUE)
  }
  
  output$sectorWidget <- renderUI({
    shiny::req(sp500listing())
    pickerInputWrapper(inputName    = "sector",
                       label        = "Sector",
                       inputChoices = sp500listing()$`Sector`)
  })
  
  output$industry <- renderUI({
    shiny::req(sp500listing())
    pickerInputWrapper(inputName    = "industry",
                       label        = "Industry",
                       inputChoices = sp500listing()$`Industry`)
  })
  
  # Widget to select securities to be shown in stock price comparison plot
  output$security <- renderUI({
    shiny::req(sp500listing())
    pickerInputWrapper(inputName       = "security",
                       label           = "Security",
                       inputChoices    = sp500listing()$Security,
                       selectedChoices = c("Alphabet Inc. (Class A)", "Amazon", "Apple Inc.", "Meta Platforms", "Microsoft"))
  })
  
  output$pricePlot <- renderPlotly({
    
    shiny::req(sp500listing(),
               sp500(),
               input$security,
               input$dateRange)
    
    listing <- sp500listing()
    data    <- copy(sp500())
    
    # Filter by date range
    dateRange <- input$dateRange
    data     <- data[(Date >= min(dateRange)) &
                       (Date <= max(dateRange))]
    
    firstDate    <- min(data[Date >= min(dateRange)]$Date)
    validTickers <- data[, .(minDate = min(Date)), by = Ticker][minDate == firstDate]$Ticker
    data         <- data[Ticker %in% validTickers]
    
    # Filter by security
    data <- data[Ticker %in% listing[Security %in% input$security]$Symbol]
    
    # Adjust prices to base 100 for comparison
    data[, Index := 100 * Price / Open[1], by = .(Ticker)]
    
    data <- melt(data,
                 id.vars      = c("Date", "Ticker"),
                 measure.vars = "Index",
                 value.name   = "Index")
    
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
  
  # Date range widget
  output$msftDateRangeWidget <- renderUI({
    shiny::req(sp500())
    
    dates     <- sp500()[Ticker == "MSFT"]$Date
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
    
    shiny::req(sp500(),
               input$msftDateRange)
    
    dateRange <- input$msftDateRange
    
    data    <- copy(sp500())[(Ticker == "MSFT") &
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
  
  
  # Sector date range widget
  output$sectorDateRangeWidget <- renderUI({
    shiny::req(sp500())
    
    dates     <- sp500()$Date
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
  
  sectorData <- reactive({
    shiny::req(sp500listing(),
               sp500(),
               input$sector,
               input$sectorDateRange)
    
    listing <- sp500listing()
    data    <- copy(sp500())
    
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