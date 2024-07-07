rm(list = ls())

mainDir <- "C:/Users/kizhang/OneDrive - Microsoft/2024-07-08-hangzhou-conference/shiny-introduction"
setwd(mainDir)

library(data.table)

load("sp500.RData")

head(sp500)

class(sp500)

# Order the data table by Ticker and Date
setkey(sp500, Ticker, Date)

# Show information for the first available date for each stock
sp500[, .SD[1], by = Ticker]

# Calculate the minimum, maximum, and average price for each stock in 2024
sp500[Date >= as.Date("2024-01-01"), .(minPrice = min(Price),
                                       maxPrice = max(Price),
                                       avgPrice = mean(Price)), by = Ticker]

# Calculate the daily price difference
sp500[, priceChange := (Price - shift(Price, 1)), by = Ticker][]

sp500.long <- sp500[Ticker %in% c("MSFT", "AAPL", "GOOG", "AMZN"), .(Date, Price, Ticker)]
sp500.long

# Convert from long to wide format
sp500.wide <- dcast(sp500.long, Date ~ Ticker, value.var = "Price")
sp500.wide

# Convert from wide back to long format
melt(sp500.wide,
     id.vars = "Date",
     variable.name = "Ticker",
     value.name = "Price")

# Merge two data tables
listing <- fread("sp500.csv")
merge(sp500,
      listing,
      by.x = "Ticker",
      by.y = "Symbol")
