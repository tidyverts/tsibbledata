
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
head(elecdemand)
#>                 index   Demand WorkDay Temperature
#> 1 2014-01-01 00:00:00 3.914647       0        18.2
#> 2 2014-01-01 00:30:00 3.672550       0        17.9
#> 3 2014-01-01 01:00:00 3.497539       0        17.6
#> 4 2014-01-01 01:30:00 3.339145       0        16.8
#> 5 2014-01-01 02:00:00 3.204313       0        16.3
#> 6 2014-01-01 02:30:00 3.100043       0        16.6
```
