% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/last_fn.R
\name{last_indices}
\alias{last_indices}
\title{Get World Financial Indices Latest Values (USD)}
\usage{
last_indices(.verbose = T, keep = NULL)
}
\arguments{
\item{.verbose}{\code{logical}, default = \code{TRUE} - If \code{TRUE}, send messages to the console if necessary.}

\item{keep}{\code{character} - Character vector of symbols to filter the results (perl expression, ignoring case). If \code{NULL} (default),
no filtering is applied, and all available indices are returned.}
}
\value{
A data frame with the following columns:
\item{symbol}{\code{character} - Ticker symbol of the index, aka world indices (e.g., \code{'^GSPC'} for S&P 500).}
\item{name}{\code{character} -  Full name of the index (e.g., "S&P 500").}
\item{price}{\code{numeric} - Current value of the index (USD).}
\item{change}{\code{numeric} - Absolute change in index value since the last closing of the exchange place.}
\item{change_percent}{\code{numeric} - Percentage change in index value since the last closing of the exchange place.}
\item{volume}{\code{numeric} - The total trading volume of the index components.}
\item{currency}{\code{character} - Currency associated with the world-indice, i.e. 'USD'.}
}
\description{
Get latest stock market indices values and data for more than 40 world-indices,
e.g., latest prices, change and percentage change.
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
\dontrun{
indices <- last_indices()
head(indices)
}
}
\references{
Source : Yahoo's world indices page - https://finance.yahoo.com/markets/world-indices
}
\seealso{
For more details on the 'last_' family of functions see the help vignette:
\code{vignette("last_family", package = "financr")}
}
