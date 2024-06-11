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
  }) %>% bindCache(file.info("sp500.csv")$mtime,
                   cache = cachem::cache_disk(dir = file.path(mainDir, "app_cache/cache/listing")))
  
  # Load the .RData file with stock prices for the S&P500
  sp500 <- reactive({
    load("sp500.RData")
    sp500
  })
  
  # Wrapper function for dropdown filters
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
  
  serverFuncs <- new.env()
  for(serverFile in list.files("server", full.names = TRUE)){
    source(serverFile, local = TRUE)
  }
  
  serverFuncs$sp500(sp500Data = copy(sp500()), listingData = copy(sp500listing()))
  serverFuncs$msft(sp500Data = copy(sp500()))
  serverFuncs$sectorCompare(sp500Data = copy(sp500()), listingData = copy(sp500listing()))
}