
<!-- README.md is generated from README.Rmd. Please edit that file -->
tsibbledata
===========

This package provides examples of [tsibble](https://github.com/tidyverts/tsibble) datasets which can be used within the tidyverts family of packages.

Installation
------------

You can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tidyverts/tsibbledata")
```

Example
-------

``` r
library(tsibbledata)
elecdemand
#> # A tsibble: 17,520 x 4 [30MINUTE]
#>    index               Demand WorkDay Temperature
#>    <dttm>               <dbl>   <dbl>       <dbl>
#>  1 2014-01-01 00:00:00   3.91       0        18.2
#>  2 2014-01-01 00:30:00   3.67       0        17.9
#>  3 2014-01-01 01:00:00   3.50       0        17.6
#>  4 2014-01-01 01:30:00   3.34       0        16.8
#>  5 2014-01-01 02:00:00   3.20       0        16.3
#>  6 2014-01-01 02:30:00   3.10       0        16.6
#>  7 2014-01-01 03:00:00   3.04       0        16.6
#>  8 2014-01-01 03:30:00   3.01       0        16.7
#>  9 2014-01-01 04:00:00   3.02       0        16.2
#> 10 2014-01-01 04:30:00   3.03       0        16.6
#> # ... with 17,510 more rows
```
