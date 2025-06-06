% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_fn.R
\name{get_historic_light}
\alias{get_historic_light}
\title{Get Historical Financial Data For Ticker Symbols}
\usage{
get_historic_light(
  symbols = "SAAB-B.ST",
  interval = "1d",
  range = "1mo",
  .verbose = F
)
}
\arguments{
\item{symbols}{\code{character} A character string representing the financial indices to search for, e.g., ticker symbol(s).}

\item{interval}{\code{character}, default = \code{"1d"}. The interval between 2 rows of the time.series answered.\tabular{l}{
   \strong{Valid \code{interval} values} \cr
   \code{"1m"},  \code{"5m"}, \code{"15m"}, \code{"1d"},  \code{"1wk"}, \code{"1mo"} \cr
}}

\item{range}{\code{character}, default = \code{"1y"}. The period covered by the time series.\tabular{l}{
   \strong{Valid \code{range} values} \cr
   \code{"1d"}, \code{"5d"}, \code{"1mo"}, \code{"3mo"}, \code{"6mo"}, \code{"1y"}, \code{"5y"}, \code{"max"} \cr
}}

\item{.verbose}{\code{logical}, default = \code{TRUE}. If \code{TRUE}, send messages to the console.}
}
\value{
A \code{data.frame} with a historical values :
\describe{
\item{symbol}{\code{character} - Financial ticker symbol.}
\item{timestamp}{\code{POSIXct} - Date of the observation (closing price).}
\item{close}{\code{numeric} - Closing price of the asset.}
}
}
\description{
Get an historic of stock market data for financial ticker symbols, e.g., values at each closing day.
}
\details{
Return a \code{data.frame} with additional attributes:
\describe{
\item{n.currencies}{\code{integer} - Number of unique currencies in the \code{data.frame}.}
\item{currencies}{\code{character} - A vector of currency symbols in the \code{data.frame} (e.g., \code{"BTC"}, \code{"ETH"}, \code{"USD"}).}
\item{exchange}{\code{character} - A vector of exchange pairs (e.g., \code{"BTC => USD"}). If not applicable, \code{NULL} (no entry).}
\item{date.fetch}{\code{Date} - The date when the data was retrieved, set using \code{Sys.Date()}.}
\item{crypto}{\code{logical} - \code{TRUE} if cryptocurrencies are present, otherwise \code{FALSE}.}
\item{date.begin}{\code{POSIXct} - The oldest observation in the dataset.}
\item{date.end}{\code{POSIXct} - The most recent observation in the dataset.}
\item{date.dif}{\code{numeric} - The number of \emph{seconds} between date.begin and date.end, equivalent of \code{difftime} value.}
}
See \code{vignette("Functions_summary", package = "financr")}
}
\examples{
histo_light <- get_historic_light(c("SAAB-B.ST", "AAPL"))
}
