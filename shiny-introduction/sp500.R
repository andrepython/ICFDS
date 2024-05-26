rm(list = ls())

mainDir <- "C:/Users/kizhang/OneDrive - Microsoft/2024-07-08-conference"
setwd(mainDir)

library(data.table)
library(plotly)
library(quantmod)

data <- fread("sp500.csv")

tickers        <- data$Symbol#c("MSFT", "GOOG", "AAPL", "AMZN", "META")
names(tickers) <- tickers

stock.env <- new.env()
data      <- getSymbols(Symbols = tickers, src = "yahoo", env = stock.env)

sp500 <- lapply(tickers, function(i){ 
  data <- data.table(Date = index(stock.env[[i]]),
                     stock.env[[i]])[, Ticker := i]
  setnames(data, names(data), gsub(paste0(i, "\\."), "", names(data)))
  if(nrow(data) > 0){
    data
  } else {
    NULL
  }
})
sp500 <- do.call(rbind, sp500)[!is.na(Adjusted)]
setnames(sp500, "Adjusted", "Price")
setkey(sp500, Ticker, Date)

save(sp500, file = "sp500.RData")