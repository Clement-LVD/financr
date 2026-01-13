# Split df cols according to a separator (space the default)

Split df cols according to a separator (space the default)

## Usage

``` r
standardize_df_split_col_w_several_values(
  df,
  separator = "  ?",
  col_tolerate_separator = "name|symbol|date|time|exch"
)
```

## Arguments

- df:

  `data.frame` of raw values

- separator:

  `character` of safe separator for spliting values

- col_tolerate_separator:

  `character` of regex for colname that DON'T need to be split
