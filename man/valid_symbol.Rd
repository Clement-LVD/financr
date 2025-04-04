% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/valid_symbol.R
\name{valid_symbol}
\alias{valid_symbol}
\title{Validate Financial Symbols}
\usage{
valid_symbol(symbols = NULL, ..., .verbose = T)
}
\arguments{
\item{symbols}{\code{character} A string or a list of character strings representing financial symbols to validate.}

\item{...}{Other symbols (char. or list of char.)}

\item{.verbose}{\code{logical} If TRUE, messages are displayed when invalid symbols are detected. Default is TRUE.}
}
\value{
A boolean table with one row and as many columns as the number of \emph{unique} symbols provided by the user.
Each column corresponds to a symbol, with TRUE if Yahoo Finance recognizes the symbol, and FALSE otherwise.
}
\description{
This function checks the validity of one or multiple financial symbols using Yahoo Finance's validation API.
It returns a table of boolean values indicating whether each symbol is recognized by Yahoo Finance.
}
\examples{
valid_symbol("AAPL,GOOGL")
valid_symbol(symbols = c("AAPL", "GOOGL", "INVALID"))
}
\references{
Source : https://query2.finance.yahoo.com/v6/finance/quote/validate
}
